### Performance Analysis
Test a multi-table join with date filtering

The baseline and alternative queries returned the same 204 joined rows. The baseline performed a full table scan of financial_transaction, examining 500 rows, while the alternative used the new idx_transaction_created_at index to perform a range scan over the 148 matching transactions. The observed final sort iterator time decreased from 1.80–1.81 ms to 1.67–1.68 ms, while the estimated optimizer cost increased from 160 to 357. Since this was a small dataset and the timing difference was marginal, the result should be treated as indicative rather than conclusive. Both plans still required a final sort. The index improved the initial filtering access method, but a consistent overall performance improvement was not established.

The standalone date index enabled more targeted filtering, but its benefit should be evaluated against its storage and write-maintenance overhead. Further testing with repeated runs and a representative workload is recommended before deciding whether to retain it.
