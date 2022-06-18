use te;

/* 1) List all the customer’s names, dates, and products bought by these customers in a range of two dates*/
SELECT CONCAT(c.`first_name`, ' ', c.`last_name`) AS 'Customer Name', cs.`date_sold` AS 'Date Sold', 
	   CONCAT(l.`manufacturer_name`,'-', l.`model_name`) AS 'Car'
FROM Customers c, Cars_sold cs, log l
WHERE c.`customer_ID` = cs.`Customer_ID`
AND cs.`Car_sold_ID` = l.`Car_sold_ID`
AND cs.`date_sold` BETWEEN '2021-01-01' AND '2021-12-31';
/*
No index is used in tables cars_sold and log (NULL specified in the key column), this represents an issue.
In relation to that issue, there's also a large number of rows being processed in these tables.
The optimizer didn't find any possible key to be used to find rows from the table log.

Finally, this query is performing two full table scans (on cars_sold and log), which is the worst
join type and it indicates the lack of appropriate indexes on the tables.
It also has an eq_ref join type, which means that one row is read from the table customers for each 
combination of rows from the other tables. This is one of the best possible join types.
*/


/*2) List the best three customers (the best buyers) */
SELECT concat(c.`first_name`, ' ', c.`last_name`) as `Customer Name`, sum(cs.`agreed_price`) as `Amount Spent`
FROM Customers c, Cars_sold cs
WHERE c.`customer_ID`= cs.`Customer_ID`
GROUP BY `Customer Name`
ORDER BY `Amount Spent` DESC
LIMIT 3;
/*
No index is used in table customers.
In relation to that issue, there's also a large number of rows being processed in this table.

This query is also performing a full table scan, on customers, which also represents a efficiency issue.
*/


/*3) . Get the average amount of sales for a period that involves 2 or more years. 
This query only returns one record:*/
SELECT CONCAT(min(cs.`date_sold`),'  -  ', max(cs.`date_sold`)) AS 'Period of Sales', 
		SUM(cs.`agreed_price`) AS 'Total Sales (euros)',  
        round(SUM(cs.`agreed_price`)/(datediff(max(cs.`date_sold`), min(cs.`date_sold`))/365), 2) AS 'Yearly Average', 
        round(SUM(cs.`agreed_price`)/(datediff(max(cs.`date_sold`), min(cs.`date_sold`))/30), 2) AS 'Monthly Average'
FROM Cars_sold cs;
/*
The optimizer couldn't find any possible keys that can be used to find the rows from the table cars_sold.
No index is used in table cars_sold.
In relation to that issue, there's also a large number of rows being processed in this table.

This query is performing a full table scan, on Cars_sold.
*/

       
/* 4) Get the total sales by geographical location (city/country)*/
SELECT a.city AS City,  SUM(cs.agreed_price) AS 'Total Sales'
FROM Addresses a
JOIN Stands s ON s.Address_ID=a.Address_ID
JOIN Employees e ON e.Stand_ID= s.Stand_ID
JOIN Cars_sold cs ON cs.Employee_ID= e.Employee_ID
GROUP BY City;
/*
The optimizer was able to find possible keys in every table and was also able to find the optimal ones.
There was no need to process a lot of rows.

The index join type indicates that the entire index tree is scanned to find matching rows.
This is one of the worst join types.
*/

/* 5) List all the locations where products were sold, and the product has customer’s ratings. */
SELECT a.city AS Location, concat(l.manufacturer_name, ', ', l.model_name) AS Product, ROUND(AVG(cs.service_rating),2) AS Average_rating
FROM log l, Cars_sold cs, Addresses a, Stands s
WHERE l.Car_sold_ID = cs.Car_sold_ID
AND l.Stand_ID = s.Stand_ID
AND s.Address_ID = a.Address_ID
AND cs.service_rating IS NOT NULL
GROUP BY Location, Product
ORDER BY Location;
/*
The optimizer couldn't find any possible keys that can be used to find the rows from the table log.
No index is used in table log.
In relation to that issue, there's also a large number of rows being processed in the table log.
This query is performing a full table scan, on log.

As for the other tables, the optimizer was able to find possible keys in every table and was also 
able to find the optimal ones. There was no need to process a lot of rows.

The join types used in this query are index, eq_ref and ALL (all explained previously).
*/


/*
A simple fix to optimize the queries above is to add an index based on the WHERE clause.
*/