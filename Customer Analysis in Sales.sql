

SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesTerritory


--Unique total count of custmers
SELECT COUNT(DISTINCT CustomerID) AS total_unique_customer
FROM Sales.SalesOrderHeader
WHERE CustomerID IS NOT NULL


--The total_revenue give each of the custmer
SELECT YEAR(so.OrderDate) AS unique_years,
so.CustomerID AS unique_customers,
SUM(so.TotalDue) AS total_revenue
FROM Sales.SalesOrderHeader so
GROUP BY YEAR(so.OrderDate), so.CustomerID
ORDER BY unique_years


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


--The highest revenue generating customer each year. WITH DOUBLE SUBQUERY.
SELECT rw.year_row,
rw.customer_row,
rw.revenue_row
FROM 
(SELECT uyc.unique_years AS year_row,
uyc.unique_customers AS customer_row,
uyc.total_revenue AS revenue_row,
ROW_NUMBER() OVER(PARTITION BY uyc.unique_years ORDER BY uyc.total_revenue DESC) AS rank_revenue
FROM 
(SELECT YEAR(so.OrderDate) AS unique_years,
so.CustomerID AS unique_customers,
SUM(so.TotalDue) AS total_revenue
FROM Sales.SalesOrderHeader so
GROUP BY YEAR(so.OrderDate), so.CustomerID
) AS uyc
) AS rw
WHERE rank_revenue = 1


--Show unique_order and count of orderqty and unique_sublinetotal
SELECT sr.unique_order,
sr.orderqty,
sr.linetotal
FROM (
SELECT SalesOrderID AS unique_order,
OrderQty AS orderqty,
LineTotal AS linetotal,
ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC) AS line_rank
FROM Sales.SalesOrderDetail
) AS sr
WHERE sr.line_rank = 1


SELECT * FROM Purchasing.Vendor 
SELECT * FROM Purchasing.ProductVendor WHERE BusinessEntityID = 1514

SELECT BusinessEntityID,
COUNT(ProductID)
FROM Purchasing.ProductVendor
GROUP BY BusinessEntityID


SELECT ProductID,
SUM(LineTotal)
FROM Sales.SalesOrderDetail WHERE ProductID = 777
GROUP BY ProductID

SELECT 
(ssd.UnitPrice - ppd.UnitPrice)
FROM Sales.SalesOrderDetail ssd
JOIN Purchasing.PurchaseOrderDetail ppd
ON ssd.ProductID = ppd.ProductID

WITH TotalSalesRevenue AS 
(
	SELECT ProductID AS revenue_productID,
	SUM(OrderQty * UnitPrice) AS total_revenue
	FROM Sales.SalesOrderDetail
	GROUP BY ProductID
),
TotalPurchaseCost AS
(
	SELECT ProductID AS total_costid,
	SUM(OrderQty * UnitPrice) AS total_cost
	FROM Purchasing.PurchaseOrderDetail
	GROUP BY ProductID
)
SELECT SUM(tr.total_revenue - tc.total_cost)
FROM TotalPurchaseCost tc
RIGHT JOIN TotalSalesRevenue tr
ON tc.total_costid = tr.revenue_productID

















