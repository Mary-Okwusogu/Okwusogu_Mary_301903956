# BlitzFintech Business Rules

**Scope:** Portfolio 1 relational database foundation. Statuses and approval policies are illustrative academic assumptions and must be adapted to the official assessment brief.

## A. Customer and identity

| ID | Rule | Primary enforcement |
|---|---|---|
| BR-001 | Every customer has a unique internal customer ID. | Primary key |
| BR-002 | Every customer is classified as an individual or organisation. | `CHECK` constraint |
| BR-003 | Every customer has a unique customer number. | `UNIQUE` constraint |
| BR-004 | Contact details are validated and normalised before registration. | Application validation; optional uniqueness policy |
| BR-005 | Individual and organisation-specific details are stored separately from shared customer data. | Subtype tables |
| BR-006 | Account activation requires required onboarding checks to pass. | Controlled procedure/service |
| BR-007 | A customer with dependent financial or audit history is not physically deleted. | Foreign keys, privileges, status changes |

## B. Accounts and ownership

| ID | Rule | Primary enforcement |
|---|---|---|
| BR-008 | Each account has a unique ID and account number. | PK and unique constraint |
| BR-009 | Account type, currency and status are required and valid. | `NOT NULL`, `CHECK` or lookup tables |
| BR-010 | An account has at least one eligible holder before activation. | Activation procedure; cross-table rule |
| BR-011 | Multiple holders are permitted only for account products that support joint ownership. | Account-party relationship plus application validation |
| BR-012 | Ordinary financial transactions require an eligible active account. | Posting procedure |
| BR-013 | An account cannot be debited beyond available funds unless a configured overdraft facility permits it. | Locked balance validation and overdraft policy |
| BR-014 | Transaction currency must match account currency unless an explicit FX process applies. | Posting procedure |
| BR-015 | Account closure requires balance and unresolved-transaction checks. | Closure procedure |

## C. KYC and documents

| ID | Rule | Primary enforcement |
|---|---|---|
| BR-016 | Each KYC case references an existing customer. | FK |
| BR-017 | Each document references a customer and has a document type. | FK and required columns |
| BR-018 | Documents have a status and submission time; expiry is recorded where applicable. | Required metadata |
| BR-019 | Expired or rejected documents do not satisfy a mandatory KYC requirement. | KYC approval service |
| BR-020 | Only authorised compliance roles approve or reject KYC cases. | Application authorisation and database privileges |
| BR-021 | Each KYC decision records reviewer, time, decision and reason. | KYC review history |
| BR-022 | Insufficient KYC blocks transactions that require approved KYC, subject to explicitly configured exceptions. | Posting procedure |
| BR-023 | Binary document content is held in secure object storage; the database holds controlled references and integrity metadata. | Object-storage policy and metadata |

## D. Mandates and signatories

| ID | Rule | Primary enforcement |
|---|---|---|
| BR-024 | A mandate belongs to a valid account and has status and effective dates. | FK and checks |
| BR-025 | Signatories must be eligible parties associated with the account or organisation under the mandate. | Relationship table and procedure |
| BR-026 | Transactions subject to a mandate must meet its approval rule before posting. | Approval procedure |
| BR-027 | Signatories act only within their assigned authority and transaction limit. | Procedure |
| BR-028 | Each mandate defines a required approval count or signing rule. | Required fields/structured rule |
| BR-029 | Expired, revoked or not-yet-effective mandates cannot authorise new transactions. | Posting procedure |
| BR-030 | Self-approval is prohibited where separation-of-duties policy requires it. | Initiator/approver comparison |

## E. Financial operations

| ID | Rule | Primary enforcement |
|---|---|---|
| BR-031 | Every financial transaction has a unique ID and business reference. | PK and `UNIQUE` |
| BR-032 | Monetary amounts are positive and stored using exact decimal types. | `DECIMAL` and `CHECK` |
| BR-033 | Accepted financial operations are retained in transaction history. | Transaction and ledger tables; privileges |
| BR-034 | Transfer debit and credit are one atomic operation. | InnoDB transaction |
| BR-035 | Ineligible accounts, unsupported currencies or insufficient funds prevent posting. | Posting procedure |
| BR-036 | An ordinary transfer cannot use the same source and destination account. | Posting procedure |
| BR-037 | A retried request with the same idempotency key cannot create a second operation. | Unique key, request hash and atomic processing |
| BR-038 | Posted transactions are corrected by compensating reversal entries, not by editing/deleting history. | Reversal procedure and permissions |
| BR-039 | Debits respect available funds, overdraft limits and applicable holds. | Locked balance/hold validation |
| BR-040 | Current balances and posted ledger entries remain consistent. | Atomic posting and reconciliation |
| BR-041 | Failed operations leave no partial financial posting. | Rollback |
| BR-042 | Transactions retain status, timestamps, reference and actor/system identity. | Transaction metadata |
| BR-043 | Deposits have an authorised or verified source/reference. | Deposit validation |
| BR-044 | Concurrent operations on the same account are safely serialised. | InnoDB locks, guarded updates and transaction isolation |

## F. Audit, access and integrity

| ID | Rule | Primary enforcement |
|---|---|---|
| BR-045 | Sensitive actions are attributable to a user or system identity. | Audit log |
| BR-046 | Sensitive operations are restricted to authorised roles. | Least privilege and application authorisation |
| BR-047 | Posted ledger and audit records are protected from ordinary modification/deletion. | Privileges, controlled procedures, external audit controls |
| BR-048 | Financial and compliance records reference valid parent records. | Foreign keys |
| BR-049 | Reversals reference the original transaction and include reason and authorisation. | Reversal record and procedure |
| BR-050 | Balances can be reconciled against opening balances and posted ledger entries. | Reconciliation query/process |
| BR-051 | Application users do not share unrestricted administrator credentials. | Account/role management |
| BR-052 | Sensitive personal information and identity evidence are accessible only to authorised processes and personnel. | Least privilege, encryption, monitoring |

## Proposed portfolio assumptions

- Ordinary accounts do not permit negative balances unless an overdraft product is explicitly modelled.
- The sample schema uses illustrative account and transaction statuses.
- A simple mandate example may require one approval below a configured threshold and two distinct approvals above it. The threshold is a configurable assumption, not a regulatory claim.
- Cross-row and cross-table rules must be enforced in a stored procedure or application service; `CHECK` constraints alone cannot enforce them.
