# MIT-8103 Portfolio 3 — Transactions and Concurrency Control

**Student:** Mary Okwusogu (301903956)  
**Case study:** BlitzFintech  
**Database:** Existing MySQL 8.0 `blitzfintech_db` (InnoDB), local service `MySQLMiva80`, port 3307  
**Status:** Implementation scripts and screenshot evidence present; execution results require final verification

## Purpose

This portfolio investigates ACID transactions, balance integrity, idempotency and concurrent posting using the **existing BlitzFintech schema**. It does not require creating a new database. The central implemented stored procedure is **`sp_post_financial_transaction`**, not `sp_execute_transfer`.

## Actual file inventory

| File | Purpose |
|---|---|
| `Okwusogu_Mary_301903956_01_schema_inspection.sql` | Inspect the existing schema before testing |
| `Okwusogu_Mary_301903956_02_transaction_procedure.sql` | Define `sp_post_financial_transaction` with transaction and error-handling logic |
| `Okwusogu_Mary_301903956_03_post_deposit_example.sql` | Deposit posting example |
| `Okwusogu_Mary_301903956_04_post_withdrawal_example.sql` | Withdrawal example — **requires correction before execution** |
| `Okwusogu_Mary_301903956_05_post_transfer_example.sql` | Transfer posting example |
| `Okwusogu_Mary_301903956_06_rollback_insufficient_funds.sql` | Insufficient-funds / rollback test |
| `Okwusogu_Mary_301903956_07_idempotency_test.sql` | Repeated request-key and altered-amount scenarios |
| `Okwusogu_Mary_301903956_08_concurrency_session_A.sql` | First concurrent withdrawal session |
| `Okwusogu_Mary_301903956_09_concurrency_session_B.sql` | Second concurrent withdrawal session |
| `Okwusogu_Mary_301903956_10_transaction_audit_validation.sql` | Check transaction/audit outcomes |
| `Okwusogu_Mary_301903956_screenshots/Okwusogu_Mary_301903956_Screenshots.docx` | Screenshot evidence; individual outcomes must be matched to tests |

## Transaction implementation

The procedure script contains `START TRANSACTION`, a SQL exception handler that rolls back and re-raises an error, `SELECT ... FOR UPDATE` locking, and `COMMIT`. The example scripts call the same procedure for deposit, withdrawal and transfer requests. The implementation is intended to maintain balances, transaction records and ledger/audit information together; correctness must be established by reviewing the procedure logic and matching executed output.

**ACID interpretation:** Atomicity is supported by transaction boundaries and rollback handling; consistency depends on validated constraints and balanced updates; isolation is addressed through InnoDB locks; durability relies on successful MySQL commits and engine configuration. These are design characteristics, not proof that every test passed.

## Concurrency and negative tests

- The insufficient-funds example is intended to demonstrate rejection and rollback without partial updates.
- The idempotency example calls the same request key more than once and includes a changed-amount scenario.
- Session A and Session B scripts provide a concurrent-withdrawal test harness. They require separate MySQL sessions and coordinated execution to demonstrate an actual race and its prevention.
- The audit-validation script and screenshot document provide places to check transaction, ledger and audit outcomes.

**Scope boundary:** The supplied file set does **not** contain separate executable demonstrations of all four isolation levels, dirty reads, non-repeatable reads, phantom reads, optimistic locking or deadlock logs. These should not be represented as completed experiments unless independent evidence is added.

## Outstanding issue — withdrawal example

`Okwusogu_Mary_301903956_04_post_withdrawal_example.sql` contains a missing semicolon after an `UPDATE account_mandate` statement and changes mandate status before posting. **Do not run it unmodified.** The account and mandate rules must be checked before correcting the example. This issue was intentionally deferred and remains unresolved.

## Verification checklist

- Confirm the procedure was created successfully in the intended schema.
- Match deposit/transfer execution output to updated account, financial transaction and ledger records.
- Confirm failed postings do not leave partial balance or ledger changes.
- Confirm repeated idempotency keys do not create unintended duplicate postings.
- Review Session A and B screenshot chronology and final balances.
- Label any tests not shown by execution evidence as unverified, rather than completed.

## Conclusion

The portfolio contains an implemented MySQL transaction procedure and supporting scripts for posting, rollback, idempotency and concurrent-session testing, plus a screenshot evidence document. The remaining withdrawal-script issue and any unverified test outcomes are disclosed to avoid overstating completion.
