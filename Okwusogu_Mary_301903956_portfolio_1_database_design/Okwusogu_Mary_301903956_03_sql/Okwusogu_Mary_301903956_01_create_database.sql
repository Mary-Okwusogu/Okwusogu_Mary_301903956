-- BlitzFintech Portfolio 1
-- Run in MySQL Workbench against a development/test instance.
CREATE DATABASE IF NOT EXISTS blitzfintech_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE blitzfintech_db;
SET SESSION default_storage_engine = 'InnoDB';

SELECT DATABASE() AS selected_database,
       @@default_storage_engine AS session_default_engine;
