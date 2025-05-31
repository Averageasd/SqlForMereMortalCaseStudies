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
SELECT 
rec_cl.RecipeClassID,
rec_cl.RecipeClassDescription,
COUNT(rec_ing.MeasureAmountID) tea_spoon_count,
SUM(rec_ing.Amount) sum_teaspoon_salt
FROM [RecipesExample].[dbo].Recipe_Classes rec_cl
INNER JOIN
[RecipesExample].[dbo].Recipes r
ON rec_cl.RecipeClassID = r.RecipeClassID
INNER JOIN
[RecipesExample].[dbo].Recipe_Ingredients rec_ing
ON r.RecipeID = rec_ing.RecipeID
WHERE rec_ing.MeasureAmountID = 3 AND rec_ing.IngredientID = 11
GROUP BY rec_cl.RecipeClassID, rec_cl.RecipeClassDescription
HAVING COUNT(rec_ing.MeasureAmountID) > 3;

--For what class of recipe do I have two or more recipes?
SELECT 
rec_cl.RecipeClassID,
rec_cl.RecipeClassDescription,
COUNT(rec.RecipeID) recipe_count
FROM [RecipesExample].[dbo].Recipe_Classes rec_cl
INNER JOIN
[RecipesExample].[dbo].Recipes rec
ON rec_cl.RecipeClassID = rec.RecipeClassID
GROUP BY rec_cl.RecipeClassID, rec_cl.RecipeClassDescription
HAVING COUNT(rec.RecipeID) >=2;
