-- Synthetic test data only. This script assumes the schema is empty or that
-- these test identifiers have not already been inserted. Unique-key conflicts
-- on reruns are expected; use a clean test database for repeatable execution.

USE blitzfintech_db;

INSERT INTO customer
(customer_number, party_type, full_name, email, phone, customer_status, kyc_status, risk_rating)
VALUES
('BF-TEST-C001', 'INDIVIDUAL', 'Test Customer One', 'bf-test1@example.com', '08000000001', 'ACTIVE', 'APPROVED', 'LOW'),
('BF-TEST-C002', 'INDIVIDUAL', 'Test Customer Two', 'bf-test2@example.com', '08000000002', 'ACTIVE', 'APPROVED', 'STANDARD'),
('BF-TEST-C003', 'ORGANISATION', 'Blitz Demo Trading Ltd', 'bf-test3@example.com', '08000000003', 'ACTIVE', 'APPROVED', 'STANDARD');

INSERT INTO individual_customer (customer_id, date_of_birth, identity_country)
SELECT customer_id, '1995-01-15', 'NG'
FROM customer WHERE customer_number = 'BF-TEST-C001';

INSERT INTO individual_customer (customer_id, date_of_birth, identity_country)
SELECT customer_id, '1990-06-20', 'NG'
FROM customer WHERE customer_number = 'BF-TEST-C002';

INSERT INTO organisation_customer (customer_id, registration_country)
SELECT customer_id, 'NG'
FROM customer WHERE customer_number = 'BF-TEST-C003';

INSERT INTO account
(account_number, account_type, currency, balance, account_status)
VALUES
('BF-TEST-A001', 'SAVINGS', 'NGN', 10000.0000, 'ACTIVE'),
('BF-TEST-A002', 'SAVINGS', 'NGN', 5000.0000, 'ACTIVE');

INSERT INTO account_party (account_id, customer_id, party_role)
SELECT a.account_id, c.customer_id, 'HOLDER'
FROM account a JOIN customer c
  ON a.account_number = 'BF-TEST-A001'
 AND c.customer_number = 'BF-TEST-C001';

INSERT INTO account_party (account_id, customer_id, party_role)
SELECT a.account_id, c.customer_id, 'HOLDER'
FROM account a JOIN customer c
  ON a.account_number = 'BF-TEST-A002'
 AND c.customer_number = 'BF-TEST-C002';

INSERT INTO kyc_case (customer_id, case_type, case_status)
SELECT customer_id, 'ONBOARDING', 'APPROVED'
FROM customer WHERE customer_number = 'BF-TEST-C001';

INSERT INTO account_mandate
(account_id, mandate_reference, mandate_status, effective_from, required_approvals)
SELECT account_id, 'BF-TEST-M001', 'ACTIVE', CURRENT_DATE, 1
FROM account WHERE account_number = 'BF-TEST-A001';

INSERT INTO mandate_signatory (mandate_id, customer_id, authority_role, individual_limit)
SELECT m.mandate_id, c.customer_id, 'ADMINISTRATOR', 100000.0000
FROM account_mandate m JOIN customer c
  ON m.mandate_reference = 'BF-TEST-M001'
 AND c.customer_number = 'BF-TEST-C001';

INSERT INTO financial_transaction
(transaction_reference, transaction_type, amount, currency, transaction_status, initiated_by)
VALUES
('BF-TEST-TX001', 'DEPOSIT', 1000.0000, 'NGN', 'PENDING', 'portfolio-test-user');

SELECT customer_number, party_type, customer_status, kyc_status
FROM customer WHERE customer_number LIKE 'BF-TEST-%';

SELECT account_number, currency, balance, account_status
FROM account WHERE account_number LIKE 'BF-TEST-%';
