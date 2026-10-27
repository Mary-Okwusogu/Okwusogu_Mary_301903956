-- Transfer FROM A002 (unmandated) TO A001; reverse direction is blocked by mandate.
USE blitzfintech_db;
SET @src=(SELECT account_id FROM account WHERE account_number='BF-TEST-A002');
SET @dst=(SELECT account_id FROM account WHERE account_number='BF-TEST-A001');
CALL sp_post_financial_transaction('P3-TRANSFER-001','P3-KEY-TRANSFER-001','TRANSFER',@src,@dst,75.0000,'NGN','portfolio-test-user');
