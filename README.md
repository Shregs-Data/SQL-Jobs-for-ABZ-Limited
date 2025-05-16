# SQL-Jobs-for-ABZ-Limited
### Q1 
#### Consider the following tables and provide SQL queries for the questions that follow.
LOANS
| loan_id | user_id | total_amount_disbursed | disbursement_date |
|---------|:-------:|------------------------:|-------------------:|
| 1       |   1     |                   5000  |        2022-09-02  |
| 2       |   2     |                   6000  |        2022-09-02  |
| 3       |   1     |                   1000  |        2022-10-05  |
| 4       |   3     |                  10000  |        2022-09-02  |

PAYMENTS
| payment_id | loan_id | amount |     type      |     payment_timestamp     |
|------------|---------|--------|---------------|----------------------------|
|     1      |    1    |  5000  | disbursement  | 2022-10-01 05:01:12       |
|     2      |    2    |   100  | repayment     | 2022-10-01 05:05:12       |
|     3      |    1    |  1000  | repayment     | 2022-10-01 05:31:01       |
|     4      |    2    |    10  | repayment     | 2022-11-01 03:11:01       |

### Q1. Daily Outstanding Balance for Each User-Loan Combination

**Task:**  
Write a query to create a table that will show the **total outstanding balance** for each day, starting from the **disbursement date** until the **last repayment date** of the loan, for every user-loan combination.

**Assumption:**  
All loans have a tenure of **60 days**.

---

#### 1.1. Total Outstanding Balance at Each Day

**Definition:**  
**Total Outstanding Balance** =  
`Total Disbursed Amount` *(type = 'disbursement' in the `PAYMENTS` table)*  
−  
`Total Repaid Amount` *(type = 'repayment' in the `PAYMENTS` table)*

---

#### 1.2. Latest Repayment Date at Each Day

Track and include the **latest repayment date** observed up to each day in the report.



