--1./List customers and the dates they placed an order, sorted in order date
-- sequence.

SELECT 
cust.CustomerID,
cust.CustFirstName,
cust.CustLastName,
ords.OrderDate
FROM
[SalesOrdersExample].[dbo].Customers cust
INNER JOIN 
[SalesOrdersExample].[dbo].Orders ords
ON cust.CustomerID = ords.CustomerID
ORDER BY ords.OrderDate;

--2./List employees and the customers for whom they booked an order
WITH CustOrderJoin AS 
(
	SELECT 
	DISTINCT cust.CustFirstName, 
	cust.CustLastName,
	ord.EmployeeID
	FROM 
	[SalesOrdersExample].[dbo].Customers cust
	INNER JOIN 
	[SalesOrdersExample].[dbo].Orders ord
	ON cust.CustomerID = ord.CustomerID
)
SELECT 
CustOrderJoin.CustFirstName,
CustOrderJoin.CustLastName,
emp.EmpFirstName, 
emp.EmpLastName
FROM 
[SalesOrdersExample].[dbo].Employees emp
INNER JOIN
CustOrderJoin
ON 
CustOrderJoin.EmployeeID = emp.EmployeeID;

--3./Display all orders, the products in each order, and the amount owed for each
--product, in order number sequence.

SELECT 
orders.OrderNumber, 
ordl.ProductNumber,
prod.ProductName,
prod.RetailPrice,
orders.OrderDate,
prod.RetailPrice * ordl.QuantityOrdered AS amt_owned
FROM
[SalesOrdersExample].[dbo].Orders orders
INNER JOIN 
[SalesOrdersExample].[dbo].Order_Details ordl
ON orders.OrderNumber = ordl.OrderNumber 
INNER JOIN
[SalesOrdersExample].[dbo].Products prod
ON ordl.ProductNumber = prod.ProductNumber
ORDER BY orders.OrderNumber;

SELECT *
FROM [SalesOrdersExample].[dbo].CH08_Orders_With_Products;

--4./Show me the vendors and the products they supply to us for products that
 --cost less than $100.

WITH ProdsLessThanHundreds AS
(
	SELECT  
	prodVend.VendorID,
	prodVend.ProductNumber,
	prodVend.WholesalePrice
	FROM [SalesOrdersExample].[dbo].Product_Vendors prodVend
	WHERE prodVend.WholesalePrice < 100	
)
SELECT 
vend.VendName,
vend.VendStreetAddress,
prod.ProductName,
prodVend.WholesalePrice
FROM
[SalesOrdersExample].[dbo].Vendors vend
INNER JOIN
ProdsLessThanHundreds prodVend
ON vend.VendorID = prodVend.VendorID
INNER JOIN 
[SalesOrdersExample].[dbo].Products prod
ON prodVend.ProductNumber = prod.ProductNumber
ORDER BY vend.VendName;

--4./List customers and the entertainers they booked.

SELECT 
DISTINCT
cust.CustFirstName,
cust.CustLastName,
ent.EntStageName
FROM 
[EntertainmentAgencyExample].[dbo].Customers cust
INNER JOIN 
[EntertainmentAgencyExample].[dbo].Engagements enmt
ON cust.CustomerID = enmt.CustomerID
INNER JOIN
[EntertainmentAgencyExample].[dbo].Entertainers ent
ON enmt.EntertainerID = ent.EntertainerID;

--5./List students and all the classes in which they are currently enrolled.
SELECT 
CONCAT(stu.StudFirstName,' ',stu.StudLastName) AS StudentName,
cl.ClassID
FROM [SchoolSchedulingExample].[dbo].Students stu
INNER JOIN [SchoolSchedulingExample].[dbo].Student_Schedules stu_schedule
ON stu.StudentID = stu_schedule.StudentID
INNER JOIN [SchoolSchedulingExample].[dbo].Classes cl
ON stu_schedule.ClassID = cl.ClassID
WHERE stu_schedule.ClassStatus = 1;

--6./Show me the students who have a grade of 85 or better in art and who also have a grade of 85 or better in cs
WITH CsStu AS 
(
	SELECT 
	CONCAT(stu.StudFirstName,' ',stu.StudLastName) AS StudentName,
	cl.ClassID csClass,
	stu_schedule.Grade csGrade,
	cl.SubjectID csSubject
	FROM [SchoolSchedulingExample].[dbo].Students stu
	INNER JOIN [SchoolSchedulingExample].[dbo].Student_Schedules stu_schedule
	ON stu.StudentID = stu_schedule.StudentID
	INNER JOIN [SchoolSchedulingExample].[dbo].Classes cl
	ON stu_schedule.ClassID = cl.ClassID
	WHERE cl.SubjectID IN
		(
		SELECT sub.SubjectID FROM [SchoolSchedulingExample].[dbo].Subjects sub WHERE sub.CategoryID IN ('CSC', 'CIS')
		)
	AND stu_schedule.Grade >= 85
),
ArtStu AS 
(
SELECT 
	CONCAT(stu.StudFirstName,' ',stu.StudLastName) AS StudentName,
	cl.ClassID artClass,
	stu_schedule.Grade artGrade,
	cl.SubjectID artSubject
	FROM [SchoolSchedulingExample].[dbo].Students stu
	INNER JOIN [SchoolSchedulingExample].[dbo].Student_Schedules stu_schedule
	ON stu.StudentID = stu_schedule.StudentID
	INNER JOIN [SchoolSchedulingExample].[dbo].Classes cl
	ON stu_schedule.ClassID = cl.ClassID
	WHERE cl.SubjectID IN
		(
		SELECT sub.SubjectID FROM [SchoolSchedulingExample].[dbo].Subjects sub WHERE sub.CategoryID IN ('ART')
		)
	AND stu_schedule.Grade >= 85
),
ArtCsStu AS 
(
	SELECT 
	CsStu.StudentName, 
	CsStu.csGrade, 
	CsStu.csClass,
	ArtStu.artGrade,
	ArtStu.artClass
	FROM CsStu
	INNER JOIN ArtStu
	ON CsStu.StudentName = ArtStu.StudentName
)
SELECT * FROM ArtCsStu;

