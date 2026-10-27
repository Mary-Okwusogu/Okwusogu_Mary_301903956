# MIT8103: Advanced Database Systems — Master's Portfolio Repository

**Student Name:** Mary Okwusogu  
**Student ID:** 301903956  
**Programme:** Master of Science in Information Technology  
**Course Code & Title:** MIT-8103 — Advanced Database Systems  
**Institution:** Miva Open University  
**Case Study Domain:** BlitzFintech Electronic Financial Services Architecture  
**Repository Version:** 1.0.0  

---

## 1. Repository Overview

This repository serves as the unified academic and engineering portfolio for **MIT8103 Advanced Database Systems**. The curriculum explores the full lifecycle of modern database engineering—spanning conceptual and physical relational modelling, query optimization, transactional concurrency control, polyglot persistence with NoSQL databases, and distributed cloud-native architectures.

Throughout this module, the practical implementations are anchored in a realistic enterprise fintech case study: **BlitzFintech**, an electronic banking and financial technology platform requiring high data integrity, strict auditability, sub-millisecond query performance, and resilient fault tolerance.

---

## 2. Portfolio Structure & Status Summary

The repository is organized into five specialized portfolio modules. The table below delineates the current implementation status, core focus areas, and direct documentation links for each module:

| Portfolio Module | Focus Area | Primary Tech Stack | Status | Documentation Link |
|---|---|---|---|---|
| **Portfolio 1** | **Database Design and Implementation** | MySQL 8.x (InnoDB), MySQL Workbench | **Completed & Validated** | [Portfolio 1 README](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-1-database-design/README.md) |
| **Portfolio 2** | **Query Optimisation** | MySQL 8.x CBO, `EXPLAIN ANALYZE`, Visual Explain | Planned / Roadmap | [Portfolio 2 README](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-2-query-optimisation/README.md) |
| **Portfolio 3** | **Transactions and Concurrency Control** | InnoDB MVCC, Row Locking, Stored Procedures | Planned / Roadmap | [Portfolio 3 README](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-3-transactions-concurrency/README.md) |
| **Portfolio 4** | **NoSQL Databases** | MongoDB, Redis, BSON Aggregations | Planned / Roadmap | [Portfolio 4 README](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-4-nosql/README.md) |
| **Portfolio 5** | **Distributed and Cloud Databases** | MySQL Group Replication, Partitioning, Cloud DBaaS | Planned / Roadmap | [Portfolio 5 README](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-5-distributed-cloud/README.md) |

> **Academic Rigour Notice:** Completed work is explicitly separated from planned future milestones. Portfolio 1 contains full production-grade SQL scripts, data dictionaries, formal reports, and documented screenshot evidence. Portfolios 2 through 5 currently define the architectural roadmaps, test methodologies, and target specifications ahead of active lab implementation.

---

## 3. High-Level Portfolio Summaries

### [Portfolio 1: Relational Database Design and Implementation](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-1-database-design/README.md) *(Completed)*
- **Core Deliverables:** 13-table normalized relational schema (targeting 3NF), 52 formal business rules, entity-relationship diagrams (visual PNG and Mermaid.js), relational schema data dictionary, and complete SQL script suite.
- **Key Technical Features:** Explicit MySQL 8.x InnoDB engine enforcement, exact currency representations via `DECIMAL(19,4)`, supertype/subtype customer modeling, double-entry financial ledger journal lines, customer KYC lifecycle, and multi-party signing mandates.
- **Validation & Evidence:** 100% engine compliance verified via `information_schema`, zero orphaned records, zero unbalanced ledger transactions, positive and negative constraint tests, transactional rollback demonstration, and 3 comprehensive screenshot evidence documents.

### [Portfolio 2: Query Optimisation](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-2-query-optimisation/README.md) *(Planned)*
- **Planned Scope:** Query execution path profiling using `EXPLAIN FORMAT=JSON` and `EXPLAIN ANALYZE`, B-Tree index engineering (composite, covering, and prefix indexing), query refactoring (correlated subquery elimination, keyset pagination), and before-versus-after quantitative latency benchmarking.

### [Portfolio 3: Transactions and Concurrency Control](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-3-transactions-concurrency/README.md) *(Planned)*
- **Planned Scope:** Empirical investigation of ACID properties, multi-session parallel testing across ANSI SQL isolation levels (`READ UNCOMMITTED`, `READ COMMITTED`, `REPEATABLE READ`, `SERIALIZABLE`), deliberate reproduction and mitigation of concurrency anomalies (dirty reads, non-repeatable reads, phantom reads, lost updates), deadlock graph analysis (`SHOW ENGINE INNODB STATUS`), and comparing pessimistic locking (`FOR UPDATE`) with optimistic concurrency control.

### [Portfolio 4: NoSQL Databases](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-4-nosql/README.md) *(Planned)*
- **Planned Scope:** Polyglot persistence integrating MySQL with MongoDB (document store for variable-shape KYC verification payloads and audit event streams) and Redis (in-memory cache for idempotency deduplication and rate limiting). Includes document embedding vs. referencing trade-offs, multi-stage aggregation pipelines, and CAP theorem consistency evaluations.

