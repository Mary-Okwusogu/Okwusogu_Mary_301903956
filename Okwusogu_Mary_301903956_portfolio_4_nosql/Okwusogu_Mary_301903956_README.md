# MIT-8103 Advanced Database Systems — Portfolio 4

## BlitzFintech: NoSQL Database Design and Implementation

**Student Name:** Mary Okwusogu  
**Student ID:** 301903956  
**Course Code & Title:** MIT-8103 — Advanced Database Systems  
**Institution:** Miva Open University  
**Case Study Domain:** BlitzFintech Electronic Financial Services Architecture  
**Portfolio:** 4 — NoSQL Data Models and Polyglot Persistence  
**Selected Implementation Model:** Document-oriented NoSQL (MongoDB Atlas)  
**Database Technology:** MongoDB Atlas  
**MongoDB Atlas Primary Database:** `blitzfintech_db` (Cluster: `blitzfintech.pijfjha.mongodb.net`)  
**Complementary NoSQL Database:** `blitzfintech_nosql` (managed via `db.getSiblingDB('blitzfintech_nosql')`)  
**Database Inspection Tool:** MongoDB Compass  
**Evidence Document:** [`Okwusogu_Mary_301903956_Screenshot_Evidence.docx`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_Screenshot_Evidence.docx)  
**Implementation Status:** **Completed, Executed, and Empirically Verified** (19 screenshots documenting end-to-end execution across 7 functional sections). Alternative models (Redis, Apache Cassandra, Neo4j) are included as unexecuted comparative design architectures.

---

## 1. Project Overview

This portfolio explores how NoSQL database architectures complement the relational database system engineered for BlitzFintech in earlier portfolios. Modern enterprise financial architectures increasingly adopt **polyglot persistence**—the strategic deployment of multiple purpose-fit database engines to satisfy divergent performance, scalability, and structural requirements across bounded contexts.

Within BlitzFintech:
- **Authoritative Relational Core:** The relational database (`blitzfintech_db` implemented in MySQL 8.x InnoDB) remains the non-negotiable authoritative source of truth for double-entry financial ledger journals, account balance invariants, and strict ACID multi-table transactions.
- **Document-Oriented NoSQL Complement:** MongoDB Atlas is deployed as the document-oriented data store supporting customer onboarding, Know Your Customer (KYC) compliance verification, and high-velocity audit event logs. Customer identification documents, multi-step verification audit trails, and compliance state transitions exhibit polymorphic structures and nested hierarchies that align naturally with the document model rather than rigid tabular normalization.
- **Architectural Scope:** The MongoDB implementation in this portfolio is dedicated to customer profile management, nested KYC verification artifact metadata, compliance event tracking, and transaction event stream ingestion. It explicitly does not replace the transactionally consistent financial ledger.

---

## 2. Objectives

The primary academic and technical objectives of this portfolio comprise:
1. **NoSQL Model Analysis:** Critically analyze and contrast the four primary NoSQL paradigms—Document-oriented, Key-Value, Wide-Column, and Graph—evaluating their underlying data structures, query paradigms, and architectural trade-offs.
2. **Schema Design & Strict Validation:** Design and implement representative BlitzFintech document schemas (`kyc_profiles`, `compliance_events`, `transaction_events`) utilizing strict JSON Schema validation (`$jsonSchema`) with enforced BSON data typing and regex patterns.
3. **Reproducible Script Suite:** Develop a modular, sequentially executable suite of 7 JavaScript (`mongosh`) automation scripts covering database initialization, sample data ingestion, analytical querying, nested document updates, indexing strategies, aggregation pipelines, and constraint validation tests.
4. **Empirical Execution & Verification:** Execute the complete script suite in a live MongoDB Atlas deployment (`blitzfintech_db` context hosting `blitzfintech_nosql`), inspecting and validating collection structures, indexes, and document transformations via MongoDB Compass and recording verifiable screenshot evidence.
5. **Architectural Evaluation:** Delineate the boundary between relational ACID guarantees and NoSQL schema flexibility, addressing data synchronization challenges, dual-write consistency, and document lifecycle governance.

---

## 3. Tools and Environment

| Component | Specification / Version | Role in Portfolio |
|---|---|---|
| **MongoDB Atlas** | MongoDB 8.x DBaaS (AWS Cluster) | Managed cloud deployment hosting primary database `blitzfintech_db` and dedicated NoSQL database `blitzfintech_nosql` (`blitzfintech.pijfjha.mongodb.net`) |
| **MongoDB Compass** | MongoDB Compass GUI | Visual inspection tool for collections, schema visualization, document validation, index health, and aggregation pipeline profiling |
| **Atlas Shell (`mongosh`)** | MongoDB Shell CLI | Command-line execution environment for running JavaScript automation scripts |
| **Evidence Documentation** | Microsoft Word (.docx) | [`Okwusogu_Mary_301903956_Screenshot_Evidence.docx`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_Screenshot_Evidence.docx) containing 19 timestamped screenshots across 7 execution phases |
| **Automation Scripts** | JavaScript (Node / BSON API) | 7 modular automation scripts (`.js`) implementing reproducible database lifecycle tasks |

