# MIT-8103 Advanced Database Systems — BlitzFintech Portfolio Repository

**Student:** Mary Okwusogu  
**Student ID:** 301903956  
**Institution:** Miva Open University  
**Course:** MIT-8103 Advanced Database Systems  
**Case study:** BlitzFintech digital financial services platform

## Project overview

This repository documents five related practical portfolios built around the same BlitzFintech case study. The relational system supports customer onboarding and KYC, accounts, mandates, deposits, withdrawals, transfers, ledger entries, approvals, and audit events. MongoDB exercises demonstrate document-oriented workloads; the distributed database lab demonstrates replication and sharding.

**Evidence status:** Implementation scripts and evidence files are included. Some items, especially Portfolio 3 execution outcomes, require verification against screenshots or a live database. The repository should not be interpreted as a production deployment.

## Portfolio index

| Portfolio | Scope | Repository evidence | Status |
|---|---|---|---|
| [1 — Database Design](Okwusogu_Mary_301903956_portfolio_1_database_design/Okwusogu_Mary_301903956_README.md) | Relational model, ERD, normalization, constraints, seed and validation | DDL, schema/design documents, validation SQL and screenshots | Implemented; evidence included |
| [2 — Query Optimisation](Okwusogu_Mary_301903956_portfolio-2-query-optimisation/Okwusogu_Mary_301903956_README.md) | Query plans, indexing, before/after analysis | Six query exercises, SQL, plans, results and screenshot documents | Implemented; evidence included |
| [3 — Transactions and Concurrency](Okwusogu_Mary_301903956_portfolio_3_transactions_concurrency/Okwusogu_Mary_301903956_README.md) | ACID transaction procedure, posting, rollback, idempotency, concurrency | Procedure and nine supporting SQL files; screenshot document | Scripts and evidence present; specific results not fully revalidated |
| [4 — NoSQL](Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_README.md) | MongoDB document model, CRUD, indexes, aggregations, validation | Seven MongoDB scripts, suitability explanation, evidence | Implemented; evidence included |
| [5 — Distributed and Cloud Databases](Okwusogu_Mary_301903956_portfolio_5_distributed_cloud/Okwusogu_Mary_301903956_README.md) | MySQL GTID replication/failover/failback, MongoDB Atlas assessment, local sharding | README and four DOCX evidence files; backup/reconciliation lab artifacts | Documented lab completed, with stated limitations |

## Technical environment

- **MySQL:** 8.0.x/InnoDB, database `blitzfintech_db`, original primary `MySQLMiva80` on port 3307; Portfolio 5 replica `MySQLBlitzReplica` on port 3308.
- **MongoDB:** MongoDB Atlas for document-store work; separate local MongoDB sharding lab in Portfolio 5.
- **Tools:** MySQL Workbench, PowerShell, mongosh, MongoDB Compass, Git and GitHub.
- **Data:** Coursework demonstration data. Review any SQL dumps and screenshots for confidential or identifying content before sharing.

## How to review

1. Open each portfolio's linked README for its scope, implementation and evidence.
2. Review the scripts and supporting documents in that portfolio's actual folder.
3. For Portfolio 2, compare the documented before/after plans and measurements; small test datasets limit performance generalization.
4. For Portfolio 3, review `sp_post_financial_transaction`, posting examples, rollback/idempotency scripts, concurrent-session scripts and screenshots. The withdrawal example has an unresolved SQL/mandate-status issue; **do not execute it unmodified**.
5. For Portfolio 5, distinguish the controlled same-host manual MySQL failover from production high availability; local MongoDB sharding is a teaching demonstration.

## Assessment and submission notes

The course brief calls for five portfolios and a separate **2–3-page final LMS summary** with case-study overview, evidence, individual technical reflection, references, and an AI-use declaration. This README does not replace that final submission. Confirm the repository is **private**, grant the assessor access, and verify that required evidence is present in the committed repository. Removing `.git` from a shared ZIP does not change GitHub privacy settings.

## Integrity and limitations

Implementation claims should be assessed against SQL/JavaScript files and captured output. The project demonstrates academic lab scenarios rather than a certified banking platform. No automatic MySQL failover, independently tested pre-failback backup restore, or production-ready local MongoDB HA topology is claimed. Assistance from AI tools should be disclosed accurately in the final LMS declaration, including independent testing and corrections.
