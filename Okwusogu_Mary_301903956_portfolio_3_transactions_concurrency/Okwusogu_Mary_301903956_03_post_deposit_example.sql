-- EXECUTE ONLY on approved disposable test accounts after backup.
USE blitzfintech_db;
SET @dst=(SELECT account_id FROM account WHERE account_number='BF-ACCT-0003');
CALL sp_post_financial_transaction('P3-DEPOSIT-001','P3-KEY-DEPOSIT-001','DEPOSIT',NULL,@dst,100.0000,'NGN','portfolio-test-user');
