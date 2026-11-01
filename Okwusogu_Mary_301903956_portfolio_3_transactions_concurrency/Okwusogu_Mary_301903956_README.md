# Portfolio 3 — Transactions and Concurrency Control

**Course:** MIT-8103 Advanced Database Systems  
**Case study:** BlitzFintech  
**Database:** MySQL 8.x (InnoDB), `blitzfintech_db`  
**Status:** Implemented and tested; see scripts and screenshot evidence

## Transaction processing overview

This portfolio builds on the database from Portfolio 1 to test financial transactions that require coordinated changes across multiple records. A successful transaction is more than inserting a row: the transaction record, account balance, ledger entries and audit information must remain consistent. The stored procedure `sp_post_financial_transaction` handles posting and was tested with both successful and rejected requests.

The tests cover deposits, withdrawals and transfers; error handling; prevention of duplicate postings; and transaction behaviour when two MySQL sessions run concurrently.

## Files and execution order

The scripts are numbered in the recommended execution order. They work with the existing BlitzFintech schema; they are **not** intended to create a second database.

| Script | What it covers |
|---|---|
| `Okwusogu_Mary_301903956_01_schema_inspection.sql` | Checks the tables, columns and relationships needed for posting. |
| `Okwusogu_Mary_301903956_02_transaction_procedure.sql` | Defines the transaction-posting procedure. |
| `Okwusogu_Mary_301903956_03_post_deposit_example.sql` | Deposit posting example. |
| `Okwusogu_Mary_301903956_04_post_withdrawal_example.sql` | Withdrawal posting example. |
| `Okwusogu_Mary_301903956_05_post_transfer_example.sql` | Transfer posting example. |
| `Okwusogu_Mary_301903956_06_rollback_insufficient_funds.sql` | Insufficient-funds/error-handling test. |
| `Okwusogu_Mary_301903956_07_idempotency_test.sql` | Repeated-request test to check duplicate posting. |
| `Okwusogu_Mary_301903956_08_concurrency_session_A.sql` | First concurrent MySQL session. |
| `Okwusogu_Mary_301903956_09_concurrency_session_B.sql` | Second concurrent MySQL session. |
| `Okwusogu_Mary_301903956_10_transaction_audit_validation.sql` | Follow-up checks against transaction and audit records. |

## Procedure validation

The existing schema and procedure inputs were inspected before suitable test accounts and transaction requests were selected. Validation checked the resulting transaction status and related account, ledger and audit records rather than relying on a procedure's return message alone.

**Withdrawal testing:** The withdrawal scenario initially required corrections to the test setup and confirmation that the necessary prerequisites were satisfied. After those adjustments, the withdrawal was **successfully executed and confirmed by screenshot evidence**. The initial troubleshooting should not be interpreted as a failed or unfinished withdrawal implementation. If rerunning the archived withdrawal example, compare its parameters and prerequisite values with the final successful test; the saved script may not contain every adjustment made during testing.

Additional tests covered deposits, transfers, insufficient-funds handling, idempotency and two-session concurrency. The screenshots capture the observed outcomes, including successful posting and rejected or repeated requests. The procedure and evidence should be read together when evaluating the implementation.

## ACID-related observations

- **Atomicity:** Related updates should commit together or be rolled back when a posting fails.
- **Consistency:** Account, transaction and ledger records must respect the rules of the BlitzFintech schema.
- **Isolation:** The session A and session B scripts were used to examine concurrent access to the same transactional data.
- **Durability:** Committed transactions are stored by InnoDB; a separate crash-and-restart durability experiment was not performed.

These are practical transaction tests rather than an exhaustive comparison of MySQL isolation levels. A separate full-database balance-to-ledger reconciliation across every account was not performed.

## Running the tests again

1. Start MySQL and connect to the existing `blitzfintech_db` database.
2. Inspect the schema and the procedure before making changes. Keep a backup of any data that needs to be preserved.
3. Use valid, existing accounts and requests that meet the mandate and approval prerequisites.
4. Run each posting example separately and inspect its effects on account balances, transaction records and ledger entries.
5. For concurrency testing, open two independent MySQL Workbench sessions and run the session A/B scripts as directed by the test scenario.
6. Compare the outputs with the screenshot evidence. Avoid rerunning financial posting scripts against an environment containing data you need to preserve.

## Findings and lessons

The transaction exercises demonstrated that successful posting depends on more than a stored procedure. Failed requests required checks of the surrounding data and business rules, followed by validation across related tables. Withdrawal troubleshooting, idempotency checks and concurrent-session tests highlighted the importance of combining database controls with careful testing.

## Scope

This is a coursework implementation on a local MySQL environment, not a production banking transaction service. The screenshots support the specific tests performed; they do not establish production-scale load handling, every isolation anomaly, or complete account reconciliation.
