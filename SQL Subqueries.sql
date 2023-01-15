use sakila;

-- Question 1 : How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT film_id 
FROM film
WHERE title = "Hunchback Impossible";

SELECT count(inventory_id) as copies
FROM inventory
WHERE film_id in (
	SELECT film_id
    FROM(
		SELECT film_id 
		FROM film
		WHERE title = "Hunchback Impossible"
        )sub1
		);
        
-- Question 2: List all films whose length is longer than the average of all the films.

SELECT * 
FROM film
WHERE length > (SELECT avg(length)
FROM film);

-- Question 3: Use subqueries to display all actors who appear in the film Alone Trip.

SELECT * 
FROM actor
WHERE actor_id in(
	SELECT actor_id
    FROM(
		SELECT actor_id 
		FROM film_actor
		WHERE film_id = (
			SELECT film_id
			FROM film
			WHERE title = "Alone Trip")
            )sub1
			);
            
-- Question 4: Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT * 
FROM film_category
WHERE category_id = (SELECT category_id
FROM category
WHERE name = "Family");

-- Question 5: Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the 
-- correct tables with their primary keys and foreign keys, that will help you get the relevant information.

-- Subqueries

SELECT * 
FROM customer
WHERE address_id in (
	SELECT address_id
    FROM(
		SELECT * 
	FROM address
	WHERE city_id in(
		SELECT city_id
		FROM(
			SELECT * 
			FROM city
			Where country_id = (
				SELECT country_id
				FROM country
				WHERE country = "Canada")
			)sub1
            )
            )sub2
            );

-- joins

SELECT c.customer_id
FROM customer c
LEFT JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = "Canada";

-- Question 6: Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.


SELECT * 
FROM film
WHERE film_id in ( 
	SELECT film_id
    FROM(
		SELECT * 
		FROM film_actor
		WHERE actor_id in (
			SELECT actor_id
			FROM(
				-- selects prolific actor
				SELECT actor_id, count(film_id) as total_films
				FROM film_actor
				GROUP BY actor_id
				ORDER BY total_films desc
				LIMIT 1)sub1
				)
			)sub2
            );