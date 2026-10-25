### Performance Analysis
Test approval history by mandate and date

Adding idx_approval_decided_at (decided_at) did not change the execution plan. MySQL continued to scan all 500 rows because the date range matches approximately 51% of the table. The observed sort completion time decreased slightly, from 0.684 ms to 0.658 ms, but this small, single-run difference does not demonstrate a reliable improvement. The index has not provided a measurable benefit for this query on the current dataset.

Removing DATE() makes the predicate index-friendly; testing a standalone timestamp index investigates whether it can help. The plan remained a table scan, even with the candidate index. The index was dropped, and no benefit was demonstrated.