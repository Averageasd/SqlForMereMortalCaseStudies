--1./Show me all the orders shipped on October 3, 2012, and each order’s related
 --customer last name.
SELECT 
ord.OrderNumber,
(
SELECT 
CONCAT(c.CustFirstName,' ',c.CustLastName)
FROM 
[SalesOrdersExample].[dbo].Customers c 
WHERE c.CustomerID = ord.CustomerID
) AS relatedCustName
FROM [SalesOrdersExample].[dbo].Orders ord
WHERE ord.ShipDate = '10/03/2012';

--2./List all the customer names and a count of the orders they placed.
SELECT 
c.CustFirstName,
c.CustLastName,
c.CustomerID,
(
SELECT COUNT(DISTINCT ord.OrderNumber) FROM [SalesOrdersExample].[dbo].Orders
ord WHERE ord.CustomerID = c.CustomerID
) OrdCount
FROM
[SalesOrdersExample].[dbo].Customers c

--3./Show me a list of customers and the last date on which they placed an order.
SELECT 
c.CustFirstName,
c.CustLastName,
c.CustomerID,
(SELECT MAX(ord.OrderDate) FROM [SalesOrdersExample].[dbo].Orders 
	ord WHERE ord.CustomerID = c.CustomerID
) lastOrdDate
FROM
[SalesOrdersExample].[dbo].Customers c

--4./List all my recipes that have a seafood ingredient
 SELECT RecipeTitle
 FROM [RecipesExample].[dbo].Recipes
 WHERE Recipes.RecipeID IN
   (SELECT RecipeID
   FROM [RecipesExample].[dbo].Recipe_Ingredients
   WHERE Recipe_Ingredients.IngredientID IN
      (SELECT IngredientID
      FROM [RecipesExample].[dbo].Ingredients
      INNER JOIN [RecipesExample].[dbo].Ingredient_Classes
      ON Ingredients.IngredientClassID =
         Ingredient_Classes.IngredientClassID
     WHERE
     Ingredient_Classes.IngredientClassDescription
        = 'Seafood'))

--5./Show me the recipes that have beef or garlic.
SELECT 
r.RecipeTitle
FROM 
[RecipesExample].[dbo].Recipes r
WHERE r.RecipeID IN
(
	SELECT 
	ri.RecipeID
	FROM 
	[RecipesExample].[dbo].Recipe_Ingredients ri
	INNER JOIN
	[RecipesExample].[dbo].Ingredients i
	ON ri.IngredientID = i.IngredientID
	WHERE ri.IngredientID = i.IngredientID
	AND i.IngredientName IN('Beef','Garlic')
)

--6./Find all accessories that are priced greater than any clothing item.
WITH NonClothingItems 
AS
(
SELECT 
pr.ProductName, 
cat.CategoryDescription,
pr.RetailPrice
FROM 
[SalesOrdersExample].[dbo].Products pr
INNER JOIN
[SalesOrdersExample].[dbo].Categories cat
ON pr.CategoryID = cat.CategoryID
WHERE CategoryDescription!='Clothing'
), ClothingItems AS
(
SELECT 
pr.ProductName, 
cat.CategoryDescription,
pr.RetailPrice
FROM 
[SalesOrdersExample].[dbo].Products pr
INNER JOIN
[SalesOrdersExample].[dbo].Categories cat
ON pr.CategoryID = cat.CategoryID
WHERE CategoryDescription='Clothing'
)

SELECT * FROM 
NonClothingItems 
WHERE
NonClothingItems.RetailPrice >
ALL(
SELECT RetailPrice FROM
ClothingItems);

--7./Find all the customers who ordered a bicycle.
SELECT * 
FROM
[SalesOrdersExample].[dbo].Customers c;

SELECT * FROM
[SalesOrdersExample].[dbo].Order_Details ord_de;

SELECT * FROM
[SalesOrdersExample].[dbo].Orders ord;

SELECT * FROM
[SalesOrdersExample].[dbo].Products prod;

WITH Bike_Prod
AS
(
	SELECT 
	prod.ProductName,
	prod.ProductNumber
	FROM
	[SalesOrdersExample].[dbo].Products prod
	INNER JOIN
	[SalesOrdersExample].[dbo].Categories cat
	ON prod.CategoryID = cat.CategoryID
	WHERE cat.CategoryDescription = 'Bikes'
),
Ord_Cus
AS
(
	SELECT 
	ord.CustomerID,
	ord.OrderNumber,
	ord_de.ProductNumber
	FROM 
	[SalesOrdersExample].[dbo].Orders ord
	INNER JOIN
	[SalesOrdersExample].[dbo].Order_Details ord_de
	ON ord.OrderNumber = ord_de.OrderNumber
)

SELECT 
c.CustomerID,
c.CustFirstName,
c.CustLastName
FROM
[SalesOrdersExample].[dbo].Customers c
WHERE 
EXISTS 
(
	SELECT 
	Ord_Cus.CustomerID
	FROM 
	Ord_Cus 
	WHERE 
	EXISTS
	(
		SELECT TOP 1 bp.ProductNumber
		FROM
		Bike_Prod bp
		WHERE bp.ProductNumber = Ord_Cus.ProductNumber
	) AND Ord_Cus.CustomerID = c.CustomerID
)

--8./Show me all entertainers and the count of each entertainer’s engagements.
SELECT 
 ent.EntertainerID,
 ent.EntStageName,
 (
	SELECT 
	COUNT(eng.EntertainerID)
	FROM 
	[EntertainmentAgencyExample].[dbo].Engagements eng
	WHERE ent.EntertainerID = eng.EntertainerID
 ) AS engagement_count
 FROM
[EntertainmentAgencyExample].[dbo].Entertainers ent;

--9./List all the bowlers who have a raw score that’s less than all of the other
--bowlers on the same team.
SELECT 
DISTINCT 
bl.BowlerID,
bl.BowlerFirstName,
bl.BowlerLastName,
bls.RawScore
FROM 
[BowlingLeagueExample].[dbo].Bowlers bl
INNER JOIN
[BowlingLeagueExample].[dbo].Bowler_Scores bls
ON bl.BowlerID = bls.BowlerID
WHERE bls.RawScore < ALL (
	SELECT 
	inner_bls.RawScore
	FROM
	[BowlingLeagueExample].[dbo].Bowlers inner_bl
	INNER JOIN 
	[BowlingLeagueExample].[dbo].Bowler_Scores inner_bls
	ON inner_bl.BowlerID = inner_bls.BowlerID
	WHERE inner_bl.TeamID = bl.TeamID
	AND inner_bl.BowlerID != bl.BowlerID
);


SELECT 
*
FROM 
[BowlingLeagueExample].[dbo].Bowler_Scores;