> [!SECURITY]
> **Credential Protection & Data Privacy:** Database connection strings containing user credentials, administrative passwords, and cloud cluster tokens are strictly omitted. All data records utilized in this portfolio are purely synthetic demonstration entries. Synthetic customer numbers (`BF-TEST-C001`, `BF-TEST-C003`), masked identity numbers (`****1234`), and simulated SHA256 checksums prevent exposure of sensitive personal identifiable information (PII).

---

## 4. Selected NoSQL Model: Document-Oriented

MongoDB stores semi-structured data as Binary JSON (BSON) documents grouped into logical collections. In contrast to relational tables where multi-valued attributes require auxiliary tables and foreign key joins, MongoDB documents represent hierarchical real-world entities through embedded sub-documents and typed arrays.

### 4.1 Implemented Collections Architecture

The BlitzFintech NoSQL complement is organized into three purpose-fit collections governed by strict JSON Schema validators:

1. **`kyc_profiles`:** Stores comprehensive customer onboarding and KYC verification cases. It embeds an array of submitted identity documents (`documents`), which in turn embeds an array of third-party verification audit checks (`verifications`). This eliminates relational multi-table joins across customer, document, and verification entities.
2. **`compliance_events`:** An append-oriented audit stream capturing security, risk rating changes, and AML compliance events tagged with severity levels (`INFO`, `LOW`, `MEDIUM`, `HIGH`, `CRITICAL`).
3. **`transaction_events`:** An immutable event stream recording asynchronous transaction notifications, state transitions (`PENDING`, `POSTED`, `FAILED`, `REVERSED`), and ledger audit references strictly denominated in Nigerian Naira (`NGN`).

### 4.2 Document Schema Examples

#### Implemented KYC Profile Document (`kyc_profiles`)

The following BSON structure represents an actual synthetic customer KYC document generated and validated in MongoDB Atlas:

```javascript
{
  "_id": ObjectId("6ae112f7c6d3a2dae9c72633"),
  "customerId": NumberLong("1"),
  "kycCaseId": NumberLong("1"),
  "customerNumber": "BF-TEST-C001",
  "status": "APPROVED",
  "riskRating": "LOW",
  "documents": [
    {
      "documentId": NumberLong("1"),
      "documentType": "NATIONAL_ID",
      "storageObjectKey": "demo-only/kyc/1/national-id.jpg",
      "sha256Checksum": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      "mimeType": "image/jpeg",
      "verificationStatus": "VERIFIED",
      "issuedAt": ISODate("2025-01-01T00:00:00.000Z"),
      "expiresAt": null,
      "extractedData": {
        "idType": "NIN_SLIP",
        "issuingCountry": "NG",
        "ninMasked": "****1234"
      },
      "verifications": [
        {
          "method": "DOCUMENT_AUTHENTICITY",
          "provider": "DEMO_PROVIDER",
          "status": "PASSED",
          "confidenceScore": 96.4,
          "verifiedAt": ISODate("2026-10-10T00:00:00.000Z"),
          "providerDetails": {
            "tamperDetected": false
          },
          "reviewNote": "Checked by portfolio reviewer"
        }
      ]
    }
  ],
  "updatedAt": ISODate("2026-10-27T21:14:12.389Z")
}
```

#### Implemented Compliance Event Document (`compliance_events`)

```javascript
{
  "_id": ObjectId("6ae112f7c6d3a2dae9c72635"),
  "eventId": "BF-EVT-KYC-001",
  "customerId": NumberLong("1"),
  "kycCaseId": NumberLong("1"),
  "eventType": "KYC_APPROVED",
  "severity": "INFO",
  "source": "KYC_SERVICE",
  "details": {
    "previousStatus": "IN_REVIEW",
    "newStatus": "APPROVED"
  },
  "createdAt": ISODate("2026-10-10T00:00:00.000Z")
}
```

#### Implemented Transaction Event Document (`transaction_events`)

```javascript
{
  "_id": ObjectId("6ae112f7c6d3a2dae9c72637"),
  "eventId": "BF-TXEVT-DEMO-001",
  "transactionId": NumberLong("1"),
  "transactionReference": "BF-DEMO-POSTED-001",
  "accountId": NumberLong("1"),
  "eventType": "DEPOSIT",
  "entryType": "CREDIT",
  "amount": NumberDecimal("1000.0000"),
  "currency": "NGN",
  "transactionStatus": "POSTED",
  "createdAt": ISODate("2026-10-12T00:00:00.000Z"),
  "context": {
    "synthetic": true,
    "notReconciledWithMySQL": true
  }
}
```

### 4.3 Design Choices and Trade-offs

