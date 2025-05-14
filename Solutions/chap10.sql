--1./
SELECT 
r.RecipeTitle
FROM [RecipesExample].[dbo].Recipes r
UNION
SELECT 
rc.RecipeClassDescription
FROM [RecipesExample].[dbo].Recipe_Classes rc;

--2./
SELECT
CONCAT(c.CustFirstName, ' ', c.CustLastName) custName,
c.CustCity,
c.CustState,
c.CustZipCode,
c.CustStreetAddress
FROM
[SalesOrdersExample].[dbo].Customers c
UNION
SELECT
v.VendName,
v.VendCity,
v.VendState,
v.VendZipCode,
v.VendStreetAddress
FROM
[SalesOrdersExample].[dbo].Vendors v;

--3./List customers and the bikes they ordered combined with vendors and the bikes
--they sell
SELECT 
CONCAT(c.CustLastName,' ',c.CustFirstName) as FullName,
prd.ProductName, 'Customer' as RowID
FROM 
[SalesOrdersExample].[dbo].Customers c
INNER JOIN 
[SalesOrdersExample].[dbo].Orders ord
ON c.CustomerID = ord.CustomerID
INNER JOIN
[SalesOrdersExample].[dbo].Order_Details ord_de
ON ord.OrderNumber = ord_de.OrderNumber
INNER JOIN
[SalesOrdersExample].[dbo].Products prd
ON ord_de.ProductNumber = prd.ProductNumber 
WHERE prd.ProductName LIKE '%bike%'
UNION 
SELECT v.VendName, p.ProductName, 'Vendor' AS RowID FROM 
[SalesOrdersExample].[dbo].Vendors v
INNER JOIN 
[SalesOrdersExample].[dbo].Product_Vendors pv
ON v.VendorID = pv.VendorID
INNER JOIN
[SalesOrdersExample].[dbo].Products p
ON pv.ProductNumber = p.ProductNumber
WHERE p.ProductName LIKE '%bike%';
