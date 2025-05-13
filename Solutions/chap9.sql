-- 1./Show me all the recipe types and any matching recipes in my database.--
SELECT TOP 1 * FROM [RecipesExample].[dbo].Recipe_Classes;
SELECT TOP 1 * FROM [RecipesExample].[dbo].Recipes;

SELECT r.RecipeTitle, rc.RecipeClassDescription FROM 
[RecipesExample].[dbo].Recipe_Classes rc
LEFT JOIN 
[RecipesExample].[dbo].Recipes r
ON rc.RecipeClassID = r.RecipeClassID;

-- 2./List the recipe classes that do not yet have any recipes.--
SELECT rc.RecipeClassDescription FROM 
[RecipesExample].[dbo].Recipe_Classes rc
LEFT JOIN 
[RecipesExample].[dbo].Recipes r
ON rc.RecipeClassID = r.RecipeClassID
WHERE r.RecipeID IS NULL;

-- 3./What products have never been ordered?
SELECT TOP 1 * FROM [SalesOrdersExample].[dbo].Products;
SELECT TOP 1 * FROM [SalesOrdersExample].[dbo].Order_Details;

SELECT
prods.ProductNumber,
prods.ProductName
FROM
[SalesOrdersExample].[dbo].Products prods
LEFT JOIN 
[SalesOrdersExample].[dbo].Order_Details ord_details
ON prods.ProductNumber = ord_details.ProductNumber
WHERE ord_details.OrderNumber IS NULL;

-- 4./Display all customers and any orders for bicycles.--
SELECT TOP 1 * FROM [SalesOrdersExample].[dbo].Customers;
SELECT * FROM [SalesOrdersExample].[dbo].Products;
SELECT * FROM [SalesOrdersExample].[dbo].Order_Details;
SELECT * FROM [SalesOrdersExample].[dbo].Orders;
SELECT * FROM [SalesOrdersExample].[dbo].Categories;

WITH BikeOrders
AS
(
	SELECT 
	prod.ProductNumber prodNum,
	prod.ProductName prodName,
	ord.CustomerID
	FROM
	[SalesOrdersExample].[dbo].Orders ord
	INNER JOIN 
	[SalesOrdersExample].[dbo].Order_Details ord_de
	ON ord.OrderNumber = ord_de.OrderNumber
	FULL JOIN
	[SalesOrdersExample].[dbo].Products prod
	ON ord_de.ProductNumber = prod.ProductNumber
	INNER JOIN [SalesOrdersExample].[dbo].Categories cat
	ON prod.CategoryID = cat.CategoryID
	WHERE cat.CategoryDescription = 'Bikes'
)

SELECT * FROM 
[SalesOrdersExample].[dbo].Customers cust
LEFT JOIN BikeOrders biko
ON cust.CustomerID = biko.CustomerID;

--5./List entertainers who have never been booked.--
SELECT TOP 1 * FROM [EntertainmentAgencyExample].[dbo].Entertainers;
SELECT TOP 1 * FROM [EntertainmentAgencyExample].[dbo].Engagements;

SELECT 
ent.EntertainerID,
ent.EntStageName
FROM
[EntertainmentAgencyExample].[dbo].Entertainers ent
LEFT JOIN 
[EntertainmentAgencyExample].[dbo].Engagements eng
ON ent.EntertainerID = eng.EntertainerID
WHERE eng.EngagementNumber IS NULL;

--6./Show me all musical styles and the customers who prefer those styles--
SELECT * FROM [EntertainmentAgencyExample].[dbo].Musical_Preferences;
SELECT * FROM [EntertainmentAgencyExample].[dbo].Musical_Styles;

WITH MusicalPrefs AS
(
SELECT mp.StyleID, mp.CustomerID custId, CONCAT(cust.CustFirstName, ' ', cust.CustLastName) AS custName 
FROM
[EntertainmentAgencyExample].[dbo].Customers cust
INNER JOIN
[EntertainmentAgencyExample].[dbo].Musical_Preferences mp
ON mp.CustomerID = cust.CustomerID
)