- **Natural Hierarchy via Bounded Embedding:** A customer onboarding case possesses a 1-to-few relationship with identity documents (typically 1 to 3 documents) and verification checks (1 to 5 attempts). Embedding these arrays within `kyc_profiles` ensures that retrieving a complete customer dossier requires exactly **one single-document read operation**, yielding optimal latency.
- **Controlled Document Growth:** Unbounded embedding is an anti-pattern that risks exceeding MongoDB's 16MB document size ceiling. In BlitzFintech, documents and verifications are bounded by onboarding compliance rules. In contrast, historical compliance events and transaction logs grow indefinitely; therefore, they are modeled as separate collections with foreign references (`customerId`, `accountId`).
- **Cryptographic Integrity & Enforced Typing:** Document authenticity is verified via SHA256 checksums constrained by a 64-character hexadecimal regex pattern (`^[a-fA-F0-9]{64}$`). Financial values use `NumberDecimal` (128-bit IEEE 754 decimal) to avoid floating-point rounding inaccuracies.
- **Schema Validation Governance:** Although MongoDB is inherently schemaless, strict JSON Schema validators enforce required fields and enum values at the database engine level, preventing corrupt payloads from reaching the document store.

---

## 5. Reproducible MongoDB Implementation & Execution Runbook

The complete NoSQL implementation is authored as a suite of 7 standalone, sequentially dependent JavaScript scripts. All scripts have been executed and verified in MongoDB Atlas.

> [!NOTE]
> **Verified Execution vs. Unexecuted Examples:**
> The commands and outputs documented in this section have been executed in `mongosh` against MongoDB Atlas database `blitzfintech_db` / `blitzfintech_nosql` and verified visually in MongoDB Compass. Corresponding execution screenshots are cataloged in [`Okwusogu_Mary_301903956_Screenshot_Evidence.docx`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_Screenshot_Evidence.docx).
> Conceptual Redis, Cassandra, and Neo4j examples in Section 7 are theoretical models.

### 5.1 Environment Prerequisites & Database Context

Connect to your authorized MongoDB Atlas deployment cluster using `mongosh`, specifying the primary database `blitzfintech_db`:

```bash
# Connect to MongoDB Atlas cluster via mongosh
mongosh "mongodb+srv://<cluster-host>/blitzfintech_db" --username <db-user>
```

Within `mongosh`, each script dynamically binds to the complementary NoSQL database namespace `blitzfintech_nosql` hosted on the same cluster:

```javascript
// Database context initialization used in all scripts
const b = db.getSiblingDB('blitzfintech_nosql');
```

### 5.2 Script Dependency & Execution Sequence Matrix

To ensure referential and schema integrity, the scripts must be executed in the strict numerical sequence outlined below:

| Sequence | Script Filename | Primary Objective | Dependencies | Verified Result |
|---|---|---|---|---|
| **01** | [`Okwusogu_Mary_301903956_01-create-database-and-collections.js`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_01-create-database-and-collections.js) | Initializes database and creates collections with strict JSON Schema validators | None (Run once on fresh cluster) | 3 collections created with strict validation rules |
| **02** | [`Okwusogu_Mary_301903956_02-insert-sample-data.js`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_02-insert-sample-data.js) | Ingests synthetic demonstration profiles and events using idempotent `$setOnInsert` upserts | Script 01 | Ingests 2 KYC profiles, 2 compliance events, 1 transaction event |
| **03** | [`Okwusogu_Mary_301903956_03-queries.js`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_03-queries.js) | Validates read operations, projections, `$elemMatch` array queries, and audit trails | Script 02 | Returns matching documents, nested verification arrays, and event timelines |
| **04** | [`Okwusogu_Mary_301903956_04-updates.js`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_04-updates.js) | Demonstrates atomic `$push` to nested arrays, positional `arrayFilters`, and status transitions | Script 02 | 3 update operations verified (`matchedCount: 1, modifiedCount: 1`) |
| **05** | [`Okwusogu_Mary_301903956_05-indexes.js`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_05-indexes.js) | Generates unique, compound, and multikey secondary indexes; profiles execution stats | Scripts 01 & 02 | 12 total indexes built across 3 collections; `IXSCAN` verified |
| **06** | [`Okwusogu_Mary_301903956_06-aggregations.js`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_06-aggregations.js) | Executes multi-stage aggregation pipelines (`$group`, `$unwind`, `$match`, `$sort`) | Scripts 02 & 04 | Statistical aggregations for risk distributions, providers, and volume |
| **07** | [`Okwusogu_Mary_301903956_07-validation-tests.js`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_07-validation-tests.js) | Executes negative constraint testing to verify strict JSON Schema rejections | Script 01 | 3 expected rejections verified (`Document failed validation`) |

---

### 5.3 Detailed Step-by-Step Implementation Runbook

#### Step 1: Database & Collection Initialization with JSON Schema
**File:** [`Okwusogu_Mary_301903956_01-create-database-and-collections.js`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_01-create-database-and-collections.js)

```bash
# Execution from terminal shell
mongosh "mongodb+srv://<cluster-host>/blitzfintech_db" Okwusogu_Mary_301903956_01-create-database-and-collections.js
```

Or within an active `mongosh` session:
```javascript
load("Okwusogu_Mary_301903956_01-create-database-and-collections.js")
```

