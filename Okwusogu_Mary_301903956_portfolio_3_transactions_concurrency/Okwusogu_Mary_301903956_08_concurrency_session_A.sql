-- Session A: execute against approved test data. Session B runs simultaneously.
USE blitzfintech_db;
SET @src=(SELECT account_id FROM account WHERE account_number='BF-TEST-A002');
CALL sp_post_financial_transaction('P3-CONCUR-A','P3-KEY-CONCUR-A','WITHDRAWAL',@src,NULL,4000.0000,'NGN','portfolio-test-user');
