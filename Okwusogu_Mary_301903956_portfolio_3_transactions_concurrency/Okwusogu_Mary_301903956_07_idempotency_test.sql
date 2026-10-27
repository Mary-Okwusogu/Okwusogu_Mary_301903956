USE blitzfintech_db;
SET @dst=(SELECT account_id FROM account WHERE account_number='BF-TEST-A002');
-- Run twice: second returns ALREADY_POSTED, one transaction total.
CALL sp_post_financial_transaction('P3-IDEMP-001','P3-KEY-IDEMP-001','DEPOSIT',NULL,@dst,10.0000,'NGN','portfolio-test-user');
CALL sp_post_financial_transaction('P3-IDEMP-001','P3-KEY-IDEMP-001','DEPOSIT',NULL,@dst,10.0000,'NGN','portfolio-test-user');
-- Expect conflict, with no additional posting.
CALL sp_post_financial_transaction('P3-IDEMP-001','P3-KEY-IDEMP-001','DEPOSIT',NULL,@dst,11.0000,'NGN','portfolio-test-user');
