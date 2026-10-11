WITH order_payments AS (
    SELECT 
        order_id, 
        SUM(payment_value) AS total_payment
    FROM `olist-ecommerce-sales-analysis.Salesanalysis.olist_order_payments`
    GROUP BY order_id
)
SELECT 
    COALESCE(t.string_field_1, p.product_category_name) AS category_name,
    COUNT(DISTINCT i.order_id) AS orders,
    ROUND(CAST(SUM(op.total_payment) AS NUMERIC), 2) AS total_revenue
FROM 
    `olist-ecommerce-sales-analysis.Salesanalysis.olist_products` AS p
LEFT JOIN 
    `olist-ecommerce-sales-analysis.Salesanalysis.olist_order_items` AS i 
    ON p.product_id = i.product_id
LEFT JOIN 
    `olist-ecommerce-sales-analysis.Salesanalysis.product_category_name_translation` AS t 
    ON p.product_category_name = t.string_field_0
LEFT JOIN 
    order_payments AS op 
    ON i.order_id = op.order_id
GROUP BY 
    category_name
ORDER BY 
    total_revenue DESC;