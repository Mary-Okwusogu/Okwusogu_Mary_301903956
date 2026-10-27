-- REVIEW BEFORE INSTALLATION. Intended for the uploaded Portfolio 1 schema, not a live production system.
-- Outgoing transactions on accounts with active mandates are deliberately blocked;
-- approval workflow is not defined by Portfolio 1 and must not be bypassed.
-- Deposits/withdrawals have single-sided ledger entries: external clearing is not modeled.
USE blitzfintech_db;
DELIMITER $$
DROP PROCEDURE IF EXISTS sp_post_financial_transaction$$
CREATE PROCEDURE sp_post_financial_transaction(
 IN p_reference VARCHAR(64), IN p_key VARCHAR(100), IN p_type VARCHAR(20),
 IN p_source BIGINT UNSIGNED, IN p_destination BIGINT UNSIGNED,
 IN p_amount DECIMAL(19,4), IN p_currency CHAR(3), IN p_actor VARCHAR(100)
)
main: BEGIN
 DECLARE v_low BIGINT UNSIGNED;
 DECLARE v_high BIGINT UNSIGNED;
 DECLARE v_id BIGINT UNSIGNED;
 DECLARE v_existing BIGINT UNSIGNED;
 DECLARE v_hash CHAR(64);
 DECLARE v_old_hash CHAR(64);
 DECLARE v_req_status VARCHAR(20);
 DECLARE v_status VARCHAR(20);
 DECLARE v_currency CHAR(3);
 DECLARE v_balance DECIMAL(19,4);
 DECLARE v_found INT DEFAULT 0;
 DECLARE v_mandates INT DEFAULT 0;
 DECLARE v_eligible INT DEFAULT 0;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 IF p_reference IS NULL OR CHAR_LENGTH(TRIM(p_reference))=0
    OR p_key IS NULL OR CHAR_LENGTH(TRIM(p_key))=0
    OR p_actor IS NULL OR CHAR_LENGTH(TRIM(p_actor))=0
    OR p_type IS NULL OR p_type NOT IN ('DEPOSIT','WITHDRAWAL','TRANSFER')
    OR p_amount IS NULL OR p_amount<=0 OR p_currency IS NULL OR p_currency <> 'NGN'
    OR (p_type='DEPOSIT' AND (p_destination IS NULL OR p_source IS NOT NULL))
    OR (p_type='WITHDRAWAL' AND (p_source IS NULL OR p_destination IS NOT NULL))
    OR (p_type='TRANSFER' AND (p_source IS NULL OR p_destination IS NULL OR p_source=p_destination))
 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid posting request'; END IF;
 -- Unambiguous canonical encoding: JSON_ARRAY creates length-aware serialized values.
 SET v_hash=SHA2(CAST(JSON_ARRAY(p_reference,p_type,p_source,p_destination,p_amount,p_currency,p_actor) AS CHAR),256);
 START TRANSACTION;
 -- Unique key serializes concurrent identical requests; duplicates wait for commit.
 INSERT INTO idempotency_request(idempotency_key,request_hash,request_status)
 VALUES(p_key,v_hash,'PROCESSING')
 ON DUPLICATE KEY UPDATE idempotency_key=VALUES(idempotency_key);
 SELECT request_hash,transaction_id,request_status
 INTO v_old_hash,v_existing,v_req_status
 FROM idempotency_request WHERE idempotency_key=p_key FOR UPDATE;
 IF v_old_hash<>v_hash THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Idempotency key payload conflict'; END IF;
 IF v_req_status='COMPLETED' AND v_existing IS NOT NULL THEN
   COMMIT;
   SELECT v_existing AS transaction_id,'ALREADY_POSTED' AS result;
   LEAVE main;
 END IF;
 IF v_req_status <> 'PROCESSING' OR v_existing IS NOT NULL THEN
   SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Idempotency request in unexpected state';
 END IF;
 -- Lock all involved accounts in ascending account_id order (explicit point lookups).
 SET v_low=CASE WHEN p_source IS NULL THEN p_destination WHEN p_destination IS NULL THEN p_source ELSE LEAST(p_source,p_destination) END;
 SET v_high=CASE WHEN p_source IS NULL THEN NULL WHEN p_destination IS NULL THEN NULL ELSE GREATEST(p_source,p_destination) END;
 SET v_found=0;
 SELECT COUNT(*) INTO v_found FROM account WHERE account_id=v_low;
 IF v_found<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Account not found'; END IF;
 SELECT account_status,currency,balance INTO v_status,v_currency,v_balance FROM account WHERE account_id=v_low FOR UPDATE;
 IF v_status<>'ACTIVE' OR v_currency<>p_currency THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Account inactive or currency mismatch'; END IF;
 IF v_high IS NOT NULL THEN
   SELECT COUNT(*) INTO v_found FROM account WHERE account_id=v_high;
   IF v_found<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Account not found'; END IF;
   SELECT account_status,currency,balance INTO v_status,v_currency,v_balance FROM account WHERE account_id=v_high FOR UPDATE;
   IF v_status<>'ACTIVE' OR v_currency<>p_currency THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Account inactive or currency mismatch'; END IF;
 END IF;
 -- Check all linked holders for basic customer/KYC eligibility.
 SELECT COUNT(*) INTO v_eligible FROM account_party ap JOIN customer c ON c.customer_id=ap.customer_id
 WHERE ap.account_id=v_low AND ap.party_role IN ('HOLDER','JOINT_HOLDER') AND c.customer_status='ACTIVE' AND c.kyc_status='APPROVED';
 IF v_eligible=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Account has no eligible holder'; END IF;
 IF v_high IS NOT NULL THEN
   SELECT COUNT(*) INTO v_eligible FROM account_party ap JOIN customer c ON c.customer_id=ap.customer_id
   WHERE ap.account_id=v_high AND ap.party_role IN ('HOLDER','JOINT_HOLDER') AND c.customer_status='ACTIVE' AND c.kyc_status='APPROVED';
   IF v_eligible=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Account has no eligible holder'; END IF;
 END IF;
 IF p_source IS NOT NULL THEN
   -- Mandated accounts require separate approval workflow, not provided in the schema scripts.
   SELECT COUNT(*) INTO v_mandates FROM account_mandate
   WHERE account_id=p_source AND mandate_status='ACTIVE'
   AND effective_from<=CURRENT_DATE AND (effective_to IS NULL OR effective_to>=CURRENT_DATE);
   IF v_mandates>0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Active mandate requires approval workflow; posting blocked'; END IF;
 END IF;
 INSERT INTO financial_transaction(transaction_reference,transaction_type,amount,currency,transaction_status,initiated_by,idempotency_key)
 VALUES(p_reference,p_type,p_amount,p_currency,'PENDING',p_actor,p_key);
 SET v_id=LAST_INSERT_ID();
 IF p_source IS NOT NULL THEN
   UPDATE account SET balance=balance-p_amount
   WHERE account_id=p_source AND account_status='ACTIVE' AND balance>=p_amount;
   IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Insufficient funds or inactive source'; END IF;
   INSERT INTO ledger_entry(transaction_id,account_id,entry_type,amount) VALUES(v_id,p_source,'DEBIT',p_amount);
 END IF;
 IF p_destination IS NOT NULL THEN
   UPDATE account SET balance=balance+p_amount WHERE account_id=p_destination AND account_status='ACTIVE';
   IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Destination account update failed'; END IF;
   INSERT INTO ledger_entry(transaction_id,account_id,entry_type,amount) VALUES(v_id,p_destination,'CREDIT',p_amount);
 END IF;
 UPDATE financial_transaction SET transaction_status='POSTED',posted_at=CURRENT_TIMESTAMP WHERE transaction_id=v_id;
 UPDATE idempotency_request SET transaction_id=v_id,request_status='COMPLETED' WHERE idempotency_key=p_key;
 INSERT INTO audit_log(actor_type,actor_id,action_type,entity_type,entity_id,reason,after_data)
 VALUES('USER',p_actor,'POST_TRANSACTION','FINANCIAL_TRANSACTION',CAST(v_id AS CHAR),'Atomic financial posting',
 JSON_OBJECT('reference',p_reference,'type',p_type,'amount',p_amount,'currency',p_currency,'source',p_source,'destination',p_destination));
 COMMIT;
 SELECT v_id AS transaction_id,'POSTED' AS result;
END$$
DELIMITER ;
