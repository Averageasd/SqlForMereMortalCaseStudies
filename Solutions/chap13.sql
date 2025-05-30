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
