# MIT-8103 Advanced Database Systems — BlitzFintech Portfolio Repository

**Student:** Mary Okwusogu  
**Student ID:** 301903956  
**Institution:** Miva Open University  
**Course:** MIT-8103 Advanced Database Systems  
**Case study:** BlitzFintech digital financial services platform

## Project overview

This repository contains five practical portfolios developed around **BlitzFintech**, a fictional financial technology company. The project focuses on designing and implementing a database system that supports key financial operations, including customer onboarding, Know Your Customer (KYC) verification, account management, mandates, deposits, withdrawals, transfers, transaction approvals, ledger management, and audit logging.

The project uses **MySQL** to manage structured financial data and **MongoDB** to handle more flexible, document-based information, such as KYC records and mandate documents. Beyond database design and implementation, the portfolios also explore query optimisation, transaction management, concurrency, replication, and sharding to demonstrate how databases can be managed, scaled, and maintained in a financial services environment.

**Implementation Evidence:** The repository includes the SQL scripts, implementation files, and supporting evidence for the work carried out across the five portfolios. However, some results, particularly those relating to transaction execution in Portfolio 3, still need to be confirmed against the available screenshots or verified directly in the database.

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

The course brief calls for five portfolios and a separate **2–3-page final LMS summary** with case-study overview, evidence, individual technical reflection, references, and an AI-use declaration. This README does not replace that final submission. The lecturer subsequently instructed students in class to keep their GitHub repositories **public**. The repository was reported accessible in a signed-out browser test on 1 November 2026. Verify that the latest files are pushed and that no secrets or confidential data are exposed.

## Integrity and limitations

Implementation claims should be assessed against SQL/JavaScript files and captured output. The project demonstrates academic lab scenarios rather than a certified banking platform. No automatic MySQL failover, independently tested pre-failback backup restore, or production-ready local MongoDB HA topology is claimed. AI assistance and synthetic-data provenance are declared below and in the final LMS report; any unverified tests remain identified as such.


## Dataset provenance and ERD attribution

The BlitzFintech case study uses **synthetic, fictional coursework data**, generated with assistance from ChatGPT rather than obtained from a real banking dataset. The seed data includes 100 fictional customers (60 individuals and 40 organisations), associated accounts, KYC documents, financial transactions, ledger entries and related records. This data was used for design, query, transaction, NoSQL and distributed-database exercises; it is not represented as real customer information. The relational entity-relationship diagram was modelled and visualised using **dbdiagram.io** and DBML.

## Declaration of generative AI use

**OpenAI ChatGPT** was used extensively for technical explanations, drafting and revising SQL and MongoDB scripts, synthetic-data generation, troubleshooting, implementation planning, README/documentation editing, and interpretation of results. **Google Gemini** was used as a supplementary AI assistant for some technical explanations and tasks. **dbdiagram.io** was used to draw and organise the relational ERD; it is a diagramming tool, not an AI-generated data source. AI suggestions were adapted to the BlitzFintech schema and, where executed, tested using MySQL Workbench, MongoDB tools and local services. The submitted scripts, screenshots and notes should be consulted for evidence of execution; not every proposed test or command is claimed to have been independently verified. The author remains responsible for the accuracy of the submitted work.

## References and tools

The dates below are **documented project-use dates from the coursework conversation**, not verified first visits to each website. Where the exact date a manual was consulted cannot be established, no access date is invented.

- dbdiagram.io (2026). *dbdiagram.io — Database Relationship Diagrams (DBML).* https://dbdiagram.io/ (project use documented **21 October 2026**).
- OpenAI (2026). *ChatGPT* [generative AI assistant]. https://chatgpt.com/ (documented use throughout the project, including **11 October–1 November 2026**).
- Google (2026). *Gemini* [generative AI assistant]. https://gemini.google.com/ (used during the project; **exact date not established**).
- Oracle. *MySQL 8.0 Reference Manual.* https://dev.mysql.com/doc/refman/8.0/en/ (technical reference; **access date not established**).
- MongoDB, Inc. *MongoDB Manual.* https://www.mongodb.com/docs/manual/ (technical reference; **access date not established**).
- MongoDB, Inc. *MongoDB Atlas Documentation.* https://www.mongodb.com/docs/atlas/ (technical reference; **access date not established**).
- Miva Open University (2026). *MIT-8103 Advanced Database Systems continuous assessment brief, September cohort* [course-provided assessment document].

Only retain the technical-manual entries above if those resources were actually consulted; otherwise treat them as recommended background reading rather than sources used.
