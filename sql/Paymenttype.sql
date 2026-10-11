select ROUND(CAST(SUM(payment_value) AS NUMERIC), 2) AS value,
payment_type

from `olist-ecommerce-sales-analysis.Salesanalysis.olist_order_payments`
WHERE payment_type != 'not_defined'
group by payment_type
order by value desc;