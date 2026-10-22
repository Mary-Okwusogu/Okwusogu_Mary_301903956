# 03-sql

Execute scripts in this order on a dedicated development/test MySQL 8.x instance:

1. `01-create-database.sql`
2. `02-create-tables.sql`
3. `03-constraints-and-indexes.sql`
4. `04-test-data.sql`
5. `05-validation-tests.sql`
6. `06-sample-queries.sql`

Run the negative tests in `05-validation-tests.sql` individually after uncommenting them. Expected constraint violations are successful negative tests. The schema is an academic baseline and does not yet provide a production-ready transfer posting stored procedure.
