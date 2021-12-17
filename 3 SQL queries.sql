CREATE DATABASE project3;

SELECT * FROM project3.cleandata;

-- Query 1: 
-- group by age, average(balance), count(Bank deposit(target) = 'Yes')/count(Bank deposit(target))
CREATE TEMPORARY TABLE age_prob
SELECT age, avg(balance) AS avg_balance, (sum(CASE `Bank deposit(target)` WHEN 'yes' THEN 1 ELSE 0 END)/(SELECT count(*) FROM project3.cleandata)) AS probability
FROM project3.cleandata
GROUP BY age
ORDER BY probability DESC;

SELECT * FROM age_prob;

SELECT age_range, round(avg(avg_balance)) AS avg_balance, avg(probability*100) AS '%avg_probability'
FROM(SELECT *,
	CASE
		WHEN age <60 THEN '50_60'
		WHEN age <70 THEN '60_70'
		WHEN age <80 THEN '70_80'
		ELSE '80+'
	END AS age_range
FROM age_prob) sub
GROUP BY age_range
ORDER BY '%avg_probability' DESC;

-- create a sub-table for query 1
CREATE TABLE project3.age_depo AS
SELECT *
FROM (
SELECT age_range, round(avg(avg_balance)) AS avg_balance, avg(probability*100) AS '%avg_probability'
FROM(SELECT *,
	CASE
		WHEN age <60 THEN '50_60'
		WHEN age <70 THEN '60_70'
		WHEN age <80 THEN '70_80'
		ELSE '80+'
	END AS age_range
FROM age_prob) sub
GROUP BY age_range
ORDER BY '%avg_probability' DESC
) age1;

-- Query 2:
-- group by poutcome, count(Bank deposit(target) = 'Yes')/count(Bank deposit(target))

CREATE TEMPORARY TABLE poutcome_prob
SELECT poutcome, (sum(CASE `Bank deposit(target)` WHEN 'yes' THEN 1 ELSE 0 END)*100/(SELECT count(*) FROM project3.cleandata)) AS '%probability'
FROM project3.cleandata
GROUP BY poutcome;

SELECT * FROM poutcome_prob
ORDER BY '%probability';

-- ORDER BY doesn't work out properly??

-- create a sub-table for query 2
CREATE TABLE project3.poutcome_depo AS
SELECT *
FROM poutcome_prob;

#Query 3: group by house, count(Bank deposit(target) = 'Yes')/count(Bank deposit(target))
CREATE TEMPORARY TABLE housing_prob
SELECT housing, (sum(CASE `Bank deposit(target)` WHEN 'yes' THEN 1 ELSE 0 END)*100/(SELECT count(*) FROM project3.cleandata)) AS '%probability'
FROM project3.cleandata
GROUP BY housing;

SELECT * FROM housing_prob;

-- create a sub-table for query 3
CREATE TABLE project3.housing_depo AS
SELECT *
FROM housingage_depo_prob;

-- check all 3 sub-tables
SELECT * FROM project3.age_depo;
SELECT * FROM project3.poutcome_depo;
SELECT * FROM project3.housing_depo;
