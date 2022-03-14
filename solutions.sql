-- 1. How many customers do we have? -> 122
SELECT COUNT(*) FROM customers;

-- 2. What is the customer number of Mary Young? -> 219
SELECT contactFirstName, contactLastName, customerNumber FROM customers
WHERE contactLastName = "Young" AND contactFirstName = "Mary";

-- 3. What is the customer number of the person living at Magazinweg 7, Frankfurt 60528? -> 247
SELECT customerNumber FROM customers
WHERE addressLine1 = "Magazinweg 7" OR addressLine2 = "Magazinweg 7";

-- 4. If you sort the employees on their last name, what is the email of the first employee? -> gbondur@classicmodelcars.com
SELECT email FROM employees ORDER BY lastName LIMIT 1;

-- 5. If you sort the employees on their last name, what is the email of the last employee? -> gvanauf@classicmodelcars.com
SELECT email FROM employees ORDER BY lastName DESC LIMIT 1;

-- 6. What is first the product code of all the products from the line 'Trucks and Buses', sorted first by productscale, then by productname. -> S12_4473
SELECT productCode FROM products
WHERE productLine = "Trucks and Buses"
ORDER BY productScale, productName;

-- 7. What is the email of the first employee, sorted on their last name that starts with a 't'? -> lthompson@classicmodelcars.com
SELECT email FROM employees
WHERE lastName LIKE 't%'
ORDER BY lastName ASC LIMIT 1;

-- 8. Which customer (give customer number) payed by check on 2004-01-19? -> 177
SELECT customerNumber FROM payments
WHERE paymentDate = '2004-01-19';

-- 9. How many customers do we have living in the state Nevada or New York? -> 7
SELECT COUNT(*) from customers
WHERE state = 'NV' OR state = 'NY';

-- 10. How many customers do we have living in the state Nevada or New York or outside the united states? -> 93
SELECT COUNT(*) from customers
WHERE (state = 'NV' OR state = 'NY') OR country NOT IN ('USA');

-- 11. How many customers do we have with the following conditions (only 1 query needed): - Living in the state Nevada or New York OR - Living outside the USA or the customers with a credit limit above 1000 dollar? -> 70
SELECT COUNT(*) FROM customers
WHERE (state = 'NV' OR state = 'NY') OR (country NOT IN ('USA') AND creditLimit >= 1000.00);

-- 12. How many customers don't have an assigned sales representative? -> 22
SELECT COUNT(*) FROM customers
WHERE salesRepEmployeeNumber IS NULL;

-- 13. How many orders have a comment? -> 80
SELECT COUNT(*) FROM orders
WHERE comments IS NOT NULL;

-- 14. How many orders do we have where the comment mentions the word "caution"? -> 4
SELECT COUNT(*) FROM orders
WHERE comments LIKE "%caution%";

-- 15. What is the average credit limit of our customers from the USA? (rounded) -> 78103
SELECT ROUND(AVG(creditLimit)) FROM customers
WHERE country = 'USA';

-- 16. What is the most common last name from our customers? -> Young
SELECT contactLastName, COUNT(contactLastName) AS nr_of_names FROM customers
GROUP BY contactLastName 
ORDER BY nr_of_names DESC;

-- 17. What are valid statuses of the orders? -> Shipped, Resolved, Cancelled, On Hold, Disputed, In Process
SELECT DISTINCT(status) FROM orders;

-- 18. In which countries don't we have any customers? -> China, Greece, South Korea
SELECT DISTINCT(country) FROM customers
ORDER BY country ASC;

-- 19. How many orders where never shipped? -> 14
SELECT COUNT(*) AS never_shipped_orders FROM orders
WHERE shippedDate IS NULL;

-- 20. How many customers does Steve Patterson have with a credit limit above 100 000 EUR? -> 3
SELECT employeeNumber, customerName, creditLimit FROM employees
LEFT JOIN customers ON customers.salesRepEmployeeNumber = employees.employeeNumber
WHERE firstName = 'Steve' AND lastName = 'Patterson' AND creditLimit > 100000;

-- 21. How many orders have been shipped to our customers? -> 303
SELECT COUNT(status) AS shipped_orders FROM orders
WHERE status = 'Shipped';

-- 22. On average, how many products do we have in each product line? -> 16
SELECT ROUND(COUNT(*) / COUNT(DISTINCT(productLine))) AS average_products_in_each_prodLine FROM products;

