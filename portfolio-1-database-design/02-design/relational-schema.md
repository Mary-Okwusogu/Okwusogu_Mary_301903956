# BlitzFintech Relational Schema

## Notation
- **PK**: primary key
- **FK**: foreign key
- **UQ**: unique constraint
- **NN**: NOT NULL
- `1:N`: one-to-many
- `M:N`: many-to-many resolved by an associative table

## Tables

### `customer`
- `customer_id` BIGINT UNSIGNED — PK
- `customer_number` VARCHAR(30) — NN, UQ
- `party_type` — INDIVIDUAL or ORGANISATION
- `full_name`, `email`, `phone`
- `customer_status`, `kyc_status`, `risk_rating`
- `created_at`, `updated_at`

### `individual_customer`
- `customer_id` — PK and FK to `customer`
- `date_of_birth`, `identity_country`, `identity_reference` (optional)

### `organisation_customer`
- `customer_id` — PK and FK to `customer`
- `registration_number` (optional UQ), `registration_country`, `incorporated_at`

### `account`
- `account_id` — PK
- `account_number` — NN, UQ
- `account_type`, `currency`, `balance`, `account_status`
- `created_at`, `closed_at`

### `account_party`
- Composite PK: (`account_id`, `customer_id`, `party_role`)
- FKs to `account` and `customer`
- `party_role`, `created_at`
- Resolves the M:N account/customer relationship.

### `kyc_case`
- `kyc_case_id` — PK
- `customer_id` — FK to `customer`
- `case_type`, `case_status`, `opened_at`, `closed_at`

### `customer_document`
- `document_id` — PK
- `customer_id` — FK to `customer`; optional FK to `kyc_case`
- `document_type`, `storage_object_key`, `sha256_checksum`, `mime_type`
- `issued_at`, `expires_at`, `verification_status`, `submitted_at`

### `kyc_review`
- `kyc_review_id` — PK
- `kyc_case_id` — FK to `kyc_case`
- `reviewer_user_id`, `decision`, `reason`, `reviewed_at`
- Reviewer identity may later reference a dedicated `app_user` table.

### `account_mandate`
- `mandate_id` — PK
- `account_id` — FK to `account`
- `mandate_reference` — UQ
- `mandate_status`, `effective_from`, `effective_to`, `required_approvals`

### `mandate_signatory`
- Composite PK: (`mandate_id`, `customer_id`)
- FKs to `account_mandate` and `customer`
- `authority_role`, `individual_limit`, `is_active`

### `financial_transaction`
- `transaction_id` — PK
- `transaction_reference` — NN, UQ
- `transaction_type`, `amount`, `currency`, `transaction_status`
- `initiated_by`, `created_at`, `posted_at`
- `idempotency_key` (optional UQ in this baseline design)

### `ledger_entry`
- `ledger_entry_id` — PK
- `transaction_id` — FK to `financial_transaction`
- `account_id` — FK to `account`
- `entry_type` (DEBIT/CREDIT), `amount`, `created_at`
- Indexes on (`account_id`, `created_at`) and `transaction_id`.

### `transaction_approval`
- `approval_id` — PK
- `transaction_id` — FK to `financial_transaction`
- `mandate_id` — FK to `account_mandate`
- `approver_customer_id` — FK to `customer`
- `decision`, `decision_reason`, `decided_at`
- Unique (`transaction_id`, `approver_customer_id`) prevents the same approver being recorded twice for one transaction.

### `idempotency_request`
- `idempotency_id` — PK
- `idempotency_key` — NN, UQ
- `request_hash`, `transaction_id` (optional FK), `request_status`, timestamps
- Same key with a different request hash must be rejected by application/procedure logic.

### `audit_log`
- `audit_id` — PK
- `actor_type`, `actor_id`, `action_type`, `entity_type`, `entity_id`
- `event_timestamp`, `reason`, `before_data`, `after_data`
- Audit payload fields are optional JSON; access should be restricted.

## Relationship summary

- `customer` 1:N `kyc_case`
- `customer` 1:N `customer_document`
- `kyc_case` 1:N `customer_document`
- `kyc_case` 1:N `kyc_review`
- `customer` M:N `account` through `account_party`
- `account` 1:N `account_mandate`
- `account_mandate` M:N `customer` through `mandate_signatory`
- `financial_transaction` 1:N `ledger_entry`
- `account` 1:N `ledger_entry`
- `financial_transaction` 1:N `transaction_approval`
- `account_mandate` 1:N `transaction_approval`
- `customer` 1:N `transaction_approval` as approver
- `financial_transaction` 0:1 `idempotency_request` in the baseline workflow
- `audit_log` records actions across entities; polymorphic entity references are not enforced by a single FK.

## Design notes
1. The `account.balance` value is a current-balance projection and must be updated atomically with ledger posting and reconciled against ledger history.
2. The schema cannot, with basic FKs and CHECKs alone, enforce that each posted transaction has balanced debit/credit entries. Use a controlled posting routine and reconciliation.
3. A `customer` supertype plus subtype tables avoids organisation-only fields on individual records.
4. If the assignment expects a strict 3NF explanation, describe balance as a deliberate performance projection with a reconciliation control.
