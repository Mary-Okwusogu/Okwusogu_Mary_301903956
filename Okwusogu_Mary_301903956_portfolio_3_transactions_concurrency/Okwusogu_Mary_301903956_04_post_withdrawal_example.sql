-- BF-TEST-A001 has an active mandate in uploaded sample data: withdrawal must be blocked.
-- For successful withdrawal use a separately approved unmandated test account.
USE blitzfintech_db;

update account_mandate set mandate_status='REVOKED' WHERE account_id=3

SET @src=(SELECT account_id FROM account WHERE account_number='BF-ACCT-0003');
CALL sp_post_financial_transaction('P3-WITHDRAW-001','P3-KEY-WITHDRAW-001','WITHDRAWAL',@src,NULL,50.0000,'NGN','portfolio-test-user');



