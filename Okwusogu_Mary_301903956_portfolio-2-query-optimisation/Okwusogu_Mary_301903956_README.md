# Portfolio 2: Query Optimisation and Performance Analysis

**Course:** MIT8103 — Advanced Database Systems  
**Student Name:** Mary Okwusogu  
**Student ID:** 301903956  
**Institution:** Miva Open University  
**Database Platform:** MySQL 8.x  
**Portfolio Status:** Implementation, Testing and Performance Analysis

---

## 1. Portfolio Overview

This portfolio focuses on SQL query optimisation and performance analysis using MySQL. It investigates six SQL queries through query execution, execution-plan inspection, result capture, and documented performance analysis.

The portfolio contains the SQL scripts, before-and-after execution evidence, CSV outputs, individual performance-analysis reports, and screenshot documents associated with the queries.

The purpose is to demonstrate how SQL queries can be examined and evaluated using execution plans and empirical evidence. The analysis considers the execution strategy selected by MySQL, the potential impact of query structure and indexing, and whether observed changes improve execution behaviour while preserving query correctness.

## 2. Objectives

The objectives of this portfolio are to:

1. Execute and evaluate six SQL queries.
2. Examine query execution plans before and after optimisation where the relevant evidence is available.
3. Investigate execution characteristics such as access methods, index selection, row estimates, filtering, joins, and sorting.
4. Document query results and execution-analysis outputs.
5. Analyse the effectiveness of optimisation changes using available evidence.
6. Compare baseline and revised results to check query correctness.
7. Present findings in individual performance-analysis reports supported by screenshots and output files.

## 3. Directory Structure

The portfolio is organised into the following directories:

```text
Okwusogu_Mary_301903956_portfolio-2-query-optimisation/
│
├── Okwusogu_Mary_301903956_README.md
│
├── Okwusogu_Mary_301903956_sql_queries/
│   ├── Okwusogu_Mary_301903956_Query1.txt
│   ├── Okwusogu_Mary_301903956_Query2.txt
│   ├── Okwusogu_Mary_301903956_Query3.txt
│   ├── Okwusogu_Mary_301903956_Query4.txt
│   ├── Okwusogu_Mary_301903956_Query5.txt
│   └── Okwusogu_Mary_301903956_Query6.txt
│
├── Okwusogu_Mary_301903956_execution_plans/
│   ├── Query-specific execution plan files
│   ├── Query-specific execution-analysis files
│   └── Before-and-after CSV outputs
│
├── Okwusogu_Mary_301903956_performance_analysis/
│   ├── Okwusogu_Mary_301903956_Query1_performance_analysis.md
│   ├── Okwusogu_Mary_301903956_Query2_performance_analysis.md
│   ├── Okwusogu_Mary_301903956_Query3_performance_analysis.md
│   ├── Okwusogu_Mary_301903956_Query4_performance_analysis.md
│   ├── Okwusogu_Mary_301903956_Query5_performance_analysis.md
│   └── Okwusogu_Mary_301903956_Query6_performance_analysis.md
│
├── Okwusogu_Mary_301903956_query_results/
│   └── Query result CSV files
│
└── Okwusogu_Mary_301903956_optimization_evidence_screenshots/
    └── Query-specific screenshot evidence documents
```

*Note: The tree above is a summary of the main folders and representative files. Consult the actual directories for the complete list of execution-plan and evidence files.*

## 4. SQL Query Scripts

The `Okwusogu_Mary_301903956_sql_queries/` directory contains six SQL scripts.

| File | Purpose |
|---|---|
| `Okwusogu_Mary_301903956_Query1.txt` | SQL query for the first optimisation exercise |
| `Okwusogu_Mary_301903956_Query2.txt` | SQL query for the second optimisation exercise |
| `Okwusogu_Mary_301903956_Query3.txt` | SQL query for the third optimisation exercise |
| `Okwusogu_Mary_301903956_Query4.txt` | SQL query for the fourth optimisation exercise |
| `Okwusogu_Mary_301903956_Query5.txt` | SQL query for the fifth optimisation exercise |
| `Okwusogu_Mary_301903956_Query6.txt` | SQL query for the sixth optimisation exercise |

Each script should be reviewed alongside its corresponding execution evidence and performance-analysis report. The specific purpose and optimisation technique for each query should be taken from its SQL and supporting documentation rather than inferred from the filename.

## 5. Execution Plans and Execution Analysis

The `Okwusogu_Mary_301903956_execution_plans/` directory contains execution-plan and execution-analysis evidence for the optimisation exercises.

The captured files include before-and-after evidence for several queries, with CSV files containing recorded execution outputs.

These artefacts are used to investigate:

- **Access methods:** Whether MySQL uses a table scan, index scan, range access, or another access method.
- **Index selection:** Which index is selected by the optimiser, where reported.
- **Rows examined:** The estimated or actual number of rows processed, depending on the evidence.
- **Filtering:** How effectively query predicates reduce the candidate rows.
- **Join processing:** The order and methods used to combine tables.
- **Sorting and temporary operations:** Whether the execution plan reports sorting or temporary-table operations.
- **Execution cost and timing:** The estimated cost and actual timing where available in the captured outputs.