**Implementation Highlights:**
- Establishes strict schema validation (`validationLevel: 'strict'`, `validationAction: 'error'`).
- Validates required fields, 64-character SHA256 hashes, currency enums (`['NGN']`), and severity levels.
- **Verified Output:**
  ```text
  blitzfintech_nosql
  [ 'compliance_events', 'kyc_profiles', 'transaction_events' ]
  ```
- *Visual Evidence:* Documented in Section 1 of the screenshot evidence document (Images 1 and 2).

---

#### Step 2: Ingest Sample Data
**File:** [`Okwusogu_Mary_301903956_02-insert-sample-data.js`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_02-insert-sample-data.js)

```bash
mongosh "mongodb+srv://<cluster-host>/blitzfintech_db" Okwusogu_Mary_301903956_02-insert-sample-data.js
```

**Implementation Highlights:**
- Utilizes idempotent upsert operations (`$setOnInsert`) keyed on unique business identifiers (`kycCaseId`, `eventId`) to prevent duplicate record proliferation upon re-execution.
- Ingests individual KYC profile (`BF-TEST-C001`), business profile (`BF-TEST-C003`), compliance events, and transaction event `BF-TXEVT-DEMO-001`.
- **Verified Output:**
  ```text
  Synthetic data inserted/upserted.
  ```
- *Visual Evidence:* Documented in Section 2 of the screenshot evidence document (Image 3).

---

#### Step 3: Operational and Analytical Queries
**File:** [`Okwusogu_Mary_301903956_03-queries.js`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_03-queries.js)

```bash
mongosh "mongodb+srv://<cluster-host>/blitzfintech_db" Okwusogu_Mary_301903956_03-queries.js
```

**Implementation Highlights:**
- Queries customer dossier by customer number with projection.
- Filters onboarding queue by status (`IN_REVIEW`) sorted by risk rating.
- Executes array queries using `$elemMatch` to locate profiles containing specific document types (`NATIONAL_ID`) and expiring credentials within 30 days.
- Traverses multi-level nested arrays (`documents.verifications.status`) to flag failed verification checks.
- Retrieves chronological compliance audit trail for customer ID `1`.
- *Visual Evidence:* Documented in Section 3 of the screenshot evidence document (mongosh query output in Image 4; Compass collection views in Images 5, 6, and 7).

---

#### Step 4: Atomic Nested Document Updates
**File:** [`Okwusogu_Mary_301903956_04-updates.js`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_04-updates.js)

```bash
mongosh "mongodb+srv://<cluster-host>/blitzfintech_db" Okwusogu_Mary_301903956_04-updates.js
```

**Implementation Highlights:**
- Appends an external verification record (`REGISTRY_CHECK`) into the nested `verifications` array using `$push` and the positional operator `documents.$`.
- Performs filtered positional updates using `arrayFilters` to annotate an existing verification (`doc.documentId: 1`, `ver.method: DOCUMENT_AUTHENTICITY`) with `reviewNote: 'Checked by portfolio reviewer'`.
- Updates profile status from `IN_REVIEW` to `APPROVED` and risk rating to `LOW`.
- **Verified Output:**
  ```text
  { acknowledged: true, insertedId: null, matchedCount: 1, modifiedCount: 1, upsertedCount: 0 }
  { acknowledged: true, insertedId: null, matchedCount: 1, modifiedCount: 1, upsertedCount: 0 }
  { acknowledged: true, insertedId: null, matchedCount: 1, modifiedCount: 1, upsertedCount: 0 }
  ```
- *Visual Evidence:* Documented in Section 4 of the screenshot evidence document (mongosh output in Image 8; Compass updated profiles in Images 9 and 10).

---

#### Step 5: Secondary & Multikey Indexing
**File:** [`Okwusogu_Mary_301903956_05-indexes.js`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_05-indexes.js)

```bash
mongosh "mongodb+srv://<cluster-host>/blitzfintech_db" Okwusogu_Mary_301903956_05-indexes.js
```

**Implementation Highlights:**
- Builds unique B-Tree indexes: `uq_kycCaseId`, `uq_eventId`, and `uq_transaction_eventId`.
- Builds compound indexes for query pattern acceleration: `idx_status_risk` (`{status: 1, riskRating: 1}`), `idx_customer_timeline` (`{customerId: 1, createdAt: -1}`), and `idx_account_time`.
- Builds a multikey index on array elements: `idx_document_expiry` on `documents.expiresAt`.
- Profiles index performance via `.explain('executionStats')`, demonstrating index-driven query resolution (`IXSCAN` + `FETCH`) rather than full collection scans (`COLLSCAN`).
- *Visual Evidence:* Documented in Section 5 of the screenshot evidence document (mongosh execution in Image 11; Compass index registers in Images 12, 13, and 14).

---

#### Step 6: Multi-Stage Aggregation Pipelines
**File:** [`Okwusogu_Mary_301903956_06-aggregations.js`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_06-aggregations.js)

```bash
mongosh "mongodb+srv://<cluster-host>/blitzfintech_db" Okwusogu_Mary_301903956_06-aggregations.js
```

