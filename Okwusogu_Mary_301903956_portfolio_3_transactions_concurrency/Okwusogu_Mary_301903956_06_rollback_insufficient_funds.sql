USE blitzfintech_db;
SET @src=(SELECT account_id FROM account WHERE account_number='BF-TEST-A002');
-- Expect SQLSTATE 45000; no committed financial rows.
CALL sp_post_financial_transaction('P3-INSUFFICIENT-001','P3-KEY-INSUFFICIENT-001','WITHDRAWAL',@src,NULL,999999999999.0000,'NGN','portfolio-test-user');
SELECT * FROM financial_transaction WHERE transaction_reference='P3-INSUFFICIENT-001';
SELECT * FROM idempotency_request WHERE idempotency_key='P3-KEY-INSUFFICIENT-001';
