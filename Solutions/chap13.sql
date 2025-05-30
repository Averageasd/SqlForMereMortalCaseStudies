--List for each customer and order date the customer’s full name and the total
--cost of items ordered that is greater than $1,000.
SELECT  
c.CustomerID, 
c.CustFirstName,
c.CustLastName,
ord.OrderDate,
SUM(ord_de.QuotedPrice * ord_de.QuantityOrdered) AS total
FROM [SalesOrdersExample].[dbo].Customers c
INNER JOIN
[SalesOrdersExample].[dbo].Orders ord
ON c.CustomerID = ord.CustomerID
INNER JOIN
[SalesOrdersExample].[dbo].Order_Details ord_de
ON ord.OrderNumber = ord_de.OrderNumber 
GROUP BY c.CustomerID, c.CustFirstName, c.CustLastName, ord.OrderDate
HAVING SUM(ord_de.QuotedPrice * ord_de.QuantityOrdered)>1000
ORDER BY c.CustFirstName;

--Which agents booked more than $3,000 worth of business in December
--2012?

SELECT 
ag.AgentID, 
SUM(eng.ContractPrice) businessWorth
FROM [EntertainmentAgencyExample].[dbo].Agents ag
INNER JOIN
[EntertainmentAgencyExample].[dbo].Engagements eng
ON ag.AgentID = eng.AgentID
WHERE eng.StartDate BETWEEN '2012-12-01' AND '2012-12-31'
GROUP BY ag.AgentID
HAVING SUM(eng.ContractPrice) > 3000;

--Show me each vendor and the average by vendor of the number of days to
--deliver products that is greater than the average delivery days for all
--vendors
WITH EachVendorAvgDeliveryDay 
AS
(
	SELECT
	AVG(vend.DaysToDeliver) avgDeliveryDay
	FROM 
	[SalesOrdersExample].[dbo].Product_Vendors vend
)
SELECT
vend.VendorID,
AVG(vend.DaysToDeliver) avgDeliveryDay
FROM 
[SalesOrdersExample].[dbo].Product_Vendors vend
GROUP BY vend.VendorID
HAVING AVG(vend.DaysToDeliver) > ALL(SELECT avgDeliveryDay FROM EachVendorAvgDeliveryDay);

--How many orders are for only one product?

SELECT * FROM [SalesOrdersExample].[dbo].Orders;

WITH Order_with_single_item 
AS(
	SELECT 
	ord_de.OrderNumber,
	COUNT (ord_de.ProductNumber) prodCount
	FROM [SalesOrdersExample].[dbo].Order_Details ord_de
	GROUP BY ord_de.OrderNumber 
	HAVING COUNT (ord_de.ProductNumber) = 1
)

SELECT COUNT(Order_with_single_item.OrderNumber) FROM Order_with_single_item;

--List each staf member and the count of classes each is scheduled to teach for
--those staf members who teach fewer than three classes.

SELECT 
st.StaffID,
COUNT(st_cl.StaffID) AS numClassesTaught
FROM [SchoolSchedulingExample].[dbo].Staff st
LEFT JOIN
[SchoolSchedulingExample].[dbo].Faculty_Classes st_cl
ON st.StaffID = st_cl.StaffID 
GROUP BY st.StaffID
HAVING COUNT(st_cl.StaffID) < 3;

--Count the classes taught by all stafj members.
SELECT 
st.StfFirstName,
st.StfLastname,
COUNT(st_cl.StaffID) AS numClassesTaught
FROM [SchoolSchedulingExample].[dbo].Staff st
LEFT JOIN
[SchoolSchedulingExample].[dbo].Faculty_Classes st_cl
ON st.StaffID = st_cl.StaffID 
GROUP BY st.StaffID, st.StfFirstName, st.StfLastname

--Sum the amount of salt by recipe class, and display those recipe classes that
--require more than 3 teaspoons.
SELECT * FROM [RecipesExample].[dbo].Ingredients ing ORDER BY ing.IngredientName;
SELECT 
reci_cl.RecipeClassID, 
COUNT(ing.MeasureAmountID) tea_spoon_count,
(
	SELECT	COUNT(*) FROM [RecipesExample].[dbo].Ingredients inner_ing WHERE inner_ing.IngredientName = 'Salt' AND inner_ing.IngredientClassID = reci_cl.RecipeClassID
) AS count_salt,
reci_cl.RecipeClassDescription
FROM [RecipesExample].[dbo].Recipe_Classes reci_cl
INNER JOIN 
[RecipesExample].[dbo].Ingredients ing
ON reci_cl.RecipeClassID = ing.IngredientClassID 
WHERE MeasureAmountID = 3
GROUP BY reci_cl.RecipeClassID, reci_cl.RecipeClassDescription
HAVING COUNT(ing.MeasureAmountID) > 3;

SELECT * FROM[RecipesExample].[dbo].Recipe_Ingredients;
SELECT * FROM [RecipesExample].[dbo].CH14_Recipe_Classes_Lots_Of_Salt;