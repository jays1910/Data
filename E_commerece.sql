create table customers1 (
 customer_id int not null primary key,
 customer_name varchar(50) not null,
 email varchar(50),
 shipping_addres varchar(80)
);

create table orders1 (
 order_id int not null primary key,
 customer_id int not null,
 order_date date not null,
 total_amount decimal not null
);


create table orders_details1 (
 order_detail_id int not null primary key,
 order_id int not null,
 product_id int not null,
 qty int not null,
 order_price decimal not null
);


create table products1 (
 product_id int not null primary key,
 product_name varchar(50) not null,
 description varchar(80),
 price decimal not null,
 stock_quantity int
);


-- Insert sample data into Customers table
INSERT INTO Customers1 (customer_id, customer_name, email, shipping_addres)
VALUES
  (1, 'John Smith', 'john.smith@example.com', '123 Main St, Anytown'),
  (2, 'Jane Doe', 'jane.doe@example.com', '456 Elm St, AnotherTown'),
  (3, 'Michael Johnson', 'michael.johnson@example.com', '789 Oak St, Somewhere'),
  (4, 'Emily Wilson', 'emily.wilson@example.com', '567 Pine St, Nowhere'),
  (5, 'David Brown', 'david.brown@example.com', '321 Maple St, Anywhere');

INSERT INTO Products1 (product_id, product_name, description, price, stock_quantity)
VALUES
  (1, 'iPhone X', 'Apple iPhone X, 64GB', 999, 10),
  (2, 'Galaxy S9', 'Samsung Galaxy S9, 128GB', 899, 5),
  (3, 'iPad Pro', 'Apple iPad Pro, 11-inch', 799, 8),
  (4, 'Pixel 4a', 'Google Pixel 4a, 128GB', 499, 12),
  (5, 'MacBook Air', 'Apple MacBook Air, 13-inch', 1099, 3);


-- Insert sample data into Orders table
INSERT INTO Orders1 (order_id, customer_id, order_date, total_amount)
VALUES
(1, 1, '2023-01-01', 0),
(2, 2, '2023-02-15', 0),
(3, 3, '2023-03-10', 0),
(4, 4, '2023-04-05', 0),
(5, 5, '2023-05-20', 0);


-- Insert sample data into OrderDetails table
INSERT INTO orders_details1 (order_detail_id, order_id, product_id, qty, order_price)
VALUES
  (1, 1, 1, 1, 999),
  (2, 2, 2, 1, 899),
  (3, 3, 3, 2, 799),
  (4, 3, 1, 1, 999),
  (5, 4, 4, 1, 499),
  (6, 4, 4, 1, 499),
  (7, 5, 5, 1, 1099),
  (8, 5, 1, 1, 999),
  (9, 5, 3, 1, 799);

select * from customers1;
select * from orders1;
select * from orders_details1;
select * from products1;	


-- Update total_amount in Orders table
UPDATE Orders1
SET total_amount = (
  SELECT SUM(qty * order_price)
  FROM Orders_Details1
  WHERE Orders_Details1.order_id = Orders1.order_id
);


--Retrieve the order ID, customer IDs, customer names, and total amounts for orders that have a total amount greater than $1000.
select o.order_id, c.customer_id, c.customer_name, o.total_amount from orders1 o join customers1 c on o.customer_id = c.customer_id where o.total_amount > 1000;


--Retrieve the total quantity of each product sold.
select p.product_name , sum(od.qty) as total_qty from orders_details1 od join products1 p on od.product_id = p.product_id group by p.product_name;


--Retrieve the order details (order ID, product name, quantity) for orders with a quantity greater than the average quantity of all orders.
select od.order_id, p.product_name, od.qty from orders_details1 od join products1 p on od.product_id = p.product_id where qty > (select avg(qty) from orders_details1);


--Retrieve the order IDs and the number of unique products included in each order.
select order_id ,count(distinct product_id) as unique_products from orders_details1 group by order_id;


--Retrieve the total number of products sold for each month in the year 2023. Display the month along with the total number of products.
select month(o.order_date) as month, sum(od.qty) as total_product_sold from orders_details1 od join orders1 o on od.order_id = o.order_id where year(o.order_date) = 2023 group by month(o.order_date) order by month(o.order_date); 


--Retrieve the total number of products sold for each month in the year 2023 where the total number of products sold were greater than 2. Display the month along with the total number of products.
select month(o.order_date) as month, sum(od.qty) as total_product_sold from orders_details1 od join orders1 o on od.order_id = o.order_id where year(order_date) = 2023 group by month(o.order_date) having sum(qty) > 2; 



--Retrieve the order IDs and the order amount based on the following criteria:
--If the total_amount > 1000 then ‘High Value’
--If it is less than or equal to 1000 then ‘Low Value’
--Output should be order IDs, order amount, and Value.
select order_id, total_amount, case when total_amount > 1000 then 'High Value' else 'Low Value' end as value from orders1;




--Retrieve the order IDs and the order amount based on the following criteria:
--If the total_amount > 1000 then ‘High Value’
--If it is less than 1000 then ‘Low Value’
--If it is equal to 1000 then ‘Medium Value’
--Only print the ‘High Value’ products. Output should be order IDs, order amount, and Value.
SELECT order_id, total_amount, value
FROM (select order_id, total_amount, case when total_amount > 1000 then 'High Value' when total_amount = 1000 then 'Medium Value' else 'Low Value' end as value from orders1) as sub WHERE value = 'High Value';

