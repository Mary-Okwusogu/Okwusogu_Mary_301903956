### Performance Analysis
Test a customer-document lookup

The baseline and alternative queries returned the same three records and used the existing idx_document_customer_status index. Removing the explicit ORDER BY document_id was associated with a reduction in observed iterator time from 0.324–0.334 ms to 0.0992–0.107 ms, while the estimated optimizer cost remained 1.05 and the estimated row count remained three. Since this was a single-run test on a small dataset, the timing difference should be treated as indicative rather than conclusive. The existing index was sufficient, so no additional index was created. The ORDER BY clause should be retained wherever deterministic ordering is required. No schema or index changes were required.

Removing an explicit sort might reduce work if a sort was actually required. The plan did not establish a sorting bottleneck, so this was exploratory rather than a confirmed optimisation.
