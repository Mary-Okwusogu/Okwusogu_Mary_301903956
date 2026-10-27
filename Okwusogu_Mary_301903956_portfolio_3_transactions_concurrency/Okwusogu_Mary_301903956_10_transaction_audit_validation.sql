USE blitzfintech_db;
SELECT ft.transaction_reference FROM financial_transaction ft
LEFT JOIN idempotency_request ir ON ir.transaction_id=ft.transaction_id AND ir.request_status='COMPLETED'
LEFT JOIN audit_log al ON al.entity_type='FINANCIAL_TRANSACTION' AND al.entity_id=CAST(ft.transaction_id AS CHAR) AND al.action_type='POST_TRANSACTION'
WHERE ft.transaction_status='POSTED' AND ft.transaction_reference LIKE 'P3-%'
AND (ir.idempotency_id IS NULL OR al.audit_id IS NULL);
SELECT transaction_reference,transaction_status,posted_at FROM financial_transaction WHERE transaction_reference LIKE 'P3-%';
