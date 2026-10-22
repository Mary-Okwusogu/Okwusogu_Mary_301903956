-- BlitzFintech constraint validation.
-- IMPORTANT:
-- 1. Run the positive checks first.
-- 2. Run each NEGATIVE TEST separately; each should raise an SQL error.
-- 3. Never use real/production data for these tests.
-- 4. If an invalid row is accepted, investigate the relevant constraint.

USE blitzfintech_db;

-- A. Positive checks: expected to return rows.
SELECT TABLE_NAME, ENGINE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_TYPE = 'BASE TABLE'
  AND ENGINE <> 'InnoDB'; -- Expected: zero rows.

SELECT customer_number, COUNT(*) AS n
FROM customer
GROUP BY customer_number
HAVING COUNT(*) > 1; -- Expected: zero rows.

SELECT transaction_reference, COUNT(*) AS n
FROM financial_transaction
GROUP BY transaction_reference
HAVING COUNT(*) > 1; -- Expected: zero rows.

-- B. Negative tests: uncomment and run ONE statement at a time.
-- Expected: duplicate-key error.
-- INSERT INTO customer (customer_number, party_type, full_name)
-- VALUES ('BF-TEST-C001', 'INDIVIDUAL', 'Duplicate Customer');

-- Expected: NOT NULL error.
-- INSERT INTO customer (customer_number, party_type, full_name)
-- VALUES ('BF-TEST-C999', 'INDIVIDUAL', NULL);

-- Expected: CHECK error for invalid party_type.
-- INSERT INTO customer (customer_number, party_type, full_name)
-- VALUES ('BF-TEST-C998', 'INVALID', 'Invalid Type');

-- Expected: CHECK error for negative balance.
-- UPDATE account SET balance = -1
-- WHERE account_number = 'BF-TEST-A001';

-- Expected: CHECK error for invalid account status.
-- UPDATE account SET account_status = 'INVALID'
-- WHERE account_number = 'BF-TEST-A001';

-- Expected: CHECK error for amount = 0.
-- INSERT INTO financial_transaction
-- (transaction_reference, transaction_type, amount, currency, initiated_by)
-- VALUES ('BF-TEST-BADAMT', 'TRANSFER', 0, 'NGN', 'test-user');

-- Expected: CHECK error for invalid ledger entry type.
-- Use existing IDs if your server reports a foreign-key error first.
-- INSERT INTO ledger_entry (transaction_id, account_id, entry_type, amount)
-- SELECT t.transaction_id, a.account_id, 'INVALID', 100
-- FROM financial_transaction t
-- CROSS JOIN account a
-- WHERE t.transaction_reference = 'BF-TEST-TX001'
--   AND a.account_number = 'BF-TEST-A001';

-- Expected: foreign-key error because referenced IDs do not exist.
-- INSERT INTO account_party (account_id, customer_id, party_role)
-- VALUES (99999999, 99999999, 'HOLDER');

-- Expected: duplicate account-number error.
-- INSERT INTO account (account_number, account_type, currency, balance, account_status)
-- VALUES ('BF-TEST-A001', 'SAVINGS', 'NGN', 0, 'PENDING');

-- C. Rollback demonstration. Record the original balance first.
SELECT account_number, balance
FROM account WHERE account_number = 'BF-TEST-A001';

START TRANSACTION;
UPDATE account
SET balance = balance - 1000
WHERE account_number = 'BF-TEST-A001';
SELECT account_number, balance
FROM account WHERE account_number = 'BF-TEST-A001';
ROLLBACK;

-- Expected: balance is restored to the value recorded before START TRANSACTION.
SELECT account_number, balance
FROM account WHERE account_number = 'BF-TEST-A001';

-- D. Referential-integrity audit. Expected: zero rows.
SELECT ap.*
FROM account_party ap
LEFT JOIN account a ON a.account_id = ap.account_id
LEFT JOIN customer c ON c.customer_id = ap.customer_id
WHERE a.account_id IS NULL OR c.customer_id IS NULL;

-- E. Ledger reconciliation. This query finds transactions whose total debit
-- differs from total credit. It is an exception report, not a posting control.
SELECT transaction_id,
       SUM(CASE WHEN entry_type = 'DEBIT' THEN amount ELSE 0 END) AS total_debits,
       SUM(CASE WHEN entry_type = 'CREDIT' THEN amount ELSE 0 END) AS total_credits
FROM ledger_entry
GROUP BY transaction_id
HAVING total_debits <> total_credits;
