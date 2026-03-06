
-- Analysis Type : RFM




--=> Recency Analysis
WITH RecencyOrder AS 
(
	SELECT CustomerID AS last_customer,
	OrderDate AS last_order,
	ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS rank_order
	FROM Sales.SalesOrderHeader
),
RecencyMinus AS
(
	SELECT last_customer AS max_customer,
	DATEDIFF(DAY, last_order, '2014-07-3') AS max_order
	FROM RecencyOrder
	WHERE rank_order = 1
),
ScoringDate AS
(
	SELECT max_customer,
	max_order,
	NTILE(5) OVER(ORDER BY max_order DESC) AS max_score
	FROM RecencyMinus
)
SELECT * FROM ScoringDate 
ORDER BY max_order ASC


-------------------------------------------------------------------------------------------


--=> Frequency Analysis
WITH Frequency AS
(
SELECT CustomerID AS unique_customer,
COUNT(SalesOrderID) AS total_order
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
),
FrequencyScoring AS 
(
	SELECT unique_customer AS unique_customer,
	total_order AS totalorder,
	NTILE(5) OVER(ORDER BY total_order ASC) AS score_total_order
	FROM Frequency
)
SELECT * FROM FrequencyScoring 


-------------------------------------------------------------------------------------------


--=> Monetary Analysis
WITH Monetary AS 
(
	SELECT CustomerID AS m_customerID,
	SUM(TotalDue) AS m_totaldue
	FROM Sales.SalesOrderHeader
	GROUP BY CustomerID
),
MonetaryScoring AS 
(
	SELECT m_customerID AS m_customerID,
	m_totaldue AS m_totaldue,
	NTILE(5) OVER(ORDER BY m_totaldue ASC) AS m_ntilescoring
	FROM Monetary
)
SELECT * FROM MonetaryScoring 


-------------------------------------------------------------------------------------------


--Now, I will combine all three analyses I did into one CTE and combine their RFM values ​​for each unique ID using CONCAT_WS.
WITH RecencyOrder AS 
(
	SELECT CustomerID AS last_customer,
	OrderDate AS last_order,
	ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS rank_order
	FROM Sales.SalesOrderHeader
),
RecencyMinus AS
(
	SELECT last_customer AS max_customer,
	DATEDIFF(DAY, last_order, '2014-07-3') AS max_order
	FROM RecencyOrder
	WHERE rank_order = 1
),
RScoring AS
(
	SELECT max_customer,
	max_order,
	NTILE(5) OVER(ORDER BY max_order DESC) AS R
	FROM RecencyMinus
),
Frequency AS
(
	SELECT CustomerID AS unique_customer,
	COUNT(SalesOrderID) AS total_order
	FROM Sales.SalesOrderHeader
	GROUP BY CustomerID
),
FScoring AS 
(
	SELECT unique_customer AS funique_customer,
	total_order AS ftotal_order,
	NTILE(5) OVER(ORDER BY total_order ASC) AS F
	FROM Frequency
),
Monetary AS 
(
	SELECT CustomerID AS m_customerID,
	SUM(TotalDue) AS m_totaldue
	FROM Sales.SalesOrderHeader
	GROUP BY CustomerID
),
MScoring AS 
(
	SELECT m_customerID AS m_customerID,
	m_totaldue AS m_totaldue,
	NTILE(5) OVER(ORDER BY m_totaldue ASC) AS M
	FROM Monetary
)
SELECT m.m_customerID,
CONCAT_WS('',r.R,f.F,m.M)
FROM MScoring m
JOIN RScoring r
ON r.max_customer = m.m_customerID
JOIN FScoring f
ON f.funique_customer = m.m_customerID
ORDER BY m.m_customerID

-----------------------------------------------------------------------------

