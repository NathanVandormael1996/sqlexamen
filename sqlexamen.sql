SELECT *
FROM staff;

SELECT c.city_id, c.city
FROM city c;

SELECT *
FROM customer c
WHERE c.active = 1;

SELECT *
FROM payment p
WHERE p.payment_date LIKE '2005-07%';

SELECT *
FROM rental r
ORDER BY r.last_update DESC
LIMIT 15;

SELECT *
FROM customer c
ORDER BY last_name ASC, first_name ASC
LIMIT 20;

INSERT INTO language(language.name, language.last_update)
VALUE ('Flemish',NOW());

INSERT INTO language(language.name, language.last_update)
VALUES ('Spanish',NOW()),
	   ('Russian', NOW());

SELECT c.first_name, c.last_name, ci.city
FROM customer c
LEFT JOIN address a ON c.address_id = a.address_id
LEFT JOIN city ci ON a.city_id = ci.city_id;

SELECT st.first_name, st.last_name, a.address
FROM store s
LEFT JOIN staff st ON s.manager_staff_id = st.staff_id
LEFT JOIN address a ON s.address_id = a.address_id;

SELECT s.store_id, COUNT(r.rental_id) AS aantalRentals
FROM store s
LEFT JOIN staff st ON s.manager_staff_id = st.staff_id
LEFT JOIN rental r ON st.staff_id = r.staff_id
WHERE r.rental_date LIKE '2005%'
GROUP BY s.store_id
ORDER BY aantalRentals DESC;

SELECT c.first_name, c.last_name, SUM(p.amount) AS totaalBedrag
FROM customer c 
LEFT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
HAVING totaalBedrag > 100
ORDER BY totaalBedrag DESC;

CREATE VIEW aantalklanten_city
AS
SELECT c.city, COUNT(cu.customer_id) as aantalKlanten
FROM city c
LEFT JOIN address a ON c.city_id = a.city_id
LEFT JOIN customer cu ON a.address_id = cu.address_id
GROUP BY c.city;

DROP PROCEDURE IF EXISTS sp_movie_amount_customer;
DELIMITER //

CREATE PROCEDURE sp_movie_amount_customer(IN c_first_name VARCHAR(45),IN c_last_name VARCHAR(45),OUT n_amount INT)
BEGIN 

SELECT COUNT(r.rental_id) INTO n_amount 
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
WHERE c.first_name = c_first_name && c.last_name = c_last_name
GROUP BY c.customer_id;

END //
DELIMITER ;

CREATE DATABASE dbprojects;
USE dbprojects;

CREATE TABLE developer(
	developer_id INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE project(
    project_id INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE project_developer(
    developer_id INT(11) UNSIGNED NOT NULL,
    project_id INT(11) UNSIGNED NOT NULL,
    role VARCHAR(50),
    PRIMARY KEY(developer_id, project_id),
    FOREIGN KEY (developer_id) REFERENCES developer(developer_id)
							ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY (project_id) REFERENCES project(project_id)
							ON UPDATE RESTRICT ON DELETE RESTRICT
);