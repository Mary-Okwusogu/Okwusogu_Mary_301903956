### Performance Analysis
Account Ledger History

The baseline query used an index lookup on `idx_ledger_account_time`, while the optimised query used an index range scan by removing the `DATE()` function from `created_at`. Both queries returned the same seven ledger entries, confirming result equivalence. However, the estimated optimizer cost increased from 2.45 to 3.41, and the observed iterator time increased from 0.052–0.0551 ms to 0.076–0.0803 ms. Therefore, no performance improvement was demonstrated on this small dataset, although the optimised query expresses the date filter in a more index-friendly form. No additional index was created.

Removing DATE() from the indexed timestamp column may allow more direct use of the composite index's date range. Valid rationale, but observed performance did not improve in test.
