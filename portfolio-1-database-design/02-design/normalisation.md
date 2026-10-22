# Normalisation Notes — BlitzFintech

## First Normal Form (1NF)
All attributes contain atomic values. The schema does not store a comma-separated list of account holders, documents or signatories. Those relationships are represented as separate rows in `account_party`, `customer_document` and `mandate_signatory`.

## Second Normal Form (2NF)
Non-key attributes depend on the whole candidate key. For the associative `account_party` table, the primary key is `(account_id, customer_id, party_role)` and there are no descriptive non-key attributes dependent on only part of that key. The `mandate_signatory` table similarly uses `(mandate_id, customer_id)`.

## Third Normal Form (3NF)
Shared customer data is stored in `customer`; individual-specific and organisation-specific details are separated into subtype tables. Account attributes are stored in `account`, while transaction header details are stored in `financial_transaction` and per-account financial effects are stored in `ledger_entry`. This avoids repeating customer, account and transaction descriptions in every ledger row.

## Deliberate implementation trade-off
`account.balance` is a current-balance projection maintained for efficient reads. Since it can be derived from an opening balance and posted ledger activity, it introduces controlled redundancy. A production implementation must update it atomically with ledger posting and reconcile it against the ledger. If the marking rubric requires strict 3NF without derived projections, document the balance as a controlled operational cache or remove it from the conceptual model and calculate balances from ledger entries.

## Integrity note
Foreign keys and `CHECK` constraints protect row-level domains and relationships. Rules such as requiring a holder before account activation, checking KYC and mandates before posting, preventing a duplicate retry, and ensuring balanced ledger entries need controlled stored procedures/application services and transaction-level tests.
