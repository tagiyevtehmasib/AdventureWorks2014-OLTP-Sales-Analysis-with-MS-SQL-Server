

SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesTerritory

--Unique Count of Custmers
SELECT COUNT(DISTINCT CustomerID)
FROM Sales.SalesOrderHeader


--The total_revenue give each of the custmer
SELECT so.CustomerID AS S,
SUM(so.TotalDue) AS D
FROM Sales.SalesOrderHeader so
WHERE YEAR(so.OrderDate) = 2011 
GROUP BY so.CustomerID
ORDER BY so.CustomerID



--In each of year total_revenue
SELECT YEAR(OrderDate) AS just_years,
SUM(TotalDue) AS annually_total_revenue
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate)


--In each of the year total_customers
SELECT YEAR(OrderDate) AS just_years,
COUNT(CustomerID) AS annully_total_customer
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate)

--The highest revenue generating customer each year
WITH Unique_Customer AS(
    
	SELECT YEAR(OrderDate) AS max_years,
	CustomerID AS big_customer,
	SUM(TotalDue) AS max_total
	FROM Sales.SalesOrderHeader 
	GROUP BY YEAR(OrderDate), CustomerID
),
Max_Revenue AS(
	
	SELECT u.max_years AS Last_Year,
	u.big_customer AS Last_Big_Customer,
	u.max_total AS Total_Revenue,
	ROW_NUMBER() OVER(PARTITION BY u.max_years ORDER BY u.max_total DESC) AS rn
	FROM Unique_Customer u
)
SELECT m.Last_Year,
m.Last_Big_Customer,
m.Total_Revenue
FROM Max_Revenue m
WHERE m.rn = 1