-- 23. How many products are low in stock? (below 100 pieces) -> 2
SELECT productName, quantityInStock FROM products
WHERE quantityInStock < 100;

-- 24. How many products have more the 100 pieces in stock, but are below 500 pieces. -> 3
SELECT productName, quantityInStock FROM products
WHERE quantityInStock > 100 AND quantityInStock < 500;

-- 25. How many orders did we ship between and including June 2004 & September 2004 -> 42
SELECT orderNumber, shippedDate, status, COUNT(orderNumber) AS orders_shipped FROM orders
WHERE status = 'Shipped' AND (shippedDate > '2004-06-01' AND shippedDate < '2004-09-31');

-- 26. How many customers share the same last name as an employee of ours? -> 9
SELECT contactLastName, lastName FROM customers, employees
WHERE contactLastName = lastName;

-- 27. Give the product code for the most expensive product for the consumer? -> S10_1949
SELECT productCode, MSRP FROM products
ORDER BY MSRP DESC LIMIT 1;

-- 28. What product (product code) offers us the largest profit margin (difference between buyPrice & MSRP). -> S10_1949
SELECT productCode, MSRP - buyPrice AS margin FROM products
ORDER BY margin DESC LIMIT 1;

-- 29. How much profit (rounded) can the product with the largest profit margin (difference between buyPrice & MSRP) bring us. -> 116
SELECT productCode, ROUND(MSRP - buyPrice) AS margin FROM products
ORDER BY margin DESC LIMIT 1;

-- 30. Given the product number of the products (separated with spaces) that have never been sold? -> S18_3233
SELECT productCode FROM products
WHERE productCode NOT IN (SELECT productCode FROM orderdetails);

-- 31. How many products give us a profit margin below 30 dollar? -> 23
SELECT COUNT(*) FROM products
WHERE MSRP - buyPrice < 30;

-- 32. What is the product code of our most popular product (in number purchased)? -> S18_3232
SELECT productCode, SUM(quantityOrdered) AS total_orders FROM orderdetails
GROUP BY productCode
ORDER BY total_orders DESC;

-- 33. How many of our popular product did we effectively ship? -> 1720
SELECT SUM(quantityOrdered) AS quantity_ordered, productCode, status FROM orderdetails
LEFT JOIN orders
ON orderdetails.orderNumber = orders.orderNumber
WHERE productCode = 'S18_3232'
GROUP BY status;

-- 34. Which check number paid for order 10210. Tip: Pay close attention to the date fields on both tables to solve this. -> CI381435
SELECT checkNumber FROM orders
LEFT JOIN payments
ON orders.customerNumber = payments.customerNumber
WHERE orderNumber = 10210 AND paymentDate <= shippedDate;

-- 35. Which order was paid by check CP804873? -> 10330
SELECT orderNumber FROM orders
LEFT JOIN payments
ON orders.customerNumber = payments.customerNumber
WHERE checkNumber = 'CP804873' AND paymentDate <= shippedDate;

-- 36. How many payments do we have above 5000 EUR and with a check number with a 'D' somewhere in the check number, ending the check number with the digit 9? -> 3
SELECT COUNT(*) AS nr_of_payments FROM payments
WHERE amount > 5000 AND checkNumber LIKE '%D%9';

-- 37. How many products do we have in product scale 1:18 or 1:24 that are either trains and have a sell price above 100 EUR, or classic cars and a price between 50 and 80, or trucks and buses with a price below 100 EUR? -> 8
SELECT COUNT(*) FROM products
WHERE (productScale = '1:18' OR productScale = '1:24') AND
((productLine = 'Trains' AND MSRP > 100) OR 
(productLine = 'Classic Cars' AND MSRP BETWEEN 50 AND 80) OR 
(productLine = 'Trucks and Buses' AND MSRP < 100));

-- 38. In which country do we have the most customers that we do not have an office in? -> Germany
SELECT customers.country, COUNT(customers.country) AS customers_from_country FROM customers, offices
WHERE customers.country NOT IN (SELECT DISTINCT country FROM offices)
GROUP BY customers.country
ORDER BY customers_from_country DESC;

SELECT country, COUNT(country) AS offices_in_country FROM offices
GROUP BY country
ORDER BY offices_in_country;
/*LEFT JOIN offices
ON offices.country = customers.country*/

-- 39. What city has our biggest office in terms of employees? -> San Francisco
SELECT city, COUNT(*) AS nr_of_employees FROM offices
LEFT JOIN employees
ON offices.officeCode = employees.officeCode
GROUP BY city
ORDER BY nr_of_employees DESC LIMIT 1;

