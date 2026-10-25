### Performance Analysis
Aggregation and Reporting

The baseline and alternative aggregation queries returned the same results for the date range 10–17 February 2026: 148 POSTED transactions, a total amount of 815305.0000, and an average amount of 5508.81756757. The baseline used idx_transaction_created_at, while the alternative used the new covering index, idx_transaction_date_status_amount, to perform a covering index range scan. The estimated optimizer cost decreased from 66.9 to 31.4, and the observed index access time decreased from 0.087–0.382 ms to 0.0241–0.0734 ms. The aggregation completion time also decreased from approximately 1.66 ms to 0.212 ms. These results suggest that the covering index reduces the work required for this report, although repeated measurements are needed before claiming a conclusive performance improvement. Both plans still used a temporary table and final sort.

The covering index is a promising candidate because it contains the columns required by the date-filtered aggregation, potentially avoiding table-row lookups. However, its storage and write-maintenance overhead should be considered before retaining it in the final schema.
