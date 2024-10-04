/*****************************************************************************************************************
NAME:    EC_IT143_W3.4_AB
PURPOSE:  Eight AdventureWorks questions and answers SQL script

MODIFICATION LOG:
Ver      Date        Author        Description
-----   ----------   -----------   -------------------------------------------------------------------------------
1.0     05/23/2022   JJAUSSI       1. Built this script for EC IT440


RUNTIME: 
00m 01s

NOTES: 
This script is about the eight questions answered in my week three assignment.
 
******************************************************************************************************************/

-- Q1: What should go here?
-- A1: Question goes on the previous line, intoduction to the answer goes on this line...

SELECT GETDATE() AS my_date;

--Q1. Business User question—Marginal complexity: How many products do we currently have available according to the Production.Product table? 

-- Selecting specific columns from the production.product table
SELECT productid, productnumber, name as productName
-- Specifying the table from the table name.
FROM production.product
-- Filtering the result is not NULL and productline is 'T'
WHERE sellstartdate IS NOT NULL
AND production.product.productline= 'T'
-- Ordering the result set by the 'name' column in ascending order
ORDER BY name;

--Q2.Business user Question. (marginal complexity): Display the number of records found in the table named person.
-- Selecting specific columns from the production.product table
SELECT * FROM Person.Person

--Q3. Business User question—Moderate complexity: Base on the last year sales performance with corresponding products, we need to give award to encourage others. 
--Can generate the top five performed staff for KPI?
--What are the most popular products among customers? This is from me

-- Selecting specific columns with the top 5
SELECT TOP 5
    BusinessEntityID,
    NationalIDNumber,
    BirthDate,
    SalariedFlag,
--using SalariedFlag to arrange the ranking in decending order
    RANK() OVER (ORDER BY SalariedFlag DESC) as ranking
  FROM HumanResources.Employee


--Q4. Business User question—Moderate complexity:How many employees in the Human resource department earn more than 50k as salary and from which exact department?Precious

-- Retrieving distinct employee names along with salary statistics per department
SELECT DISTINCT Name  
       , MAX(Rate) OVER (PARTITION BY edh.DepartmentID) AS Salary  
       , COUNT(edh.BusinessEntityID) OVER (PARTITION BY edh.DepartmentID) AS EmployeesPerDept
-- From the EmployeePayHistory table as eph
FROM AdventureWorks2019.HumanResources.EmployeePayHistory AS eph
-- Joining EmployeeDepartmentHistory table as edh
JOIN AdventureWorks2019.HumanResources.EmployeeDepartmentHistory AS edh  
     ON eph.BusinessEntityID = edh.BusinessEntityID  
-- Joining Department table as d
JOIN AdventureWorks2019.HumanResources.Department AS d  
ON d.DepartmentID = edh.DepartmentID
-- Filtering records where employee's department history has not ended
WHERE edh.EndDate IS NULL
-- Sorting the result by employee name
ORDER BY Name 

--Q5.Business User question—Increased complexity: Over the last year, we have increased the salary of some sales employees and others have not benefitted. 
--Amongst those that their salary have not been increased, please find me the best 5 employees based on their sales record. Precious

-- Selecting specific columns from the salespersonquotahistory table
SELECT TOP 5
    -- Extracting the year part from the quotadate and aliasing it as Year
    DATENAME(YEAR, QuotaDate) AS Year, 

    -- Extracting the quarter part from the quotadate and aliasing it as Quarter
    DATENAME(QUARTER, quotadate) AS Quarter, 

    -- Selecting the SalesQuota column
    SalesQuota AS SalesQuota,  

    -- Using the LEAD window function to get the next SalesQuota, defaulting to 0 if not available
    LEAD(SalesQuota, 1, 0) OVER (
        -- Ordering the data by year and quarter
        ORDER BY DATENAME(YEAR, quotadate), DATENAME(QUARTER, quotadate)
    ) AS NextQuota,  

    -- Calculating the difference between SalesQuota and the next SalesQuota
    SalesQuota - LEAD(SalesQuota, 1, 0) OVER (
        -- Ordering the data by year and quarter
        ORDER BY DATENAME(YEAR, quotadate), DATENAME(QUARTER, quotadate)
    ) AS Diff  

-- Filtering data for a specific salesperson identified by businessentityid
FROM 
    sales.salespersonquotahistory  

-- Filtering records for the salesperson with ID 277 and the years 2012 and 2013
WHERE 
    businessentityid = 277 
    AND DATENAME(YEAR, quotadate) IN (2012, 2013)  

-- Ordering the result set by year and quarter
ORDER BY 
    DATENAME(YEAR, quotadate), DATENAME(QUARTER, quotadate)

--Q6 Business User question—Increased complexity: We need to appreciate some of our customer because one good turn deservers another. 
--A leverage needs to be given for constant patronage of our customers. This is from me Can you review our top 100 best performing product among customers for proper follow up and discount? 

-- Selecting specific columns from the table
SELECT TOP 100
    Product.Name AS ProductName,
    SUM(SalesOrderDetail.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail AS SalesOrderDetail
--inner join the two table together
INNER JOIN Production.Product AS Product
    ON SalesOrderDetail.ProductID = Product.ProductID
--Group by product.name
GROUP BY Product.Name
--the table TotalQuantitysold is display in descending order
ORDER BY TotalQuantitySold DESC;


--Q7. Metadata question—Can you list all primary keys defined in the AdventureWorks database? Precious
SELECT * FROM SYS.objects WHERE type_desc = 'PRIMARY_KEY_CONSTRAINT'

--Q8 Metadata question— Can you isolate every table with BusinessEntityID columns and arrange them by modified date?
SELECT BusinessEntityID, ModifiedDate FROM AdventureWorks2019.HumanResources.Employee ORDER BY ModifiedDate