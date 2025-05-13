Select rc.RecipeClassID rc_RecipeClassID FROM
[RecipesExample].[dbo].Recipe_Classes rc
UNION
SELECT r.RecipeClassID  FROM
[RecipesExample].[dbo].Recipes r
