-- Most constraints and indexes are declared inline in 02-create-tables.sql.
-- This script is intentionally safe to run after table creation and provides
-- metadata verification. Do not rerun ALTER ADD CONSTRAINT statements blindly.

USE blitzfintech_db;

SELECT TABLE_NAME, ENGINE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = DATABASE()
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;

SHOW CREATE TABLE customer;
SHOW CREATE TABLE account;
SHOW CREATE TABLE financial_transaction;
SHOW CREATE TABLE ledger_entry;
