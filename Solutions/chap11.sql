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
*
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
	AND i.IngredientName IN ('Beef','Garlic')
)