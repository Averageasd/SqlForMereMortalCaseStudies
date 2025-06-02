--Find the recipes that have neither beef, nor onions, nor carrots.
--Find the recipes that have neither beef, nor onions, nor carrots.
SELECT * FROM [RecipesExample].[dbo].Ingredients;
SELECT * FROM [RecipesExample].[dbo].Recipes;
SELECT * FROM [RecipesExample].[dbo].Recipe_Ingredients;
WITH recipesBeefOnionCarrot
AS
(
	SELECT 
	rec.RecipeID,
	ingre.IngredientName
	FROM 
	[RecipesExample].[dbo].Recipes rec
	INNER JOIN 
	[RecipesExample].[dbo].Recipe_Ingredients reci_ingre
	ON rec.RecipeID = reci_ingre.RecipeID
	INNER JOIN
	[RecipesExample].[dbo].Ingredients ingre
	ON reci_ingre.IngredientID = ingre.IngredientID
	WHERE 
	ingre.IngredientName 
	IN('Onion', 'Beef', 'Carrot') 
),
recipesWithButter
AS
(
	SELECT 
	rec.RecipeID,
	rec.RecipeTitle,
	ingre.IngredientName
	FROM 
	[RecipesExample].[dbo].Recipes rec
	INNER JOIN 
	[RecipesExample].[dbo].Recipe_Ingredients reci_ingre
	ON rec.RecipeID = reci_ingre.RecipeID
	INNER JOIN
	[RecipesExample].[dbo].Ingredients ingre
	ON reci_ingre.IngredientID = ingre.IngredientID
	WHERE 
	ingre.IngredientName = 'butter'
)
SELECT * FROM
recipesWithButter
LEFT JOIN 
recipesBeefOnionCarrot 
ON recipesWithButter.RecipeID = recipesBeefOnionCarrot.RecipeID
WHERE 
recipesBeefOnionCarrot.RecipeID IS NULL;

--Find all the customers who ordered a bicycle and also ordered a helmet.
WITH Bike_Order_Cust
AS
(
	SELECT 
	cust.CustomerID
	FROM 
	[SalesOrdersExample].[dbo].Customers cust
	INNER JOIN
	[SalesOrdersExample].[dbo].Orders ord 
	ON cust.CustomerID = ord.CustomerID
	INNER JOIN
	[SalesOrdersExample].[dbo].Order_Details ord_de
	ON ord.OrderNumber = ord_de.OrderNumber
	INNER JOIN
	[SalesOrdersExample].[dbo].Products prod
	ON ord_de.ProductNumber = prod.ProductNumber
	WHERE 
	prod.ProductName 
	LIKE '%Bike'
),
Helmet_Order_Cust
AS
(
SELECT 
	cust.CustomerID
	FROM 
	[SalesOrdersExample].[dbo].Customers cust
	INNER JOIN
	[SalesOrdersExample].[dbo].Orders ord 
	ON cust.CustomerID = ord.CustomerID
	INNER JOIN
	[SalesOrdersExample].[dbo].Order_Details ord_de
	ON ord.OrderNumber = ord_de.OrderNumber
	INNER JOIN
	[SalesOrdersExample].[dbo].Products prod
	ON ord_de.ProductNumber = prod.ProductNumber
	WHERE 
	prod.ProductName 
	LIKE '%Helmet'
)
SELECT 
*
FROM 
[SalesOrdersExample].[dbo].Customers c
WHERE 
c.CustomerID IN 
(SELECT * FROM Bike_Order_Cust)
AND 
c.CustomerID IN 
(SELECT * FROM Helmet_Order_Cust)