SELECT ms.StyleName, MusicalPrefs.StyleID, MusicalPrefs.custId, MusicalPrefs.custName FROM
[EntertainmentAgencyExample].[dbo].Musical_Styles ms
LEFT JOIN
MusicalPrefs 
ON ms.StyleID = MusicalPrefs.StyleID;

--7./List the faculty members not teaching a class.--

SELECT TOP 1 * FROM [SchoolSchedulingExample].[dbo].Faculty;
SELECT TOP 1 * FROM [SchoolSchedulingExample].[dbo].Faculty_Classes;
SELECT TOP 1 * FROM [SchoolSchedulingExample].[dbo].Classes;

SELECT st.StfFirstName, st.StfLastname  
FROM
[SchoolSchedulingExample].[dbo].Staff st
LEFT JOIN
[SchoolSchedulingExample].[dbo].Faculty_Classes fal_cl
ON st.StaffID = fal_cl.StaffID
WHERE fal_cl.ClassID IS NULL;

--8./Display students who have never withdrawn from a class
SELECT TOP 1 * FROM [SchoolSchedulingExample].[dbo].Students;
SELECT TOP 1 * FROM [SchoolSchedulingExample].[dbo].Student_Schedules;
SELECT * FROM [SchoolSchedulingExample].[dbo].Student_Class_Status;

WITH WithDrawStus AS
(
	SELECT stu_sche.StudentID, stu_sche.ClassStatus FROM
	[SchoolSchedulingExample].[dbo].Student_Schedules stu_sche
	WHERE stu_sche.ClassStatus = 3
)
SELECT non_wd_stu.StudFirstName,  non_wd_stu.StudLastName FROM
[SchoolSchedulingExample].[dbo].Students non_wd_stu 
LEFT JOIN 
WithDrawStus 
ON non_wd_stu.StudentID = WithDrawStus.StudentID
WHERE WithDrawStus.StudentID IS NULL;

--9./Show me all subject categories and any classes for all 
SELECT * FROM [SchoolSchedulingExample].[dbo].Categories;
SELECT * FROM [SchoolSchedulingExample].[dbo].Subjects;
SELECT * FROM [SchoolSchedulingExample].[dbo].Classes;

SELECT sub.CategoryID, sub.SubjectName, cl.ClassID FROM
[SchoolSchedulingExample].[dbo].Categories cat
LEFT JOIN
[SchoolSchedulingExample].[dbo].Subjects sub
ON cat.CategoryID = sub.CategoryID
LEFT JOIN
[SchoolSchedulingExample].[dbo].Classes cl
ON sub.SubjectID = cl.SubjectID;

--10./Show me tournaments that haven’t been played yet.
SELECT t.TourneyID, t.TourneyDate, t.TourneyLocation 
FROM [BowlingLeagueExample].[dbo].Tournaments t
LEFT JOIN
[BowlingLeagueExample].[dbo].Tourney_Matches tm
ON t.TourneyID = tm.TourneyID
WHERE tm.MatchID IS NULL;

--11./Show me customers who have never ordered a helmet.
SELECT TOP 1 * FROM [SalesOrdersExample].[dbo].Orders;
SELECT TOP 1 * FROM [SalesOrdersExample].[dbo].Order_Details;
SELECT TOP 1 * FROM [SalesOrdersExample].[dbo].Products;

SELECT
c.CustomerID,
CONCAT(c.CustFirstName,' ',c.CustLastName) custName
FROM 
[SalesOrdersExample].[dbo].Customers c
LEFT JOIN 
(
SELECT 
ord_de.OrderNumber ordNum,
ord.CustomerID custId
FROM [SalesOrdersExample].[dbo].Products prod
INNER JOIN [SalesOrdersExample].[dbo].Order_Details ord_de
ON prod.ProductNumber = ord_de.ProductNumber
INNER JOIN [SalesOrdersExample].[dbo].Orders ord
ON ord_de.OrderNumber = ord.OrderNumber
WHERE prod.ProductName LIKE '%Helmet%'
) helmet_ords
ON c.CustomerID = helmet_ords.custId
WHERE helmet_ords.ordNum IS NULL;

