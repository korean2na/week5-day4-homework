--1. List all customers who live in Texas 
-- (Use JOINs)
SELECT district, first_name, last_name
FROM customer
JOIN address
ON address.address_id = customer.address_id
WHERE district = 'Texas';

--2. Get all payments above $6.99 with the Customer's Full Name
SELECT concat(first_name, ' ', last_name) AS full_name, amount
FROM payment
JOIN rental
ON rental.rental_id = payment.rental_id 
JOIN customer 
ON customer.customer_id = rental.customer_id 
WHERE amount > 6.99
ORDER BY amount;

--3. Show all customers names who have made payments over $175
-- (Use subqueries)
SELECT concat(first_name, ' ', last_name) AS full_name, sum(amount)
FROM payment
JOIN rental
ON rental.rental_id = payment.rental_id 
JOIN customer 
ON customer.customer_id = rental.customer_id
GROUP BY full_name
HAVING sum(amount) > 175;
-- not sure where the subquery would be implemented, come back to this later

--4. List all customers that live in Nepal 
-- (Use the city table)
SELECT country, concat(first_name, ' ', last_name) AS full_name
FROM customer
JOIN address
ON address.address_id = customer.address_id 
JOIN city 
ON city.city_id = address.city_id 
JOIN country
ON country.country_id = city.country_id;

--5. Which staff member had the most transactions?

-- counts of rentals sold by staff members
--SELECT concat(staff.first_name, ' ', staff.last_name) AS full_name, count(rental_id)
--FROM rental
--JOIN staff 
--ON staff.staff_id = rental.staff_id
--GROUP BY full_name
--ORDER BY count DESC;
-- highest count of rentals sold
--SELECT max(count)
--FROM (
--	SELECT concat(staff.first_name, ' ', staff.last_name) AS full_name, count(rental_id)
--	FROM rental
--	JOIN staff 
--	ON staff.staff_id = rental.staff_id
--	GROUP BY full_name
--) AS most_rentals;

SELECT concat(staff.first_name, ' ', staff.last_name) AS full_name, count(rental_id)
FROM rental
JOIN staff 
ON staff.staff_id = rental.staff_id
GROUP BY full_name
HAVING count(rental_id) = (
	SELECT max(count)
	FROM (
		SELECT concat(staff.first_name, ' ', staff.last_name) AS full_name, count(rental_id)
		FROM rental
		JOIN staff 
		ON staff.staff_id = rental.staff_id
		GROUP BY full_name
	) AS most_rentals
);

--6. How many movies of each rating are there?
SELECT rating, count(film_id)
FROM film
GROUP BY rating
ORDER BY rating ASC;

--7.Show all customers who have made a single payment above $6.99
-- (Use Subqueries)

-- select all payment_id that are above 6.99
SELECT concat(first_name, ' ', last_name) AS full_name, amount
FROM customer 
JOIN rental 
ON rental.customer_id = customer.customer_id 
JOIN payment 
ON payment.rental_id = rental.rental_id 
WHERE amount > 6.99;

-- need to get count of payments from that selection grouped by customer
-- limit that selection to customers that have only 1 count
SELECT concat(first_name, ' ', last_name) AS full_name, count(amount) AS movies_above_6_99_rented
FROM customer 
JOIN rental 
ON rental.customer_id = customer.customer_id 
JOIN payment 
ON payment.rental_id = rental.rental_id
WHERE amount > 6.99
GROUP BY full_name
HAVING count(amount) = 1;
-- not sure where the subquery would be implemented, come back to this later

--8. How many free rentals did our stores give away?
SELECT count(rental_id) AS free_movie_count
FROM payment 
WHERE amount = 0;

