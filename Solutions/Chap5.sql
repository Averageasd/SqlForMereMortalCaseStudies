--q1. What if we adjusted each product price by reducing it 5 percent?
SELECT 
ProductNumber,
WholesalePrice,
CAST(CONVERT(DECIMAL(10,2),WholesalePrice - (WholesalePrice * 0.05)) AS nvarchar) 
	AS DiscountedPrice
FROM [SalesOrdersExample].[dbo].Product_Vendors;

--q2. Show me a list of orders made by each customer in descending date order.
SELECT 
OrderNumber, 
CustomerID,
OrderDate
FROM [SalesOrdersExample].[dbo].Orders
ORDER BY OrderNumber ASC, 
CustomerID ASC,
OrderDate DESC;	

--q3. Compile a complete list of vendor names and addresses in vendor name
--order.
SELECT
VendName,
CONCAT(VendStreetAddress, ' ', VendCity, ' ', VendState,' ', VendZipCode) AS VendAddress
FROM [SalesOrdersExample].[dbo].Vendors
ORDER BY VendName DESC;


--q4.Show the date of each agent’s first six-month performance review.
SELECT 
AgentID,
DATEADD(Day, 180, DateHired) AS Performance_Review_Date
FROM [EntertainmentAgencyExample].[dbo].Agents;

SELECT 
TourneyLocation,
DATEADD(year,1,TourneyDate) AS NextYearDate
FROM [BowlingLeagueExample].[dbo].Tournaments;

SELECT 
TeamID,
CONCAT(BowlerFirstName, ' ',BowlerLastName) AS BowlerName
FROM [BowlingLeagueExample].[dbo].Bowlers
ORDER BY TeamID ASC;