--12./Display customers who have no sales rep (employees) in the same ZIP Code.--
SELECT TOP 1 * FROM [SalesOrdersExample].[dbo].Customers;
SELECT TOP 1 * FROM [SalesOrdersExample].[dbo].Employees;
SELECT TOP 1 * FROM [SalesOrdersExample].[dbo].Orders;

SELECT 
c.CustFirstName,
c.CustLastName,
c.CustomerID, 
c.CustZipCode
FROM
[SalesOrdersExample].[dbo].Customers c
LEFT JOIN
[SalesOrdersExample].[dbo].Employees e
ON c.CustZipCode = e.EmpZipCode
WHERE e.EmployeeID IS NULL;

--13./
SELECT TOP 1 * FROM [SalesOrdersExample].[dbo].Order_Details;
SELECT TOP 1 * FROM [SalesOrdersExample].[dbo].Orders;
SELECT TOP 1 * FROM [SalesOrdersExample].[dbo].Products;

SELECT 
inner_table.ProductNumber,
inner_table.OrderDate
FROM
[SalesOrdersExample].[dbo].Products prod
LEFT JOIN
(
SELECT 
DISTINCT
ord_de.ProductNumber,
ord.OrderDate
FROM
[SalesOrdersExample].[dbo].Orders ord
INNER JOIN
[SalesOrdersExample].[dbo].Order_Details ord_de
ON ord.OrderNumber = ord_de.OrderNumber
) inner_table
ON prod.ProductNumber = inner_table.ProductNumber
ORDER BY prod.ProductNumber;

--13./Display agents who haven’t booked an entertainer.
SELECT TOP 1 * FROM [EntertainmentAgencyExample].[dbo].Entertainers;
SELECT TOP 1 * FROM [EntertainmentAgencyExample].[dbo].Agents;
SELECT TOP 1 * FROM [EntertainmentAgencyExample].[dbo].Engagements;

SELECT ag.AgtFirstName, ag.AgtLastName FROM
[EntertainmentAgencyExample].[dbo].Agents ag
LEFT JOIN
[EntertainmentAgencyExample].[dbo].Engagements eng
ON ag.AgentID = eng.AgentID
WHERE eng.EngagementNumber IS NULL;

--14./List customers with no bookings
SELECT 
c.CustomerID,
CONCAT(c.CustFirstName,' ',c.CustLastName) as 'Customer Name No Booking'
FROM 
[EntertainmentAgencyExample].[dbo].Customers c
LEFT JOIN
[EntertainmentAgencyExample].[dbo].Engagements eng
ON c.CustomerID = eng.CustomerID
WHERE eng.EngagementNumber IS NULL;

--15./List all entertainers and any engagements they have booked
SELECT 
ent.EntertainerID,
ent.EntStageName,
eng.EngagementNumber, 
eng.StartDate
FROM 
[EntertainmentAgencyExample].[dbo].Entertainers ent
LEFT JOIN
[EntertainmentAgencyExample].[dbo].Engagements eng
ON ent.EntertainerID = eng.EntertainerID
ORDER BY eng.EngagementNumber;

--16./Show me classes that have no students enrolled
SELECT * FROM [SchoolSchedulingExample].[dbo].Students;
SELECT * FROM [SchoolSchedulingExample].[dbo].Student_Schedules;
SELECT * FROM [SchoolSchedulingExample].[dbo].Student_Class_Status;

SELECT 
classes.ClassID, 
classes.ClassRoomID 
FROM
[SchoolSchedulingExample].[dbo].Classes classes
LEFT JOIN
(
SELECT 
stu_sc.ClassID, stu_sc.ClassStatus
FROM 
[SchoolSchedulingExample].[dbo].Classes cl
INNER JOIN
[SchoolSchedulingExample].[dbo].Student_Schedules stu_sc
ON cl.ClassID = stu_sc.ClassID 
WHERE stu_sc.ClassStatus = 1
) inner_cl ON classes.ClassID = inner_cl.ClassID
WHERE inner_cl.ClassID IS NULL
ORDER BY classes.ClassID;

