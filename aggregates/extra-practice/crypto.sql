-- Scope out the whole table.
SELECT *
FROM transactions;

-- What is the total amount in 'money_in'?
SELECT SUM(money_in)
    AS total_money_in
FROM transactions;

-- What is the total amount in 'money_out'?
SELECT SUM(money_out)
    AS total_money_out
FROM transactions;

-- How many 'money_in' transactions are in the table?
SELECT COUNT(money_in)
  AS money_in_transactions
FROM transactions;

-- How many 'money_in' transactions in which 'BIT' is the currency are in the table?
SELECT COUNT(money_in)
  AS money_in_transactions
FROM transactions
WHERE currency LIKE '%BIT%';

-- What was the largest transaction in the whole table? Was it 'money_in' or 'money_out'?
SELECT MAX(money_in) as max_money_in,
    MAX(money_out) as max_money_out
FROM transactions;

-- What is the average 'money_in' in the table for the currency Ethereum ('ETH')?
SELECT ROUND(AVG(money_in), 2)
FROM transactions
WHERE currency like '%ETH%';

-- Select 'date', average 'money_in', and average 'money_out' from the table. Then group everything by 'date' to make a ledger.
SELECT date,
  ROUND(AVG(money_in), 2) AS avg_money_in,
  ROUND(AVG(money_out), 2) AS avg_money_out
FROM transactions
GROUP BY date;