**Implementation Highlights:**
- **Profile Distribution:** Groups KYC cases by composite `_id` (`status` and `riskRating`), calculating profile counts.
- **Document Breakdown:** Deconstructs the documents array using `$unwind` and calculates document distribution counts.
- **Provider Performance:** Unwinds nested verifications to compute attempt counts and average confidence scores (`$avg`) per verification provider.
- **Financial Volume Summary:** Matches posted NGN transactions and computes total financial volume using `$sum`.
- **Verified Output:**
  ```javascript
  [ { _id: { status: 'APPROVED', riskRating: 'LOW' }, profiles: 2 } ]
  [ { _id: 'CERTIFICATE_OF_INCORPORATION', count: 1 }, { _id: 'NATIONAL_ID', count: 1 } ]
  [ { _id: { provider: 'DEMO_PROVIDER', status: 'PASSED' }, attempts: 2, averageConfidence: 96.4 } ]
  [ { _id: 'DEPOSIT', eventCount: 1, totalAmountNGN: Decimal128('1000.0000') } ]
  ```
- *Visual Evidence:* Documented in Section 6 of the screenshot evidence document (mongosh aggregation output in Image 15; Compass Aggregations builder in Images 16, 17, and 18).

---

#### Step 7: Strict Schema Validation & Error Handling
**File:** [`Okwusogu_Mary_301903956_07-validation-tests.js`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_07-validation-tests.js)

```bash
mongosh "mongodb+srv://<cluster-host>/blitzfintech_db" Okwusogu_Mary_301903956_07-validation-tests.js
```

**Implementation Highlights:**
- Executes negative test scenarios wrapping invalid insert attempts in an `expectReject` harness to verify database-enforced schema constraints:
  1. **Forbidden Currency Test:** Injects `currency: 'USD'` into `transaction_events`.
  2. **Invalid Enum Test:** Injects invalid `riskRating: 'MEDIUM'` into `kyc_profiles` (allowed: `LOW`, `STANDARD`, `HIGH`).
  3. **Missing Required Property Test:** Injects compliance event lacking required `eventId`.
- **Verified Output:**
  ```text
  EXPECTED REJECTION USD forbidden: undefined Document failed validation
  EXPECTED REJECTION bad risk enum: undefined Document failed validation
  EXPECTED REJECTION missing required eventId: undefined Document failed validation
  Review output: expected rejection does not equal an executed test pass until run.
  ```
- *Visual Evidence:* Documented in Section 7 of the screenshot evidence document (Image 19).

---

## 6. Implementation Evidence & Repository Layout

### 6.1 Actual Directory Structure

The files residing inside `Okwusogu_Mary_301903956_portfolio_4_nosql` correspond exactly to the following structure:

```text
c:\Users\mokwusogu\MIT8103\Okwusogu_Mary_301903956\Okwusogu_Mary_301903956_portfolio_4_nosql/
├── Okwusogu_Mary_301903956_01-create-database-and-collections.js   # DDL: Collections and JSON Schema
├── Okwusogu_Mary_301903956_02-insert-sample-data.js                # DML: Idempotent synthetic data ingestion
├── Okwusogu_Mary_301903956_03-queries.js                           # DQL: Operational & array queries
├── Okwusogu_Mary_301903956_04-updates.js                           # DML: Positional & arrayFilter updates
├── Okwusogu_Mary_301903956_05-indexes.js                           # DDL: B-Tree & multikey indexes + explain
├── Okwusogu_Mary_301903956_06-aggregations.js                      # DQL: Multi-stage analytical pipelines
├── Okwusogu_Mary_301903956_07-validation-tests.js                  # Negative constraint & rejection test harness
├── Okwusogu_Mary_301903956_README.md                               # Master technical documentation (this file)
└── Okwusogu_Mary_301903956_Screenshot_Evidence.docx                # Word document with 19 verified execution screenshots
```

### 6.2 Evidence Mapping Table

