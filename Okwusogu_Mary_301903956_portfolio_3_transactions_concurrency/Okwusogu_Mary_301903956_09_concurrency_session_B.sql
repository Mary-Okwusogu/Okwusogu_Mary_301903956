-- Session B: start at same time as Session A. Outcomes depend on starting balance.
USE blitzfintech_db;
SET @src=(SELECT account_id FROM account WHERE account_number='BF-TEST-A002');
CALL sp_post_financial_transaction('P3-CONCUR-B','P3-KEY-CONCUR-B','WITHDRAWAL',@src,NULL,4000.0000,'NGN','portfolio-test-user');
-- Repeat with same key/reference in both sessions to test unique-key serialization.
