WITH cohorts AS (
	SELECT 
		c.customer_unique,
		MIN(DATE_TRUNC('month', o.order_date)) AS cohort
	FROM 
		customers c JOIN orders o ON c.customer_id = o.customer_id
	WHERE order_status  = 'delivered'
	GROUP BY 1
),
	
user_orders AS (
	SELECT 
		c.customer_unique,
		DATE_TRUNC('month', o.order_date) AS order_date
	FROM customers c JOIN orders o ON c.customer_id = o.customer_id
	WHERE order_status = 'delivered'
),

retentions AS (
	SELECT 
		c.cohort,
		COUNT(
			DISTINCT CASE WHEN c.cohort = ou.order_date THEN c.customer_unique END
		) AS cohort_size,
		COUNT(
			DISTINCT CASE WHEN ou.order_date = c.cohort + INTERVAL '1 month' THEN c.customer_unique END
		) AS retention_m1,
		COUNT(
			DISTINCT CASE WHEN ou.order_date = c.cohort + INTERVAL '2 month' THEN c.customer_unique END
		) AS retention_m2,
		COUNT(DISTINCT
			CASE WHEN ou.order_date >= c.cohort + INTERVAL '1 month' THEN c.customer_unique END
		) AS rolling_retention
	FROM user_orders ou JOIN cohorts c ON ou.customer_unique = c.customer_unique
	GROUP BY 1
	ORDER BY 1
)

SELECT 
	cohort,
	cohort_size,
	retention_m1,
	retention_m2, 
	rolling_retention,
	retention_m1::numeric / cohort_size AS share_m1,
	retention_m2::numeric / cohort_size AS share_m2,
	rolling_retention::numeric / cohort_size AS share_rolling_retention
FROM retentions