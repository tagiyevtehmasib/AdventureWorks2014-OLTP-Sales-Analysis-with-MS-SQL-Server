
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
	SELECT unique_customer AS DG,
	total_order AS F,
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











