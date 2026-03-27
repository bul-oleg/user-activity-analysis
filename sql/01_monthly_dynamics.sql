-- В этом запросе считаем динамику выручки, среднего чека, числа заказов
-- и количества покупателей по месяцам. В расчет берутся только те заказы, 
-- которые находятся в статусе "доставлено"

SELECT 
	DATE_TRUNC('month', o.order_date) AS order_month,
	SUM(p.payment_value) AS revenue,
	COUNT(DISTINCT o.order_id) AS orders,
	SUM(p.payment_value) / COUNT(DISTINCT o.order_id) AS avg_check,
	COUNT(DISTINCT c.customer_unique) AS total_users
FROM
	orders o JOIN payments p ON o.order_id = p.order_id
			 JOIN customers c ON o.customer_id = c.customer_id
WHERE order_status = 'delivered'
GROUP BY 1
ORDER BY 1