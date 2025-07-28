-- Create a Database Retial_db

CREATE DATABASE Retail_db

-- Next is create table for each of the database

-- Customer table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_segment VARCHAR(50)
);

-- Product table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

-- Store table
CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    region VARCHAR(50)
);


-- Sales table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    store_id INT,
    quantity INT,
    sale_date DATE,
    price DECIMAL(10, 2),
    sales_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- Next is load the csv unto the table created as follows:

-- Customer table
COPY customers(customer_id, customer_name, customer_segment)
FROM '/documents/sql/customers.csv' DELIMITER ',' CSV HEADER;

SELECT COUNT(*) FROM customers;

-- Product table
COPY products(product_id, product_name, price)
FROM '/documents/sql/products.csv' DELIMITER ',' CSV HEADER;

SELECT COUNT(*) FROM product;

-- Stores table
COPY stores(store_id, store_name, region)
FROM '/documents/sql/stores.csv' DELIMITER ',' CSV HEADER;

SELECT COUNT(*) FROM stores;

-- Sales table
COPY sales(sale_id, customer_id, product_id, store_id, quantity, sale_date, price, sales_amount)
FROM '/documents/sql/sales.csv' DELIMITER ',' CSV HEADER;

SELECT COUNT(*) FROM sales;




-- Top 5 Best-Selling Products
SELECT p.product_name, SUM(s.quantity) AS total_units_sold
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_units_sold DESC
LIMIT 5;




-- Revenue by Region
SELECT st.region, SUM(s.sales_amount) AS total_revenue
FROM sales s
JOIN stores st ON s.store_id = st.store_id
GROUP BY st.region
ORDER BY total_revenue DESC;




-- Customers by Segment
SELECT customer_segment, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_segment;



-- Monthly Sales Trends
SELECT TO_CHAR(sale_date, 'YYYY-MM') AS month, SUM(sales_amount) AS monthly_revenue
FROM sales
GROUP BY month
ORDER BY month;


-- Top Customers by Total Spending
SELECT c.customer_name, SUM(s.sales_amount) AS total_spent
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 5;



-- Low-Performing Products
SELECT p.product_name, SUM(s.quantity) AS total_units_sold
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_units_sold ASC
LIMIT 5;



