CREATE VIEW RFM1 AS
WITH RecencyOrder AS 
(
	SELECT CustomerID AS last_customer,
	OrderDate AS last_order,
	ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS rank_order
	FROM Sales.SalesOrderHeader
),
RecencyMinus AS
(
	SELECT last_customer AS max_customer,
	DATEDIFF(DAY, last_order, '2014-07-3') AS max_order
	FROM RecencyOrder
	WHERE rank_order = 1
),
RScoring AS
(
	SELECT max_customer,
	max_order,
	NTILE(5) OVER(ORDER BY max_order DESC) AS R
	FROM RecencyMinus
),
Frequency AS
(
	SELECT CustomerID AS unique_customer,
	COUNT(SalesOrderID) AS total_order
	FROM Sales.SalesOrderHeader
	GROUP BY CustomerID
),
FScoring AS 
(
	SELECT unique_customer AS funique_customer,
	total_order AS ftotal_order,
	NTILE(5) OVER(ORDER BY total_order ASC) AS F
	FROM Frequency
),
Monetary AS 
(
	SELECT CustomerID AS m_customerID,
	SUM(TotalDue) AS m_totaldue
	FROM Sales.SalesOrderHeader
	GROUP BY CustomerID
),
MScoring AS 
(
	SELECT m_customerID AS m_customerID,
	m_totaldue AS m_totaldue,
	NTILE(5) OVER(ORDER BY m_totaldue ASC) AS M
	FROM Monetary
)
SELECT m.m_customerID AS m_customerID,
r.R AS R1,
f.F AS F1,
m.M AS M1
FROM MScoring m
JOIN RScoring r
ON r.max_customer = m.m_customerID
JOIN FScoring f
ON f.funique_customer = m.m_customerID

------------------------------------------------------------------------------------------------------------

--But in this section, I evaluated the result with 3 main parameters using the keywords "between and".

CREATE VIEW V2RFM2 AS
SELECT m_customerID,
(R1 + F1 + M1) as total_rfm,
CONCAT_WS('', R1, F1, M1) AS RFM1,
CASE 
	WHEN (R1 + F1 + M1) BETWEEN 13 AND 15 THEN 'Qızıl' 
	WHEN (R1 + F1 + M1) BETWEEN 8 AND 12 THEN 'Gümüş'
	ELSE 'Bürünc'
END AS Dereceler
FROM RFM1

------------------------------------------------------------------------------------------------------------

--I had created in mistake form.
--SELECT * FROM RFM
--DROP VIEW RFM

------------------------------------------------------------------------------------------------------------

--I had to write many segment here, so I didn't write all of them.
--SELECT m_customerID,
--CONCAT_WS('', R1, F1, M1),
--CASE
--	WHEN R1 = 5 AND F1 = 5 AND M1 = 5 THEN 'Çempionlar'
--	WHEN (R1 = 4 OR R1 = 5) AND (F1 = 4 OR F1 = 5) AND (M1 = 4 OR M1 = 5) THEN 'Sadiq Müştərilər'
--	WHEN (R1 = 3 OR R1 = 4) AND (F1 = 3 OR F1 = 4) AND (M1 = 3 OR M1 = 4) THEN 'Potensial Sadiqlər'
--	WHEN R1 = 5 AND (F1 = 1 OR F1 = 2) AND (M1 = 1 OR M1 = 2) THEN 'Yeni Müştərilə'
--	WHEN (R1 = 2 OR R1 = 3) AND (F1 = 2 OR F1 = 3) AND (M1 = 2 OR M1 = 3) THEN 'Risk Altında Olan Müştərilər'
--	WHEN (R1 = 1 OR R1 = 2) AND F1 = 1 AND M1 = 1 THEN 'İtirilmiş Müştərilər'
--	ELSE NULL
--END
--FROM RFM1

------------------------------------------------------------------------------------------------------------
--Count of customer in every segment.
SELECT Dereceler,
COUNT(m_customerID) AS total_customer_count
FROM V2RFM2
GROUP BY Dereceler

------------------------------------------------------------------------------------------------------------
--Total revenue of in every segment.
SELECT v.Dereceler,
SUM(s.TotalDue) AS totalsum_forevery_segment
FROM V2RFM2 v
JOIN Sales.SalesOrderHeader s
ON v.m_customerID = s.CustomerID
GROUP BY v.Dereceler

------------------------------------------------------------------------------------------------------------
--Average total revenue per customer..
SELECT v.m_customerID,
AVG(s.TotalDue)
FROM V2RFM2 v
JOIN Sales.SalesOrderHeader s
ON v.m_customerID = s.CustomerID
GROUP BY v.m_customerID