Estimated values and actual measurements are not interchangeable. Any comparison must account for what each output measures.

## 6. Performance Analysis Reports

The `Okwusogu_Mary_301903956_performance_analysis/` directory contains a separate Markdown report for each query.

| Report | Coverage |
|---|---|
| `Okwusogu_Mary_301903956_Query1_performance_analysis.md` | Analysis of Query 1 |
| `Okwusogu_Mary_301903956_Query2_performance_analysis.md` | Analysis of Query 2 |
| `Okwusogu_Mary_301903956_Query3_performance_analysis.md` | Analysis of Query 3 |
| `Okwusogu_Mary_301903956_Query4_performance_analysis.md` | Analysis of Query 4 |
| `Okwusogu_Mary_301903956_Query5_performance_analysis.md` | Analysis of Query 5 |
| `Okwusogu_Mary_301903956_Query6_performance_analysis.md` | Analysis of Query 6 |

Each report should explain the query under investigation, the observed execution behaviour, the optimisation applied or evaluated, and the conclusions supported by the captured evidence.

The reports should be interpreted together with their corresponding SQL scripts and execution-plan files.

## 7. Query Result Files

The `Okwusogu_Mary_301903956_query_results/` directory contains CSV files recording query outputs.

These files support the review of returned data and help establish whether the query continues to produce the intended results following optimisation.

Where before-and-after result sets are compared, the comparison should consider equivalent test conditions, sorting requirements, duplicate handling, and the expected semantics of the query.

A faster execution is not a successful optimisation if it changes the intended result.

## 8. Screenshot Evidence

The `Okwusogu_Mary_301903956_optimization_evidence_screenshots/` directory contains Word documents with screenshots supporting the query optimisation exercises.

The evidence documents include:

- `Okwusogu_Mary_301903956_Query1_Screenshots.docx`
- `Okwusogu_Mary_301903956_Query2_Screenshots.docx`
- `Okwusogu_Mary_301903956_Query3_Screenshots.docx`
- `Okwusogu_Mary_301903956_Query4_Screenshots.docx`
- `Okwusogu_Mary_301903956_Query5_Screenshots.docx`
- `Okwusogu_Mary_301903956_Query6_Screenshots.docx`

These documents supplement the SQL scripts, execution outputs, and written analysis. They provide visual evidence of the query execution and optimisation work captured during testing.

## 9. Tools and Techniques

The portfolio uses MySQL and associated query-analysis tools. Depending on the specific query and captured evidence, the techniques include:

- SQL query execution and comparison.
- `EXPLAIN` for inspecting the optimiser's planned execution strategy.
- `EXPLAIN ANALYZE` where supported and used to obtain actual execution information.
- Execution-plan inspection and comparison.
- CSV-based output review.
- Performance-analysis documentation.
- Screenshot capture and evidence organisation.

Execution-plan features and available metrics depend on the MySQL version and the command used.

## 10. Evaluation Method

The optimisation exercises are evaluated through the following process:

1. Identify the SQL query being investigated.
2. Review the baseline SQL and available execution evidence.
3. Examine the execution strategy and identify potential inefficiencies.
4. Review the revised query or other optimisation change.
5. Compare the available before-and-after execution evidence.
6. Check whether the query results remain correct.
7. Document the observed behaviour and any limitations in the corresponding performance-analysis report.

Where execution-time measurements are available under comparable conditions, percentage change can be calculated as:

\[
\text{Time reduction (\%)} =
\frac{T_{\text{before}}-T_{\text{after}}}
{T_{\text{before}}}\times100
\]

A positive value indicates a reduction in execution time. A negative value indicates that execution time increased.

This calculation should only be used where both measurements are available and comparable. Execution-plan changes alone should not be presented as a measured percentage improvement.

## 11. Limitations and Considerations

The results of query optimisation can be affected by several factors:

- **Cache state:** Repeated executions may benefit from data already in memory.
- **Data volume and distribution:** Execution plans may change as tables grow or data selectivity changes.
- **Concurrent workload:** Other database operations can influence execution time.
- **Estimated versus actual metrics:** Optimiser estimates may differ from actual execution behaviour.
- **Index maintenance:** Additional indexes may improve some reads while increasing storage and write overhead.
- **Result correctness:** Optimisation must preserve the intended query semantics.
- **Measurement completeness:** Performance conclusions should be limited to the metrics actually captured.

These considerations are important when interpreting the evidence and deciding whether an observed change represents a meaningful optimisation.

## 12. Conclusion

Portfolio 2 documents six SQL query optimisation exercises through query scripts, execution plans, execution-analysis outputs, CSV results, performance-analysis reports, and screenshot evidence.

Together, these artefacts provide a structured record of the queries investigated, the execution behaviour observed, and the conclusions drawn from the available evidence. The effectiveness of each optimisation should be judged by the corresponding execution results, performance measurements where available, and verification of query correctness.

## 13. References

1. Oracle Corporation. *MySQL 8.0 Reference Manual: Optimization*. https://dev.mysql.com/doc/refman/8.0/en/optimization.html
2. Winand, M. (2012). *SQL Performance Explained*.
3. Schwartz, B., Zaitsev, P. and Tkachenko, V. (2012). *High Performance MySQL*. 3rd ed. O'Reilly Media.
