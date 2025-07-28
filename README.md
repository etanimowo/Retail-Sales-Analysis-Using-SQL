## Retail-Sales-Analysis-Using-SQL: Uncovering Trends & Customer Behavior

### Table of Content
- [Project Overview](#project-overview)
- [The Problem](#the-problem)
- [Objective](#objective)
- [Create Database](#create-database)
- [Create Tables](#create-tables)
- [Load Tables](#load-tables)
- [Analysis Queries](#analysis-queries)
- [Actionable Recommendations](#actionable-recommendations)
- [Download](#download)

### Project Overview
This project analyzes sales, customer, and product data for a fictional retail company using PostgreSQL. The goal is to derive meaningful insights that can guide inventory, marketing, and customer engagement strategies.  The dataset includes:
- Sales transactions with dates, amounts, and store/product/customer IDs.
- Customers with segment classification.
- Products with price and name.
- Stores categorized by region.

Using PostgreSQL, l conducted in-depth analysis to identify top-performing products, revenue trends, customer segmentation, and regional performance on the dataset.

---

### The Problem
Retail companies often accumulate vast amounts of transactional data but lack the tools and structure to:
- Identify high-value customers and products
- Detect sales patterns over time
- Optimize regional performance
- Improve inventory decisions

This however, leads to lost revenue, inefficient marketing, and poor customer targeting.

---

### Objective
-	To analyze transactional sales data and uncover business-critical insights.
- To identify trends in:
   - Product performance
   - Customer segmentation
   - Regional sales
-	Time-based revenue
- To recommend data-driven actions that improve business decisions.

---

### Create Database
First l need to create a database call Retail_db

CREATE DATABASE Retail_db

<img width="417" height="251" alt="database1" src="https://github.com/user-attachments/assets/599a2eaf-6983-4025-9a3d-c7a590a32619" />

<br></br>

<img width="192" height="225" alt="database2" src="https://github.com/user-attachments/assets/da7ca828-6e2e-4539-b103-55cc636b213b" />

Reail_db database is created as shown above.

---

### Create Tables
Next, l need to create Tables:

##### Customer table:
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_segment VARCHAR(50)
);

##### product table:
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

##### stores table:
CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    region VARCHAR(50)
);

##### sales table:
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

<img width="515" height="227" alt="table1" src="https://github.com/user-attachments/assets/6ea2700a-cb0d-411c-9bf8-1aea182a6f89" />

---

### Load Tables
Next is to load the csv files into the PostgreSQL

COPY customers(customer_id, customer_name, customer_segment)
FROM '/documents/sql/customers.csv' DELIMITER ',' CSV HEADER

To check\confirm:
SELECT COUNT(*) FROM customers;

COPY products(product_id, product_name, price)
FROM '/documents/sql/products.csv' DELIMITER ',' CSV HEADER;

To check\confirm:
SELECT COUNT(*) FROM customers;

COPY stores(store_id, store_name, region)
FROM '/documents/sql/stores.csv' DELIMITER ',' CSV HEADER;

To check\confirm:
SELECT COUNT(*) FROM customers;

COPY sales(sale_id, customer_id, product_id, store_id, quantity, sale_date, price, sales_amount)
FROM '/documents/sql/sales.csv' DELIMITER ',' CSV HEADER;

<img width="529" height="234" alt="table2" src="https://github.com/user-attachments/assets/3b653464-d8fa-4633-9c95-7cdd28060282" />

---

### Analysis Queries

#### Top 5 Best-Selling Products
SELECT p.product_name, SUM(s.quantity) AS total_units_sold
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_units_sold DESC
LIMIT 5;

 <img width="301" height="205" alt="best selling products" src="https://github.com/user-attachments/assets/cc4b87d6-0b93-4ddd-9e9b-0cd6c220852f" />
<br></br>
<img width="601" height="214" alt="graph best selling products" src="https://github.com/user-attachments/assets/e4bffee2-4bd9-434b-9a3b-621c8b5a114a" />

Insight: These five products consistently outperform others, making up a large portion of total sales.

#### Revenue by Region
SELECT st.region, SUM(s.sales_amount) AS total_revenue
FROM sales s
JOIN stores st ON s.store_id = st.store_id
GROUP BY st.region
ORDER BY total_revenue DESC;

<img width="283" height="204" alt="rev by reg" src="https://github.com/user-attachments/assets/134cdd29-9470-45d5-a4ae-8a2cc2bdb2ec" />
<br></br>
<img width="602" height="220" alt="graph rev by reg" src="https://github.com/user-attachments/assets/aba3c375-5b3d-4e08-aef3-9105bc62aacd" />
 
Insight: Certain regions drive a disproportionate amount of revenue, while others underperform.

#### Monthly Sales Trend
SELECT TO_CHAR(sale_date, 'YYYY-MM') AS month, SUM(sales_amount) AS monthly_revenue
FROM sales
GROUP BY month
ORDER BY month;

<img width="217" height="170" alt="monthly sales" src="https://github.com/user-attachments/assets/450124eb-3298-4cd9-9550-f40515cf6d77" />
<br></br>
<img width="602" height="224" alt="graph monthly sales" src="https://github.com/user-attachments/assets/e5f228c5-a98c-4344-9ff3-c0c43b1f7688" />

Insight: Sales spike during specific months, indicating seasonality.

#### Customer Segment Distribution
SELECT customer_segment, COUNT(*) AS total_customers
FROM customers
GROUP BY customer_segment
ORDER BY total_customers DESC;

<img width="313" height="181" alt="segmentation" src="https://github.com/user-attachments/assets/4ee5f467-c766-405f-930b-9326c66981ed" />
<br></br>
<img width="602" height="219" alt="graph segmentation" src="https://github.com/user-attachments/assets/4016041d-9ee8-4b91-adbd-7628b648dd19" />

Insight: The "Loyal" customer segment contributes the largest customer base and revenue.

#### Top 5 Customers by Spending
SELECT c.customer_name, SUM(s.sales_amount) AS total_spent
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

<img width="257" height="188" alt="five customer by spending" src="https://github.com/user-attachments/assets/b49bddfd-b806-4f18-b2aa-a5f4ab2b1f38" />
<br></br>
<img width="602" height="220" alt="graph five customer by spending" src="https://github.com/user-attachments/assets/55c225f4-877f-456d-8c2e-9ffd59b0134c" />

Insight: A small group of high-value customers contribute significantly to revenue.

---

### Actionable Recommendations
#### Best – Selling product:
Increase inventory and promote these items more aggressively. Bundle with other products.

#### Regional Revenue:
Focus marketing in top regions. Investigate and improve performance in weaker ones.

#### Monthly Trends:
Prepare stock and campaigns ahead of high-sales months. Launch promotions during low-sales months.

#### Customer Segments:
Design loyalty programs for dominant segments. Target smaller segments with engagement offers.

#### High-Value Customers:
Treat as VIPs — personalized discounts, early access to new products. Retarget 

### Download
[Download the SQL scripts here:](./Retail_store)