--7./Display the bowlers, the matches they played in, and the bowler game
--scores.

SELECT 
CONCAT(bowlers.BowlerFirstName, ' ', bowlers.BowlerLastName) bowlerName,
team.TeamName,
bowler_scores.MatchID,
bowler_scores.HandiCapScore,
bowler_scores.RawScore,
bowler_scores.GameNumber
FROM 
[BowlingLeagueExample].[dbo].Bowlers bowlers
INNER JOIN
[BowlingLeagueExample].[dbo].Bowler_Scores bowler_scores
ON bowlers.BowlerID = bowler_scores.BowlerID
INNER JOIN 
[BowlingLeagueExample].[dbo].Teams team
ON team.TeamID = bowlers.TeamID;

--8./Find the bowlers who live in the same ZIP Code.
WITH Bowlers_ZipCode
AS 
(
	SELECT CONCAT(bowlers.BowlerFirstName, ' ', bowlers.BowlerLastName) bowlerName,
	bowlers.BowlerZip
	FROM
	[BowlingLeagueExample].[dbo].Bowlers
)

SELECT 
b1.bowlerName FirstBowler, 
b2.bowlerName SecBowler,
b1.BowlerZip
FROM 
(
	(SELECT 
	Bowlers_ZipCode.bowlerName,
	Bowlers_ZipCode.BowlerZip 
	FROM 
	Bowlers_ZipCode) b1
	INNER JOIN 
	(SELECT 
	Bowlers_ZipCode.bowlerName,
	Bowlers_ZipCode.BowlerZip 
	FROM Bowlers_ZipCode) b2
	ON b1.BowlerZip = b2.BowlerZip
	AND b1.bowlerName != b2.bowlerName
);

--9./List all the recipes for salads.

SELECT reci.RecipeTitle FROM 
[RecipesExample].[dbo].Recipes reci
WHERE reci.RecipeClassID = 
	(
	SELECT TOP 1 reci_c.RecipeClassID 
	FROM [RecipesExample].[dbo].Recipe_Classes reci_c
	WHERE reci_c.RecipeClassID = 4
	);

--10./Find the ingredients that use the same default measurement amount.

WITH Ingre_Measure
AS 
(
	SELECT  
	DISTINCT ingre.IngredientName,
	ingre.MeasureAmountID
	FROM [RecipesExample].[dbo].Ingredients ingre
)

SELECT ingreName1, ingreName2, meas.MeasurementDescription FROM 
(
	SELECT im1.IngredientName ingreName1, im2.IngredientName ingreName2, im1.MeasureAmountID measureId
	FROM Ingre_Measure im1
	INNER JOIN 
	Ingre_Measure im2
	ON im1.MeasureAmountID = im2.MeasureAmountID
) ingre_meas INNER JOIN [RecipesExample].[dbo].Measurements meas
ON ingre_meas.measureId = meas.MeasureAmountID
WHERE ingreName1!=ingreName2
ORDER BY MeasurementDescription;

--11./Show me the recipes that have beef and garlic
SELECT * FROM [RecipesExample].[dbo].Ingredients;
SELECT TOP 1 * FROM [RecipesExample].[dbo].Recipe_Ingredients;

WITH Beef_Ingres
AS 
(
	SELECT ingre.IngredientID beefIngreId
	FROM 
	[RecipesExample].[dbo].Ingredients ingre
	WHERE ingre.IngredientName = 'Beef'
),
Garlic_Ingres
AS 
(
	SELECT ingre.IngredientID garlicIngreId
	FROM 
	[RecipesExample].[dbo].Ingredients ingre
	WHERE ingre.IngredientName = 'Garlic'
),
Beef_Recs
AS 
(
	SELECT recs.RecipeID beefRecId FROM
	[RecipesExample].[dbo].Recipe_Ingredients recs
	INNER JOIN
	Beef_Ingres beef_ingres
	ON recs.IngredientID = beef_ingres.beefIngreId
),
Garlic_Recs
AS 
(
	SELECT recs.RecipeID garlicRecId FROM
	[RecipesExample].[dbo].Recipe_Ingredients recs
	INNER JOIN
	Garlic_Ingres garlic_ingres
	ON recs.IngredientID = garlic_ingres.garlicIngreId
),
Garlic_Beef_Recs
AS
(
	SELECT beef_recs.beefRecId FROM Beef_Recs beef_recs
	INNER JOIN Garlic_Recs garlic_recs
	ON beef_recs.beefRecId = garlic_recs.garlicRecId
)

SELECT recs.RecipeID, recs.RecipeTitle, recs.Preparation FROM 
Garlic_Beef_Recs gb_recs
INNER JOIN
[RecipesExample].[dbo].Recipes recs
ON gb_recs.beefRecId = recs.RecipeID;

SELECT * FROM
[RecipesExample].[dbo].CH08_Beef_And_Garlic_Recipes;