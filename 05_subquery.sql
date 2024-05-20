-- calculate average amount paid by top 5 customers from the 10 identified cities

SELECT 
  AVG(total_amount_paid.total_amount) AS average
FROM
  (SELECT
    B.customer_id,
    B.first_name,
    B.last_name,
    SUM(A.amount) AS total_amount,
    D.city,
    E.country
  FROM payment A
  INNER JOIN customer B  ON A.customer_id =	B.customer_id
  INNER JOIN address C   ON B.address_id =	C.address_id
  INNER JOIN city D	 ON C.city_id =	    	D.city_id
  INNER JOIN country E	 ON D.country_id =	E.country_id
  WHERE city IN (
  	'Aurora',
  	'Acua',
  	'Citrus Heights',
  	'Iwaki',
  	'Ambattur',
  	'Shanwei',
  	'So Leopoldo',
  	'Teboksary',
  	'Tianjin',
  	'Cianjur'
  	) 
  GROUP BY 
	  D.city,
	  E.country,
	  B.customer_id
  ORDER BY 
    total_amount desc
  LIMIT 5) AS total_amount_paid


-- count of distinct customers within the top 5 countries, within the 10 identified cities with the hightest spending customers

SELECT 
	D.country,
	COUNT(DISTINCT A.customer_id) AS all_customer_count,
	COUNT(top_5_customers) AS top_customer_count
FROM customer A
INNER JOIN address B 	ON A.address_id = B.address_id
INNER JOIN city C 	ON B.city_id = 	  C.city_id
INNER JOIN country D 	ON C.country_id = D.country_id
LEFT JOIN
	(SELECT
    B.customer_id,
		B.first_name,
		B.last_name,
		SUM(A.amount) AS total_amount,
		D.city,
		E.country
	FROM payment A
	INNER JOIN customer B	ON A.customer_id =	B.customer_id
	INNER JOIN address C	ON B.address_id =	C.address_id
	INNER JOIN city D	ON C.city_id =		D.city_id
	INNER JOIN country E	ON D.country_id =	E.country_id
	WHERE city IN (
		'Aurora',
		'Acua',
		'Citrus Heights',
		'Iwaki',
		'Ambattur',
		'Shanwei',
		'So Leopoldo',
		'Teboksary',
		'Tianjin',
		'Cianjur'
		)
	GROUP BY 
		D.city,
		E.country,
		B.customer_id
	ORDER BY 
		total_amount desc
	LIMIT 5) AS top_5_customers
ON A.customer_id = top_5_customers.customer_id
GROUP BY 
  D.country
HAVING COUNT(DISTINCT top_5_customers)>=1
ORDER BY 
  country 
