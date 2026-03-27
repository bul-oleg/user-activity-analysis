WITH ranked AS (
	SELECT
		customer_unique,
		order_date,
		ROW_NUMBER () OVER(
			PARTITION BY customer_unique
			ORDER BY order_date
		) AS rn
	FROM customers c JOIN orders o ON c.customer_id = o.customer_id
),

first_second AS (
	SELECT
		customer_unique,
		MIN(CASE WHEN rn = 1 THEN order_date END) AS first_order,
		MIN(CASE WHEN rn = 2 THEN order_date END) AS second_order
	FROM ranked
	GROUP BY 1
),

diffs AS (
	SELECT 
		customer_unique,
		DATE_PART('day', second_order - first_order) AS different
	FROM first_second
)

SELECT
	CASE
		WHEN different <= 30 THEN '0-30 days'
		WHEN different <= 60 THEN '31-60 days'
		WHEN different <= 90 THEN '61-90 days'
		WHEN different <= 180 THEN '91-180 days'
		WHEN different <= 365 THEN '181-365 days'
		WHEN different <= 730 THEN '1-2 years'
	END AS days_range,
	COUNT(*) AS users
FROM diffs
WHERE different IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
		
-- Всего из 100к юзеров возвращаются лишь 3%, из этих 3к около половины совершает покупку в следующие 30 дней после первой покупки.
		
		

