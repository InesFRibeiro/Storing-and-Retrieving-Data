# Storing and Retrieving Data Project 2021-2022
## Build a database for a business  
   
**MSc:** Data Science and Advanced Analytics, NOVA IMS   
**Grade:** 18.5 out of 20  
   
### Description 
In this project we developed a relational database for a fictitious car stand.    

We had to design and create an ERD in MySQL workbench and consider the three normal forms when designing the database model.   
The database project had to have at least two triggers: one for updates and another one that inserts a row in a “log” table. However we created 3 triggers:   
 - The first trigger deleted a row from a table (Cars_for_sale) after a row being inserted on another table (Cars_sold).
 - The second trigger updated payments values from the table Cars_sold after inserting rows into the table Customer_Payments.
 - The final trigger inserted into a log table information about the cars before deleting it from Cars_for_sale.   
    
       
After this, we created a physical relational database based on our ERD. Then, we inserted some data into the database.  
In the end we had to answer several queries:    
   1. List all the customer’s names, dates, and products or services used/booked/rented/bought by these customers in a range of two dates   
   2. List the best three customers/products/services/places   
   3. Get the average amount of sales/bookings/rents/deliveries for a period that involves 2 or more years   
   4. Get the total sales/bookings/rents/deliveries by geographical location (city/country).   
   5. List all the locations where products/services were sold, and the product has customer’s ratings    


<br>
   
**Group Members:**  
\- Beatriz Vizoso (https://github.com/Beatrizpdv)    
\- Inês Ribeiro (https://github.com/InesFRibeiro)   
\- José Dias (https://github.com/josedias97)   
\- Vasco Pombo ([https://github.com/vascopombo)
