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

--4./Show me all the customer and employee names and addresses, including any
--duplicates, sorted by ZIP Code.

WITH emp
AS
(
	SELECT 
	CONCAT(e.EmpFirstName, ' ', e.EmpLastName) entityName,
	CONCAT(e.EmpStreetAddress,', ',e.EmpCity,', ', e.EmpState, ', ', e.EmpZipCode) addr, 
	'employee' as RowID,
	e.EmpZipCode
	FROM 
	[SalesOrdersExample].[dbo].Employees e
),cus
AS 
(
	SELECT 
	CONCAT(c.CustFirstName, ' ', c.CustLastName) entityName,
	CONCAT(c.CustStreetAddress,', ',c.CustCity,', ',c.CustState, ', ',c.CustZipCode) addr,
	'customer' AS RowID,
	c.CustZipCode
	FROM 
	[SalesOrdersExample].[dbo].Customers c
)

SELECT * FROM 
cus
UNION ALL
SELECT * FROM 
emp 
ORDER By cus.CustZipCode;

--5./List all the customers who ordered a bicycle combined with all the customers
--who ordered a helmet.
WITH bi_cust AS 
(
	SELECT 
	c.CustFirstName, 
	c.CustLastName, 
	'Bicycle' as prodType 
	FROM 
	[SalesOrdersExample].[dbo].Customers c
	INNER JOIN 
	[SalesOrdersExample].[dbo].Orders ord
	ON c.CustomerID = ord.CustomerID
	INNER JOIN 
	[SalesOrdersExample].[dbo].Order_Details ord_de
	ON ord.OrderNumber = ord_de.OrderNumber
	INNER JOIN 
	[SalesOrdersExample].[dbo].Products p
	ON ord_de.ProductNumber = p.ProductNumber
	WHERE p.ProductName LIKE '%bike%'
),helmet_cust AS 
(
	SELECT 
	c.CustFirstName,
	c.CustLastName, 
	'Helmet' as ProdType
	FROM 
	[SalesOrdersExample].[dbo].Customers c
	INNER JOIN 
	[SalesOrdersExample].[dbo].Orders ord
	ON c.CustomerID = ord.CustomerID
	INNER JOIN 
	[SalesOrdersExample].[dbo].Order_Details ord_de
	ON ord.OrderNumber = ord_de.OrderNumber
	INNER JOIN 
	[SalesOrdersExample].[dbo].Products p
	ON ord_de.ProductNumber = p.ProductNumber
	WHERE p.ProductName LIKE '%helmet%'
)
SELECT 
* 
FROM 
bi_cust 
UNION 
SELECT 
* 
FROM
helmet_cust;

--6./
--Show me the students who have a grade of 85 or better in Art together with the
--faculty members who teach Art and have a proficiency rating of 9 or better.
WITH art_stu AS
(
	SELECT 
	s.StudFirstName,
	s.StudLastName,
	sub.SubjectName,
	stu_sc.Grade,
	'Student' AS EntityRole
	FROM 
	[SchoolSchedulingExample].[dbo].Students s
	INNER JOIN
	[SchoolSchedulingExample].[dbo].Student_Schedules stu_sc
	ON s.StudentID = stu_sc.StudentID
	INNER JOIN 
	[SchoolSchedulingExample].[dbo].Classes cl
	ON stu_sc.ClassID = cl.ClassID
	INNER JOIN 
	[SchoolSchedulingExample].[dbo].Subjects sub
	ON cl.SubjectID = sub.SubjectID
	WHERE 
	sub.CategoryID = 'ART'
	AND stu_sc.Grade >= 85
),
staff_art AS
(
	SELECT 
	st.StfFirstName,
	st.StfLastname,
	sub.CategoryID,
	fal_sub.ProficiencyRating,
	'Professor' AS EntityRole
	FROM  
	[SchoolSchedulingExample].[dbo].Staff st
	INNER JOIN
	[SchoolSchedulingExample].[dbo].Faculty_Subjects fal_sub
	ON st.StaffID = fal_sub.StaffID
	INNER JOIN
	[SchoolSchedulingExample].[dbo].Subjects sub
	ON fal_sub.SubjectID = sub.SubjectID
	WHERE sub.CategoryID = 'ART' AND fal_sub.ProficiencyRating >= 9
)
SELECT 
* 
FROM 
art_stu 
UNION
SELECT 
* 
FROM
staff_art
;

--7./List the customers who ordered a helmet together with the vendors who
--provide helmets
WITH cus_helments
AS
(
	SELECT 
	CONCAT(c.CustFirstName,' ',c.CustLastName) as custName,
	prod.ProductName,
	'Customer' AS entityRole
	FROM 
	[SalesOrdersExample].[dbo].Customers c
	INNER JOIN
	[SalesOrdersExample].[dbo].Orders ord
	ON c.CustomerID = ord.CustomerID
	INNER JOIN
	[SalesOrdersExample].[dbo].Order_Details ord_de
	ON ord.OrderNumber = ord_de.OrderNumber
	INNER JOIN
	[SalesOrdersExample].[dbo].Products prod
	ON ord_de.ProductNumber = prod.ProductNumber
	WHERE prod.ProductName LIKE '%helmet%'
),
vend_helmets AS
(
	SELECT 
	v.VendName as vendName,
	prod.ProductName,
	'Vendor' AS entityRole
	FROM 
	[SalesOrdersExample].[dbo].Vendors v
	INNER JOIN
	[SalesOrdersExample].[dbo].Product_Vendors prod_v
	ON v.VendorID = prod_v.VendorID
	INNER JOIN
	[SalesOrdersExample].[dbo].Products prod
	ON prod_v.ProductNumber = prod.ProductNumber
	WHERE prod.ProductName LIKE '%helmet%'
)

SELECT * FROM cus_helments UNION SELECT * FROM vend_helmets;