### [Portfolio 5: Distributed and Cloud Databases](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-5-distributed-cloud/README.md) *(Planned)*
- **Planned Scope:** High-availability replication topologies (MySQL Group Replication with Paxos consensus), horizontal table partitioning (Range and Hash partitioning on transaction tables) with partition pruning, containerized multi-node clustering, automated failover chaos testing, and comparative analysis of cloud-native DBaaS (AWS Aurora / RDS Multi-AZ).

---

## 4. Master Repository Directory Tree

```
c:\Users\mokwusogu\MIT8103\Okwusogu_Mary_301903956/
├── README.md                                      # Master repository index (this document)
│
├── portfolio-1-database-design/                   # [COMPLETED]
│   ├── README.md                                  # Portfolio 1 master documentation
│   ├── 01-documentation/
│   │   └── portfolio1-report.docx                 # Formal academic assessment report
│   ├── 02-design/
│   │   ├── business-rules.md                      # 52 formal business rules register
│   │   ├── erd.mmd                                # Mermaid.js ERD model specification
│   │   ├── normalisation.md                       # Normalisation (1NF, 2NF, 3NF) analysis
│   │   ├── Okwusogu_Mary_ERD.png                  # Visual entity-relationship diagram
│   │   ├── Okwusogu_Mary_ERD_Summary.xlsx         # Entity relationship summary matrix
│   │   └── relational-schema.md                   # Full relational data dictionary
│   └── 03-sql/
│       ├── 01-create-database.sql                 # Database & engine initialization
│       ├── 02-create-tables.sql                   # 13 DDL table creation scripts
│       ├── 03-constraints-and-indexes.sql         # Metadata & constraint verification
│       ├── 04-test-data.sql                       # Synthetic test data population
│       ├── 05-validation-tests.sql                # Positive & negative constraint test harness
│       ├── 06-sample-queries.sql                  # Analytical and operational queries
│       ├── Okwusogu_Mary_Constraint_Validation_Screenshots.docx  # Constraint screenshots
│       ├── Okwusogu_Mary_Data_Enrichment_Screenshot_Evidence.docx # Data screenshots
│       ├── Okwusogu_Mary_Screenshot_Evidence.docx # End-to-end execution screenshots
│       └── README.md                              # SQL execution runbook
│
├── portfolio-2-query-optimisation/                # [PLANNED / ROADMAP]
│   └── README.md                                  # Query optimization architecture & roadmap
│
├── portfolio-3-transactions-concurrency/          # [PLANNED / ROADMAP]
│   └── README.md                                  # Concurrency & transaction control roadmap
│
├── portfolio-4-nosql/                             # [PLANNED / ROADMAP]
│   └── README.md                                  # NoSQL & polyglot persistence roadmap
│
└── portfolio-5-distributed-cloud/                 # [PLANNED / ROADMAP]
    └── README.md                                  # Distributed & cloud architecture roadmap
```

---

## 5. Technology Stack & Prerequisites

| Technology | Purpose | Module Application |
|---|---|---|
| **MySQL Community Server 8.0.x / 8.4 LTS** | Primary Relational DBMS & InnoDB Engine | Portfolios 1, 2, 3, 5 |
| **MySQL Workbench 8.0.x** | SQL Development, ER Modeling & Visual Explain | Portfolios 1, 2, 3 |
| **Mermaid.js & Markdown** | Architectural Schemas, Sequence Diagrams & Technical Docs | Portfolios 1–5 |
| **MongoDB 7.x / 8.x** | Document-Oriented Storage for Semi-Structured Payloads | Portfolio 4 |
| **Redis 7.x** | In-Memory Key-Value Caching & Rate Limiting | Portfolio 4 |
| **Docker & Docker Compose** | Multi-Node Database Cluster Containerization | Portfolio 5 |
| **AWS Cloud (Aurora / RDS)** | Cloud Database-as-a-Service (DBaaS) Reference | Portfolio 5 |

---

## 6. How to Navigate and Review This Repository

1. **Review Portfolio 1 Implementation:**
   - Navigate to [portfolio-1-database-design/README.md](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-1-database-design/README.md).
   - Inspect the relational model in [relational-schema.md](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-1-database-design/02-design/relational-schema.md) and [business-rules.md](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-1-database-design/02-design/business-rules.md).
   - Review executable SQL in [portfolio-1-database-design/03-sql/](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-1-database-design/03-sql/).
   - Review validation screenshot evidence in the `.docx` documents located in `portfolio-1-database-design/03-sql/`.
2. **Review Upcoming Module Roadmaps:**
   - [Portfolio 2: Query Optimisation](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-2-query-optimisation/README.md)
   - [Portfolio 3: Transactions and Concurrency](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-3-transactions-concurrency/README.md)
   - [Portfolio 4: NoSQL Databases](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-4-nosql/README.md)
   - [Portfolio 5: Distributed and Cloud Databases](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/portfolio-5-distributed-cloud/README.md)

---

## 7. Academic Integrity, Ethics & Security Statement

- **Synthetic Data Compliance:** All records, identifiers, customer names, corporate entities, phone numbers, and balances in this repository are 100% synthetic and generated solely for educational simulation. No actual Personal Identifiable Information (PII) or confidential banking data has been utilized.
- **Credential Hygiene:** No live database passwords, access keys, cloud credentials, or private connection strings are committed to this repository.
- **Originality & Authorship:** All relational designs, code, documentation, and diagrams were produced by Mary Okwusogu (ID: 301903956) in accordance with Miva Open University's academic integrity policies.
