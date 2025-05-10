SELECT * FROM [SalesOrdersExample].[dbo].[Employees];

SELECT 
VendCity vend_city, 
VendName vend_name 
FROM [SalesOrdersExample].[dbo].[Vendors]
ORDER BY vend_city;

/**
Give me the names and phone numbers of all our agents, 
and list them in last
name/first name order.
**/
SELECT 
AgtLastName,
AgtFirstName,
AgtPhoneNumber
FROM [EntertainmentAgencyExample].[dbo].[Agents]
ORDER BY AgtLastName, AgtFirstName;

SELECT * FROM [EntertainmentAgencyExample].[dbo].[Engagements];

SELECT 
EngagementNumber,
StartDate
FROM [EntertainmentAgencyExample].[dbo].[Engagements]
ORDER BY StartDate DESC, EngagementNumber ASC;