-- 40. How many employees does our largest office have, including leadership? -> 6
SELECT city, COUNT(*) AS nr_of_employees FROM offices
LEFT JOIN employees
ON offices.officeCode = employees.officeCode
GROUP BY city
ORDER BY nr_of_employees DESC;

-- 41. How many employees do we have on average per country (rounded)? -> 5
SELECT ROUND(COUNT(*) / COUNT(DISTINCT(country))) AS average_employees_in_each_country FROM offices
LEFT JOIN employees
ON offices.officeCode = employees.officeCode;

-- 42. What is the total value of all shipped & resolved sales ever combined? -> 8999331
SELECT ROUND(SUM(quantityOrdered * priceEach)) FROM orderdetails
LEFT JOIN orders
ON orderdetails.orderNumber = orders.orderNumber
WHERE (status = "Shipped" OR status = "Resolved");

-- 43. What is the total value of all shipped & resolved sales in the year 2005 combined? (based on shipping date) -> 1427945
SELECT ROUND(SUM(quantityOrdered * priceEach)) FROM orderdetails
LEFT JOIN orders
ON orderdetails.orderNumber = orders.orderNumber
WHERE (status = "Shipped" OR status = "Resolved") AND (shippedDate BETWEEN '2005-01-01' AND '2005-12-31');

-- 44. What was our most profitable year ever (based on shipping date), considering all shipped & resolved orders? -> 2004
SELECT shippedDate, SUM(amount) AS total_amount_payment FROM orders
LEFT JOIN payments 
ON orders.customerNumber = payments.customerNumber
WHERE (status = 'Shipped' OR status = 'Resolved')
GROUP BY YEAR(shippedDate)
ORDER BY total_amount_payment DESC LIMIT 1;

-- 45. How much total value did we make on in our most profitable year ever (based on shipping date), considering all shipped & resolved orders?  -> 4321168
SELECT ROUND(SUM(quantityOrdered * priceEach)) FROM orderdetails
LEFT JOIN orders
ON orderdetails.orderNumber = orders.orderNumber
WHERE (status = "Shipped" OR status = "Resolved") AND (shippedDate BETWEEN '2004-01-01' AND '2004-12-31');

-- 46. What is the name of our biggest customer in the USA of terms of revenue? -> Mini Gifts Distributors Ltd.
SELECT customerName, SUM(amount) AS total_revenue FROM customers
LEFT JOIN payments
ON payments.customerNumber = customers.customerNumber
WHERE country = 'USA'
GROUP BY customerName
ORDER BY total_revenue DESC LIMIT 1;

-- 47. How much has our largest customer inside the USA ordered with us (total value)? -> 591827
SELECT customerName, ROUND(SUM(priceEach * quantityOrdered)) AS total_value FROM orderdetails
LEFT JOIN orders
ON orders.orderNumber = orderdetails.orderNumber
LEFT JOIN customers
ON customers.customerNumber = orders.customerNumber
WHERE customerName = 'Mini Gifts Distributors Ltd.';

-- 48. How many customers do we have that never ordered anything? -> 24
SELECT COUNT(customerNumber) AS customers_with_no_order FROM customers
WHERE customerNumber NOT IN (SELECT customerNumber FROM orders);

-- 49. What is the last name of our best employee in terms of revenue? -> Hernandez
SELECT employeeNumber, lastName, ROUND(SUM(amount)) AS total_revenue FROM employees
LEFT JOIN customers
ON customers.salesRepEmployeeNumber = employeeNumber
LEFT JOIN payments
ON payments.customerNumber = customers.customerNumber
GROUP BY employeeNumber
ORDER BY total_revenue DESC LIMIT 1;

-- 50. What is the office name of the least profitable office in the year 2004? -> officeCode: 5
SELECT offices.officeCode, ROUND(SUM(amount)) AS total_revenue FROM offices
LEFT JOIN employees
ON employees.officeCode = offices.officeCode
LEFT JOIN customers
ON customers.salesRepEmployeeNumber = employeeNumber
LEFT JOIN payments
ON payments.customerNumber = customers.customerNumber
LEFT JOIN orders
ON orders.customerNumber = customers.customerNumber
WHERE (shippedDate BETWEEN '2004-01-01' AND '2004-12-31')
GROUP BY offices.officeCode
ORDER BY total_revenue LIMIT 1;