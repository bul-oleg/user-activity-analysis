WITH order_level AS (
	SELECT 
		o.customer_id, 
		o.order_id,
		SUM(p.payment_value) AS amount
	FROM 
		payments p JOIN orders o ON p.order_id = o.order_id
	WHERE order_status = 'delivered'
	GROUP BY 1, 2
),

user_level AS (
	SELECT
		c.customer_unique,
		COUNT(*) AS orders,
		SUM(amount) AS revenue
	FROM order_level ol JOIN customers c ON ol.customer_id = c.customer_id
	GROUP BY 1
),

total_revenue AS (
	SELECT SUM(revenue) AS total_revenue
	FROM user_level
)

SELECT
	CASE
		WHEN orders = 1 THEN '1 заказ'
		WHEN orders = 2 THEN '2 заказа'
		WHEN orders = 3 THEN '3 заказа'
		WHEN orders >= 4 THEN '4 и более'
	END AS total,
	SUM(revenue) AS revenue, 
	ROUND(SUM(revenue) / MIN(total_revenue), 3)
FROM user_level, total_revenue
GROUP BY 1
ORDER BY 2 DESC





