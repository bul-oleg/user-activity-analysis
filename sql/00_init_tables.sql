-- Создание таблиц и импорт csv из папки data.
-- При импорте длинные названия колонок сокращены:
-- customer_unique_id -> customer_unique, order_purchase_timestamp -> order_date

CREATE TABLE customers (
	customer_id TEXT PRIMARY KEY,
	customer_unique TEXT,
	zip_code_prefix TEXT,
	city TEXT,
	state TEXT
);

CREATE TABLE orders (
	order_id TEXT PRIMARY KEY,
	customer_id TEXT REFERENCES customers(customer_id),
	order_status TEXT,
	order_date TIMESTAMP,
	approved_at TIMESTAMP,
	delivered_carrier_date TIMESTAMP,
	delivered_customer_date TIMESTAMP,
	estimated_delivery_date TIMESTAMP
);

CREATE TABLE payments (
	order_id TEXT REFERENCES orders(order_id),
	payment_sequential INT,
	payment_type TEXT,
	payment_installments INT,
	payment_value NUMERIC
);

\copy customers FROM 'data/olist_customers_dataset.csv' WITH (FORMAT csv, HEADER true);
\copy orders FROM 'data/olist_orders_dataset.csv' WITH (FORMAT csv, HEADER true);
\copy payments FROM 'data/olist_order_payments_dataset.csv' WITH (FORMAT csv, HEADER true);
