WITH payments_order AS (
	SELECT
		o.customer_id,
		o.order_id,
		SUM(p.payment_value) AS revenue
	FROM orders o JOIN payments p ON o.order_id = p.order_id
	WHERE o.order_status = 'delivered'
	GROUP BY 1, 2
)

SELECT
	COUNT(DISTINCT c.customer_unique) AS users,
	COUNT(DISTINCT po.order_id) AS orders,
	SUM(revenue) AS total_revenue,
	SUM(revenue) / COUNT(DISTINCT po.order_id) AS aov,
	SUM(revenue) / COUNT(DISTINCT c.customer_unique) AS arrpu,
	COUNT(DISTINCT po.order_id)::numeric / COUNT(DISTINCT c.customer_unique) AS orders_per_user
FROM 
	payments_order po JOIN customers c ON po.customer_id = c.customer_id