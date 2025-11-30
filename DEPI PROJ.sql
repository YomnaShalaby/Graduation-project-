-------------------------------------------------------------------------------------------------------------------------------

-- Creating Sales View contain Quarter, Year
CREATE VIEW FactSales
WITH SCHEMABINDING
AS
SELECT 
	S.OrderID,
	S.CusID,
	S.ProdcutID,
	S.ProductionQuantity,
	S.OrderedQuantity,
	S.sale_date as 'Date',
	year(S.sale_date) as 'Year',
	DATEPART(QUARTER, S.sale_date) as 'Quarter',
	CONCAT(S.ProdcutID, DATEPART(QUARTER, S.sale_date), year(S.sale_date)) as 'PID-Q-Y'
FROM dbo.Sales S

Select * from FactSales


-------------------------------------------------------------------------------------------------------------------------------

-- Creating Defects View contain Reason for each Damaged quantity 
CREATE VIEW DEFECTSQ
WITH SCHEMABINDING
AS
SELECT D.RecID,
	   D.OrderID,
	   D.DamagedQuantity,
	   CASE
		  WHEN D.DamagedQuantity <= 979 THEN 'Operator Errors'
		  WHEN D.DamagedQuantity <= 1958 THEN 'Packing Material Defects'
		  WHEN D.DamagedQuantity <= 2937 THEN 'Environmental Conditions'
		  ELSE 'Machine Failures'
	   END AS DamageReason
FROM dbo.Defects D

select * From DEFECTSQ

-------------------------------------------------------------------------------------------------------------------------------
-- Creating Product View contain Quarter, Year, Price per Q, Cost(Prodcution, Shipped)
CREATE VIEW PRODCUTS
AS
SELECT 
	P.ProdcutID, 
	P.ProductName, 
	P.Category, 
	year(P.Date) as Year, 
	DATEPART(QUARTER, P.Date) as Quarter,
	MAX(Sales_price_per_kg)  as Price,
	MAX(Sales_price_per_kg) * 0.2 as ProdutionCost,
	MAX(Sales_price_per_kg) * 0.1 as shippedCost,
	CONCAT(P.ProdcutID, DATEPART(QUARTER, P.Date), year(P.Date)) as 'PID-Q-Y'
FROM dbo.Products P
GROUP BY
	P.ProdcutID, 
	P.ProductName, 
	P.Category, 
	year(P.Date), 
	DATEPART(QUARTER, P.Date)

-------------------------------------------------------------------------------------------------------------------------------

-- Creating Product View contain Quarter, Year, Price per Q, Cost(Prodcution, Shipped)
CREATE VIEW PRODCUTS
AS
SELECT 
	P.ProdcutID, 
	P.ProductName, 
	P.Category, 
	year(P.Date) as Year, 
	DATEPART(QUARTER, P.Date) as Quarter,
	ROUND(AVG(Sales_price_per_kg) + (ABS(CHECKSUM(CONCAT(ProdcutID, year(P.Date), DATEPART(QUARTER, P.Date)))) % 50),2) AS Price,
	ROUND(AVG(Sales_price_per_kg) + (ABS(CHECKSUM(CONCAT(ProdcutID, year(P.Date), DATEPART(QUARTER, P.Date)))) % 50),2) * 0.2 as ProdutionCost,
	ROUND(AVG(Sales_price_per_kg) + (ABS(CHECKSUM(CONCAT(ProdcutID, year(P.Date), DATEPART(QUARTER, P.Date)))) % 50),2) * 0.1 as shippedCost,
	CONCAT(P.ProdcutID, DATEPART(QUARTER, P.Date), year(P.Date)) as 'PID-Q-Y'
FROM dbo.Products P LEFT JOIN RandProducts RP ON P.ProdcutID = RP.PID and P.Date = RP.DATE_P
GROUP BY
	P.ProdcutID, 
	P.ProductName,
	P.Category, 
	year(P.Date), 
	DATEPART(QUARTER, P.Date)


SELECT * FROM PRODCUTS P
WHERE P.ProductName = 'Apples'