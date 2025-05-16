-- The Table creation 

CREATE TABLE LOANS (
loan_id SERIAL PRIMARY KEY,
user_id INT NOT NULL,
total_amount_disbursed DECIMAL(10,2) NOT NULL,
disbursement_date DATE NOT NULL
);
 
CREATE TABLE PAYMENTS (
payment_id SERIAL PRIMARY KEY,
loan_id INT NOT NULL,
amount DECIMAL(10,2) NOT NULL,
type VARCHAR(20) CHECK (type IN ('disbursement', 'repayment')),
payment_timestamp TIMESTAMP NOT NULL,
FOREIGN KEY (loan_id) REFERENCES LOANS(loan_id) ON DELETE CASCADE
);

--Values Insertion into loans
INSERT INTO LOANS (user_id, total_amount_disbursed, disbursement_date) VALUES
(1, 5000, '2022-09-02'),
(2, 6000, '2022-09-02'),
(1, 1000, '2022-10-05'),
(3, 10000, '2022-09-02');

--Value insertion into Payments
INSERT INTO PAYMENTS (loan_id, amount, type, payment_timestamp) VALUES
(1, 5000, 'disbursement', '2022-10-01 05:01:12'),
(2, 100, 'repayment', '2022-10-01 05:05:12'),
(1, 1000, 'repayment', '2022-10-01 05:31:01'),
(2, 10, 'repayment', '2022-11-01 03:11:01');


-- Query for Question 1
WITH DateSeries AS (
    SELECT 
        l.user_id,
        l.loan_id,
        l.total_amount_disbursed,
        d.date
    FROM LOANS l
    CROSS JOIN generate_series(l.disbursement_date, l.disbursement_date + INTERVAL '60 days', INTERVAL '1 day') d(date)
),
PaymentSummary AS (
    SELECT
        loan_id,
        DATE(payment_timestamp) AS payment_date,
        SUM(CASE WHEN type = 'repayment' THEN amount ELSE 0 END) AS total_repaid,
        MAX(CASE WHEN type = 'repayment' THEN payment_timestamp END) AS latest_repayment_date
    FROM PAYMENTS
    GROUP BY loan_id, DATE(payment_timestamp)
)
SELECT
    ds.date,
    ds.user_id,
    ds.loan_id,
    ds.total_amount_disbursed,
    ds.total_amount_disbursed - COALESCE((
        SELECT SUM(ps.total_repaid)
        FROM PaymentSummary ps
        WHERE ps.loan_id = ds.loan_id AND ps.payment_date <= ds.date
    ), 0) AS total_outstanding_amount,
    (
        SELECT MAX(ps.latest_repayment_date)
        FROM PaymentSummary ps
        WHERE ps.loan_id = ds.loan_id AND ps.payment_date <= ds.date
    ) AS latest_repayment_date
	INTO loans_and_repmyt_summary
FROM DateSeries ds
ORDER BY ds.date, ds.user_id, ds.loan_id;
