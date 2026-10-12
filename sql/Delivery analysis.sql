WITH order_delivery_metrics AS (
    SELECT 
        o.order_id,
        c.customer_state,
        FORMAT_DATE('%Y-%m', CAST(o.order_purchase_timestamp AS DATE)) AS order_month,
        EXTRACT(YEAR FROM o.order_purchase_timestamp) AS order_year,
        
        TIMESTAMP_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY) AS delivery_days,
        CASE 
            WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 
            ELSE 0 
        END AS is_late
    FROM `olist-ecommerce-sales-analysis.Salesanalysis.olist_orders` AS o
    JOIN `olist-ecommerce-sales-analysis.Salesanalysis.olist_customers` AS c 
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered' 
      AND o.order_delivered_customer_date IS NOT NULL 
      AND o.order_estimated_delivery_date IS NOT NULL
      AND o.order_purchase_timestamp IS NOT NULL
)
SELECT 
    order_month,
    order_year,
    customer_state,
    COUNT(order_id) AS total_delivered_orders,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_time_days,
    ROUND(
        (SUM(is_late) * 100.0) / NULLIF(COUNT(order_id), 0), 
    2) AS late_delivery_rate_percentage
FROM 
    order_delivery_metrics
GROUP BY 
    order_month,
    order_year,
    customer_state
ORDER BY 
    order_month DESC,
    avg_delivery_time_days DESC;


