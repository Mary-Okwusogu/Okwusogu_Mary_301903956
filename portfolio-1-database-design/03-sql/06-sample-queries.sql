USE blitzfintech_db;

-- 1. Customers and KYC status
SELECT customer_number, full_name, party_type, customer_status, kyc_status
FROM customer
ORDER BY created_at DESC;

-- 2. Account holders
SELECT a.account_number, a.currency, a.balance, a.account_status,
       c.customer_number, c.full_name, ap.party_role
FROM account a
JOIN account_party ap ON ap.account_id = a.account_id
JOIN customer c ON c.customer_id = ap.customer_id
ORDER BY a.account_number, c.customer_number;

-- 3. Documents requiring attention because pending, rejected or expired
SELECT d.document_id, c.customer_number, c.full_name,
       d.document_type, d.verification_status, d.expires_at
FROM customer_document d
JOIN customer c ON c.customer_id = d.customer_id
WHERE d.verification_status IN ('PENDING','REJECTED','EXPIRED')
   OR (d.expires_at IS NOT NULL AND d.expires_at < CURRENT_DATE)
ORDER BY d.expires_at;

-- 4. Transaction headers
SELECT transaction_reference, transaction_type, amount, currency,
       transaction_status, created_at, posted_at
FROM financial_transaction
ORDER BY created_at DESC;

-- 5. Ledger activity for one account
SELECT a.account_number, le.created_at, ft.transaction_reference,
       ft.transaction_type, le.entry_type, le.amount
FROM ledger_entry le
JOIN account a ON a.account_id = le.account_id
JOIN financial_transaction ft ON ft.transaction_id = le.transaction_id
WHERE a.account_number = 'BF-TEST-A001'
ORDER BY le.created_at DESC, le.ledger_entry_id DESC;

-- 6. Active mandates approaching expiry within 30 days
SELECT a.account_number, m.mandate_reference, m.effective_from, m.effective_to
FROM account_mandate m
JOIN account a ON a.account_id = m.account_id
WHERE m.mandate_status = 'ACTIVE'
  AND m.effective_to IS NOT NULL
  AND m.effective_to BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)
ORDER BY m.effective_to;

-- 7. Audit history for a particular entity
SELECT actor_type, actor_id, action_type, entity_type, entity_id,
       event_timestamp, reason
FROM audit_log
WHERE entity_type = 'ACCOUNT'
ORDER BY event_timestamp DESC;
