-- 01. Quantos pedidos foram feitos para cada tipo de pagamento?

SELECT 
	payment_type,
	COUNT(DISTINCT order_id) AS distinct_orders
FROM order_payments 
GROUP BY 1
ORDER BY 2 DESC;

-- 02. Qual o n�mero m�ximo e m�nimo de parcelas nos pagamentos?

SELECT 
	MAX(payment_installments) max_division,
	MIN(payment_installments) min_division
FROM order_payments;

-- 03. Quais s�o os top 10 pedidos com os maiores valores?

SELECT 
	order_id,
	payment_value 
FROM order_payments
ORDER BY 2 DESC
LIMIT 10;

-- 04. Quais s�o os �ltimos 10 pedidos com os menores valores?

SELECT
	op.order_id,
	order_purchase_timestamp,
	op.payment_value 
FROM order_payments op 
INNER JOIN orders o ON op.order_id = o.order_id 
WHERE op.payment_value > 0
ORDER BY 3 ASC, 2 DESC
LIMIT 10;

-- 05. Qual a m�dia do valor de pagamento por tipo de pagamento?

SELECT 
	payment_type,
	ROUND(AVG(payment_value), 2) AS avg_payment_value
FROM order_payments 
GROUP BY 1
ORDER BY 2 DESC;

-- 06. Quais os top 5 clientes com os maiores valores de pagamento no boleto?

SELECT 
	o.customer_id,
	op.payment_value
FROM order_payments op 
INNER JOIN orders o ON op.order_id = o.order_id 
WHERE LOWER(op.payment_type) = "boleto"
ORDER BY 2 DESC 
LIMIT 5;

-- 07. Quais os top 5 clientes com os maiores valores de pagamento no cart�o de cr�dito?

SELECT DISTINCT 
	o.customer_id,
	op.payment_value
FROM order_payments op 
INNER JOIN orders o ON op.order_id = o.order_id 
WHERE LOWER(op.payment_type) = "credit_card"
ORDER BY 2 DESC 
LIMIT 5;

-- 08. Quais os 10 produtos mais caros?

SELECT DISTINCT 
	product_id,
	price
FROM order_items
ORDER BY 2 DESC
LIMIT 10;

-- 09. Quais os 10 produtos mais baratos?

SELECT DISTINCT
	product_id,
	price
FROM order_items
ORDER BY 2 ASC
LIMIT 10;

-- 10. Quais as 10 categorias mais compradas?

SELECT 
	p.product_category_name,
	COUNT(DISTINCT oi.order_id) AS distinct_orders
FROM products p 
INNER JOIN order_items oi ON p.product_id = oi.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 10; 

-- 11. Quais os 5 produtos com maior n�mero de reviews?

SELECT 
	oi.product_id,
	COUNT(DISTINCT or2.review_id) AS distinct_reviews 
FROM order_items oi 
INNER JOIN order_reviews or2 ON oi.order_id = or2.order_id
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5;

-- 12. Quais os top 10 produtos sem nenhum review?

SELECT 
	oi.product_id,
	COUNT(DISTINCT or2.review_id) AS distinct_reviews 
FROM order_items oi 
LEFT JOIN order_reviews or2 ON oi.order_id = or2.order_id
GROUP BY 1
ORDER BY 2 ASC 
LIMIT 10;

-- 13. Quais os 10 clientes com maior quantidade de pedidos?

SELECT 
	customer_id,
	COUNT(DISTINCT order_id) AS distinct_orders
FROM orders 
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 10;

-- 14. Quais os 10 clientes com a menor quantidade de pedidos?

SELECT 
	customer_id,
	COUNT(DISTINCT order_id) AS distinct_orders
FROM orders 
GROUP BY 1
ORDER BY 2 ASC 
LIMIT 10;

-- 15. Quais vendedores existem na base?

SELECT DISTINCT 
	seller_id,
	seller_city,
	seller_state 
FROM sellers; 

-- 16. Qual a distribui��o de vendedores por estado?

SELECT 
	seller_state, 
	COUNT(DISTINCT seller_id) AS distinct_sellers
FROM sellers 
GROUP BY 1 
ORDER BY 2 DESC; 

-- 17. Qual a distribui��o de clientes por estado?

SELECT 
	customer_state,
	COUNT(DISTINCT customer_id) AS distinct_customers
FROM customer 
GROUP BY 1 
ORDER BY 2 DESC; 

-- 18. Quais s�o os top 10 vendedores que mais receberam pagamentos por boleto?

SELECT 
	s.seller_id,
	COUNT(DISTINCT op.order_id) AS distinct_payments
FROM sellers s 
INNER JOIN order_items oi ON s.seller_id = oi.seller_id 
INNER JOIN order_payments op ON oi.order_id = op.order_id 
WHERE LOWER(op.payment_type) LIKE "%boleto%" 
GROUP BY 1 
ORDER BY 2 DESC 
LIMIT 10; 

-- 19. Quais s�o os 10 piores vendedores em termos de n�mero de vendas?

SELECT 
	s.seller_id,
	COUNT(DISTINCT oi.order_id) AS distinct_orders
FROM sellers s 
LEFT JOIN order_items oi ON s.seller_id = oi.seller_id 
GROUP BY 1 
ORDER BY 2 ASC
LIMIT 10; 

-- 20. Quantos produtos s�o comprados, em m�dia, por pedido? 

WITH metric_count AS (

	SELECT 
		COUNT(DISTINCT oi.product_id) AS purchased_products,
		COUNT(DISTINCT op.order_id) AS purchased_orders
	FROM order_items oi 
	INNER JOIN order_payments op ON oi.order_id = op.order_id 

)

SELECT 
	ROUND(CAST(purchased_products AS REAL)/CAST(purchased_orders AS REAL), 4) AS products_per_orders
FROM metric_count;
