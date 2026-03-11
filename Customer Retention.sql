


SELECT CustomerID,
MIN(OrderDate),
DATEFROMPARTS(YEAR(MIN(OrderDate)), MONTH(MIN(OrderDate)), 1) AS montly_cohort
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2011
GROUP BY CustomerID
ORDER BY MIN(OrderDate)