--17./Display subjects with no faculty assigned
SELECT 
sub.SubjectID,
sub.SubjectName,
sub.SubjectCode
FROM 
[SchoolSchedulingExample].[dbo].Subjects sub
LEFT JOIN 
[SchoolSchedulingExample].[dbo].Faculty_Subjects fal_sub
ON sub.SubjectID = fal_sub.SubjectID
WHERE fal_sub.SubjectID IS NULL;

--18./ List students not currently enrolled in any classes.
SELECT 
stu.StudentID,
stu.StudFirstName,
stu.StudLastName
FROM
[SchoolSchedulingExample].[dbo].Students stu
LEFT JOIN
(
SELECT stu.StudentID innerStuID FROM
[SchoolSchedulingExample].[dbo].Students stu
INNER JOIN
[SchoolSchedulingExample].[dbo].Student_Schedules stu_sc
ON stu.StudentID = stu_sc.StudentID
WHERE stu_sc.ClassStatus = 1
) innerStu
ON stu.StudentID = innerStu.innerStuID
WHERE innerStu.innerStuID IS NULL;

--19./Display all faculty and the classes they are scheduled to teach
SELECT 
st.StaffID,
st.StfFirstName,
st.StfLastname,
inner_cl.ClassID
FROM [SchoolSchedulingExample].[dbo].Staff st
LEFT JOIN
(
SELECT 
fal_cl.StaffID, 
fal_cl.ClassID 
FROM
[SchoolSchedulingExample].[dbo].Classes cl
INNER JOIN
[SchoolSchedulingExample].[dbo].Faculty_Classes fal_cl
ON cl.ClassID = fal_cl.ClassID
) inner_cl
ON st.StaffID = inner_cl.StaffID
ORDER BY st.StaffID;

--20./Display matches with no game data.
SELECT 
tm.MatchID,
tm.TourneyID,
tm.Lanes,
tm.OddLaneTeamID,
tm.EvenLaneTeamID
FROM [BowlingLeagueExample].[dbo].Tourney_Matches tm
LEFT JOIN
[BowlingLeagueExample].[dbo].Match_Games mg
ON tm.MatchID = mg.MatchID
WHERE mg.GameNumber IS NULL;

--21./Display all tournaments and any matches that have been played.
SELECT 
tou.TourneyID,
tou.TourneyLocation, 
tou.TourneyDate,
inner_tm.MatchID
FROM
[BowlingLeagueExample].[dbo].Tournaments tou
LEFT JOIN 
(
SELECT tou_m.TourneyID, mg.MatchID FROM
[BowlingLeagueExample].[dbo].Match_Games mg 
INNER JOIN
[BowlingLeagueExample].[dbo].Tourney_Matches tou_m
ON mg.MatchID = tou_m.MatchID) inner_tm
ON tou.TourneyID = inner_tm.TourneyID;

--22./Display missing types of recipes.
SELECT rc.RecipeClassID, rc.RecipeClassDescription
FROM 
[RecipesExample].[dbo].Recipe_Classes rc
LEFT JOIN
[RecipesExample].[dbo].Recipes r
ON rc.RecipeClassID = r.RecipeClassID
WHERE r.RecipeID IS NULL;

--23./List the salad, soup, and main course categories and any recipes.
SELECT 
rc.RecipeClassID,
rc.RecipeClassDescription,
r.RecipeID,
r.RecipeTitle
FROM 
[RecipesExample].[dbo].Recipe_Classes rc
LEFT JOIN
[RecipesExample].[dbo].Recipes r
ON rc.RecipeClassID = r.RecipeClassID
WHERE rc.RecipeClassDescription IN ('Main Course', 'Salad', 'Soup');



