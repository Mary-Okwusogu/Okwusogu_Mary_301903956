### Performance Analysis
Optimising Transaction Date Filtering

The optimised query improved performance by replacing a full table scan with an index range scan using the existing `idx_transaction_status_time` index. Both queries returned the same 18 records, confirming result equivalence. The estimated rows examined decreased from 500 to 18, the estimated optimizer cost dropped by approximately 83.7%, and the observed execution time decreased from 0.970 ms to 0.212 ms (approximately 78.1%). These results are promising, although repeated tests on a larger dataset are needed to confirm the improvement under representative workloads.