Execution evidence is cataloged in [`Okwusogu_Mary_301903956_Screenshot_Evidence.docx`](file:///c:/Users/mokwusogu/MIT8103/Okwusogu_Mary_301903956/Okwusogu_Mary_301903956_portfolio_4_nosql/Okwusogu_Mary_301903956_Screenshot_Evidence.docx). The table below maps each evidence section to its corresponding script and visual proof:

| Document Section | Image ID | Implementation Artifact & Screenshot Details | Execution Environment | Status |
|---|---|---|---|---|
| **1. CREATE DATABASE & COLLECTIONS** | `Image 1` | Execution of script `01`: `mongosh` output showing strict validator creation and collection listing `['compliance_events', 'kyc_profiles', 'transaction_events']`. | mongosh (`blitzfintech_db`) | **Verified** |
| | `Image 2` | MongoDB Compass view of database `blitzfintech_nosql` on cluster `blitzfintech.pijfjha.mongodb.net` displaying 3 newly created empty collections. | MongoDB Compass GUI | **Verified** |
| **2. INSERT SAMPLE DATA** | `Image 3` | Execution of script `02`: Ingestion of individual and business KYC dossiers, compliance events, and transaction event; outputs `Synthetic data inserted/upserted.` | mongosh (`blitzfintech_db`) | **Verified** |
| **3. DATA VALIDATION AFTER INSERT** | `Image 4` | Execution of script `03`: Customer profile retrieval, `$elemMatch` nested document query, and date evaluations. | mongosh (`blitzfintech_db`) | **Verified** |
| | `Image 5` | Compass document view of `compliance_events` collection displaying 2 inserted documents (`BF-EVT-KYC-001`, `BF-EVT-RISK-002`). | MongoDB Compass GUI | **Verified** |
| | `Image 6` | Compass document view of `kyc_profiles` collection displaying 2 customer dossiers (`BF-TEST-C001`, `BF-TEST-C003`). | MongoDB Compass GUI | **Verified** |
| | `Image 7` | Compass document view of `transaction_events` collection displaying inserted event `BF-TXEVT-DEMO-001`. | MongoDB Compass GUI | **Verified** |
| **4. UPDATING KYC DATA** | `Image 8` | Execution of script `04`: mongosh output showing 3 successful updates with `matchedCount: 1, modifiedCount: 1` using `$push` and `arrayFilters`. | mongosh (`blitzfintech_db`) | **Verified** |
| | `Image 9` | Compass view of `kyc_profiles` confirming modified status `APPROVED` and risk rating `LOW` across profiles. | MongoDB Compass GUI | **Verified** |
| | `Image 10` | Compass inline document editor demonstrating document modification and schema preservation. | MongoDB Compass GUI | **Verified** |
| **5. CREATE INDEX** | `Image 11` | Execution of script `05`: Index creation output listing B-Tree structures and `.explain('executionStats')` profiling. | mongosh (`blitzfintech_db`) | **Verified** |
| | `Image 12` | Compass Indexes tab for `compliance_events` showing 4 active indexes (`_id_`, `uq_eventId`, `idx_customer_timeline`, `idx_event_type_time`). | MongoDB Compass GUI | **Verified** |
| | `Image 13` | Compass Indexes tab for `kyc_profiles` showing 5 active indexes (`_id_`, `uq_kycCaseId`, `idx_customerId`, `idx_status_risk`, `idx_document_expiry`). | MongoDB Compass GUI | **Verified** |
| | `Image 14` | Compass Indexes tab for `transaction_events` showing 3 active indexes (`_id_`, `uq_transaction_eventId`, `idx_account_time`). | MongoDB Compass GUI | **Verified** |
| **6. AGGREGATION** | `Image 15` | Execution of script `06`: mongosh output of 4 aggregation pipelines (risk distribution, document count, provider stats, transaction sums). | mongosh (`blitzfintech_db`) | **Verified** |
| | `Image 16` | Compass Aggregations interface for `compliance_events` collection. | MongoDB Compass GUI | **Verified** |
| | `Image 17` | Compass Aggregations interface for `kyc_profiles` collection. | MongoDB Compass GUI | **Verified** |
| | `Image 18` | Compass Aggregations interface for `transaction_events` collection. | MongoDB Compass GUI | **Verified** |
| **7. VALIDATION TESTS** | `Image 19` | Execution of script `07`: mongosh output displaying 3 expected validation failures (`USD forbidden`, `bad risk enum`, `missing required eventId`) confirming `$jsonSchema` engine enforcement. | mongosh (`blitzfintech_db`) | **Verified** |

---

## 7. Other NoSQL Models Applied to BlitzFintech (Conceptual Architectures)

> [!WARNING]
> **Academic Design Comparison Notice:**
> The Key-Value, Wide-Column, and Graph implementations presented in this section are **conceptual architectural evaluations** designed to demonstrate polyglot persistence suitability. They represent theoretical models, **not active or executed server deployments** in the student environment.

### 7.1 Key-Value Model — Redis

**Target Workload:** Ephemeral authentication state, active customer sessions, idempotency deduplication keys, and distributed API rate-limiting tokens.

#### Conceptual Implementation

```redis
# 1. Idempotent transfer request deduplication (TTL: 120 seconds)
SET idempotency:transfer:tx-uuid-98421 '{"status":"PROCESSING","account_id":1001}' EX 120 NX

# 2. Ephemeral customer session with 30-minute sliding expiration
SET session:customer:BF-TEST-C001 '{"customerId":1,"role":"TIER_2","kycStatus":"APPROVED"}' EX 1800
GET session:customer:BF-TEST-C001

# 3. High-throughput sliding-window rate limiting counter
INCR rate_limit:api:customer:1001:minute
EXPIRE rate_limit:api:customer:1001:minute 60
```

#### Architectural Evaluation
- **Suitability:** Redis operates entirely in-memory, delivering sub-millisecond retrieval latency for $O(1)$ key lookups. Automatic key expiration via TTL natively handles session invalidation without consuming database background cleanup cycles.
- **Limitations:** Lack of secondary indexing and relationship modeling makes Redis fundamentally unsuitable for complex financial reporting, regulatory queries, or durable ledger accounting.

---

### 7.2 Wide-Column Model — Apache Cassandra

**Target Workload:** High-velocity, immutable append-only transaction event histories and telemetry streams partitioned across distributed node clusters.

#### Conceptual Implementation

```sql
-- CQL (Cassandra Query Language) Table Specification
CREATE KEYSPACE blitzfintech_telemetry
WITH replication = {'class': 'NetworkTopologyStrategy', 'eu-west-1': 3};

CREATE TABLE blitzfintech_telemetry.account_transaction_journal (
    account_id bigint,
    bucket_month text,              -- Partition key component: YYYY-MM to prevent unbounded partitions
    event_time timestamp,          -- Clustering column (descending)
    transaction_id bigint,
    event_type text,
    amount decimal,
    currency text,
    balance_after decimal,
    PRIMARY KEY ((account_id, bucket_month), event_time, transaction_id)
) WITH CLUSTERING ORDER BY (event_time DESC, transaction_id ASC);

-- Efficient partitioned read query
SELECT * FROM blitzfintech_telemetry.account_transaction_journal
WHERE account_id = 1001 AND bucket_month = '2026-10'
LIMIT 50;
```

#### Architectural Evaluation
- **Suitability:** Cassandra's masterless, shared-nothing architecture delivers linear horizontal write scalability. Partitioning by `account_id` and clustering chronologically ensures that retrieving the latest statement events requires minimal disk seeks across contiguous blocks.
- **Limitations:** Cassandra mandates "query-first" data modeling. Ad-hoc queries, multi-table joins, and transactions spanning multiple partition keys are either prohibited or computationally expensive. It cannot serve as the authoritative double-entry balance validator.

---

### 7.3 Graph Model — Neo4j

**Target Workload:** Financial syndicate detection, anti-money laundering (AML) transaction flow monitoring, circular transaction detection, and beneficial ownership mapping.

#### Conceptual Implementation

```cypher
// 1. Create entities and directed relationships
MERGE (c1:Customer {customerId: 1, name: "Ada Okafor", riskRating: "LOW"})
MERGE (c2:Customer {customerId: 3, name: "Blitz Retailers Ltd", riskRating: "STANDARD"})
MERGE (a1:Account {accountNumber: "BFC0001", currency: "NGN"})
MERGE (a2:Account {accountNumber: "BFC0003", currency: "NGN"})

MERGE (c1)-[:OWNS {mandate: "SOLE"}]->(a1)
MERGE (c2)-[:OWNS {mandate: "CORPORATE"}]->(a2)
MERGE (c1)-[:DIRECTOR_OF {shareholding: 75.0}]->(c2)

// 2. Cypher query to detect potential circular transfer loops (AML structuring)
MATCH path = (origin:Account)-[:TRANSFER*3..6]->(origin)
WHERE ALL(r IN relationships(path) WHERE r.amount > 500000)
RETURN path, length(path) AS hopCount;
```

#### Architectural Evaluation
- **Suitability:** Neo4j stores relationships as first-class physical pointers on disk (index-free adjacency). Traversing multi-hop ownership structures and money transmission rings runs in $O(k)$ time relative to subgraph depth rather than crashing under exponential relational self-joins.
- **Limitations:** High memory footprint for pointer caches and complex horizontal sharding make graph databases specialized engines rather than general-purpose operational ledger stores.

---

## 8. Model Comparison and Architectural Suitability

The matrix below contrasts the operational trade-offs across the relational baseline and the four NoSQL paradigms:

| Architectural Dimension | Relational (MySQL 8.x InnoDB) | Document (MongoDB Atlas) | Key-Value (Redis) | Wide-Column (Cassandra) | Graph (Neo4j) |
|---|---|---|---|---|---|
| **Primary Data Structure** | Normalized 2D Tables | Hierarchical BSON Documents | Key-Value / Hash Dictionaries | Sparse Distributed Tables | Nodes, Edges & Properties |
| **Data Access Paradigm** | Declarative SQL with multi-table joins | Rich JSON query API & aggregation pipeline | Direct key lookup (`GET` / `SET`) | CQL keyed by partition & clustering keys | Cypher declarative path traversal |
| **Optimal BlitzFintech Use Case** | Authoritative double-entry ledger & balances | Customer onboarding dossiers & KYC audit logs | User session tokens & rate limit counters | High-throughput time-series event streaming | AML fraud syndicates & ownership rings |
| **ACID / Consistency Model** | Full ACID (Serializable / Repeatable Read) | ACID within single document; multi-doc transactions available | In-memory atomic single-key commands | Tunable eventual consistency (CAP: AP) | Full ACID (graph property transactions) |
| **Horizontal Scalability** | Primary-replica replication with read replicas | Native sharding via collection partition keys | Master-replica replication & Redis Cluster | Masterless multi-datacenter horizontal clustering | Enterprise causal clustering / read scaling |
| **Schema Flexibility** | Rigid DDL schema requiring migration scripts | Dynamic schema with optional JSON Schema enforcement | Schemaless binary strings / JSON blobs | Typed column families; rigid partition keys | Dynamic graph schema without fixed schema migrations |

### Polyglot Persistence Architecture Rationale

BlitzFintech adopts a **polyglot persistence topology**:
1. **Financial Ledger:** Managed exclusively by MySQL 8.x InnoDB, leveraging foreign key constraints, `CHECK` constraints, row-level pessimistic locking (`FOR UPDATE`), and ACID transactions to ensure that unbalanced debits and credits cannot be committed under any circumstance.
2. **KYC Document Dossier:** Managed by MongoDB Atlas, accommodating multi-page image checksums, variable-length verification histories, and heterogeneous identity schemes without database schema alterations.
3. **High-Performance Ingress:** Managed conceptually by Redis and Cassandra to shield operational stores from session validation traffic and raw telemetry volume.

---

## 9. Testing, Validation, and Limitations

### 9.1 Verified Implementation Results

The MongoDB implementation has been verified through empirical testing:
1. **Schema Strictness Enforcement:** Tested and confirmed in Script 07: inserts containing unapproved currencies (`USD`) or unauthorized enum values (`MEDIUM`) are rejected with `Document failed validation`.
2. **Positional Update Integrity:** Verified in Script 04: updates utilizing `arrayFilters` precisely modify targeted nested verification sub-documents without overwriting sibling records.
3. **Execution Plan Efficiency:** Verified in Script 05: queries on indexed keys (`customerId: 1`) resolve via `IXSCAN` and `FETCH`, verifying that index memory structures eliminate unindexed collection scans (`COLLSCAN`).
4. **Aggregation Correctness:** Verified in Script 06: pipelines calculating risk rating counts and average provider confidence scores match ingested dataset metrics.

### 9.2 Engineering & Architectural Limitations

- **Cross-Database Referential Integrity:** MongoDB does not enforce cross-database or cross-system foreign key constraints. A `customerId` stored in `kyc_profiles` references an entity in MySQL `blitzfintech_db`, but MongoDB cannot block relational row deletion or enforce relational existence out-of-the-box. Referential alignment requires an application-level saga coordinator or event-driven reconciliation process.
- **Dual-Write Consistency & Failure Modes:** When a customer onboard state changes, updating both MySQL and MongoDB introduces dual-write hazards. A network timeout after committing MySQL but before writing MongoDB creates state divergence. Mitigating this requires an asynchronous Change Data Capture (CDC) pipeline (e.g., Debezium streaming MySQL binlogs into Kafka and sinking to MongoDB).
- **Document Sizing & Memory Footprint:** While bounded arrays are implemented in `kyc_profiles`, failure to enforce upper bounds on nested arrays in high-volume applications can lead to memory fragmentation and slow document re-allocation.
- **Empirical Benchmarking Requirements:** Latency, throughput, and clustering failover claims require formal stress testing under concurrent multi-threaded workloads (e.g., Yahoo! Cloud Serving Benchmark - YCSB) before they can be cited as measured production performance benchmarks.

---

## 10. Conclusion

The implementation conducted in Portfolio 4 demonstrates that MongoDB Atlas provides an effective document-oriented complement to BlitzFintech's relational core. By encapsulating heterogeneous KYC verification metadata, cryptographic hashes, and verification audit logs within self-contained BSON documents, the system eliminates relational join overhead while retaining structural governance via strict JSON Schema validation.

Complementary evaluations of Key-Value (Redis), Wide-Column (Cassandra), and Graph (Neo4j) paradigms illustrate that no single database technology optimally satisfies all modern fintech access patterns. A disciplined polyglot persistence architecture—combining a relational ACID financial ledger with specialized NoSQL document, caching, and event-streaming engines—represents the optimal architectural design for enterprise-scale electronic financial platforms.

---

## 11. References

- MongoDB Inc. (2026). *MongoDB Manual: Schema Validation and BSON Document Specifications*. Available at: https://www.mongodb.com/docs/
- MongoDB Inc. (2026). *MongoDB Aggregation Pipeline Framework and Index Optimization Guide*. Available at: https://www.mongodb.com/docs/manual/core/aggregation-pipeline/
- Redis Ltd. (2026). *Redis Documentation: Data Structures, Key Expiration, and In-Memory Architecture*. Available at: https://redis.io/docs/latest/
- Apache Software Foundation (2026). *Apache Cassandra Documentation: Architecture, Partitioning, and CQL Modeling*. Available at: https://cassandra.apache.org/doc/latest/
- Neo4j Inc. (2026). *The Neo4j Cypher Manual: Graph Modeling, Traversals, and Property Graph Specifications*. Available at: https://neo4j.com/docs/cypher-manual/current/
- Fowler, M. (2012). *Polyglot Persistence*. Available at: https://martinfowler.com/bliki/PolyglotPersistence.html
- Stonebraker, M. and Cetintemel, U. (2005). *'One Size Fits All': An Idea Whose Time Has Come and Gone*. In: Proceedings of the 21st International Conference on Data Engineering (ICDE).
