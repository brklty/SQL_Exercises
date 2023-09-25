-- Tasks
use CUSTOMERS;
-- 1: Query the names of people starting with the letter 'A' from the Customers table.

SELECT * FROM CUSTOMERS 
WHERE NAMESURNAME LIKE 'A%';


-- 2: Query male customers starting with the letter 'A' from the Customers table.

SELECT * FROM CUSTOMERS
WHERE NAMESURNAME LIKE 'A%'
AND GENDER = 'E'; -- E: ERKEK (MALE) K: KADIN (FEMALE)


-- 3: Query about customers born between 1990 and 1995. Years 1990 and 1995 are included.

SELECT * FROM CUSTOMERS
WHERE BIRTHDATE BETWEEN '1990-01-01' AND '1995-12-31';

-- 4: Write a query using Join people living in Istanbul.

SELECT C.*,CT.CITY FROM CUSTOMERS C
INNER JOIN CITIES CT
ON C.CITYID = CT.ID
WHERE CT.CITY = 'Istanbul';


-- 5: Write the query that retrieves the people living in istanbul using subquery.

SELECT
*,(SELECT CITY FROM CITIES WHERE ID=C.CITYID) AS CITY
FROM CUSTOMERS C
WHERE (SELECT CITY FROM CITIES WHERE ID=C.CITYID)='ISTANBUL';

-- 6: Write the query that retrieves information about how many customers we have in which city.

SELECT CT.CITY,COUNT(*) AS COUNT FROM CUSTOMERS C
RIGHT JOIN CITIES CT -- ALL CITIES INCLUDED WITH NULL
ON C.CITYID = CT.ID
GROUP BY CT.CITY;


-- 7: Query the cities with more than 10 customers with the number of customers, 
-- sorted by the number of customers from more to less.


SELECT CT.CITY, COUNT(*) AS CNT FROM CUSTOMERS C
INNER JOIN CITIES CT
ON C.CITYID = CT.ID
GROUP BY CT.CITY
HAVING COUNT(*)>10;


SELECT CITY,
(SELECT COUNT(*) FROM CUSTOMERS C WHERE C.CITYID = CT.ID)
FROM CITIES CT
WHERE (SELECT COUNT(*) FROM CUSTOMERS C WHERE C.CITYID = CT.ID) > 10
ORDER BY 2 DESC;


-- 8: Write the query that retrieves the information about how many male 
-- and how many female customers we have in which city.

SELECT CT.CITY CITY, C.GENDER GENDER, COUNT(*) CUSTOMERCOUNT FROM CUSTOMERS C
INNER JOIN CITIES CT
ON C.CITYID = CT.ID
GROUP BY CITY , GENDER
ORDER BY 1;



-- 9: Write the query that provides information about how many male 
-- and female customers we have in which city.

SELECT CITY,
(SELECT COUNT(*) FROM CUSTOMERS C WHERE C.CITYID=CT.ID AND C.GENDER = 'E') AS ERKEKSAYISI,
(SELECT COUNT(*) FROM CUSTOMERS C WHERE C.CITYID=CT.ID AND C.GENDER = 'K') AS ERKEKSAYISI
FROM CITIES CT;


-- 10: Add a new field for the age group in the Customers table. This operation
-- do it both with management studio and with sql code. column name AGEGROUP datatype Varchar(50)


ALTER TABLE CUSTOMERS
ADD AGEGROUP VARCHAR(50);


-- 11: Update The AGEGROUP column you added to the Customers table is 20-35 years old; 
-- 36-45 years old,  46-55 years old, 56-65 years old and 65 and over.

SELECT DATEDIFF(YEAR,BIRTHDATE,GETDATE()),*
FROM CUSTOMERS

UPDATE CUSTOMERS SET AGEGROUP='20-35'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 20 AND 35;

SELECT DATEDIFF(YEAR,BIRTHDATE,GETDATE()),*
FROM CUSTOMERS

UPDATE CUSTOMERS SET AGEGROUP='36-45'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 36 AND 45;


SELECT DATEDIFF(YEAR,BIRTHDATE,GETDATE()),*
FROM CUSTOMERS

UPDATE CUSTOMERS SET AGEGROUP='46-55'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 46 AND 55;


SELECT DATEDIFF(YEAR,BIRTHDATE,GETDATE()),*
FROM CUSTOMERS

UPDATE CUSTOMERS SET AGEGROUP='56-65'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 56 AND 65;

SELECT DATEDIFF(YEAR,BIRTHDATE,GETDATE()),*
FROM CUSTOMERS

UPDATE CUSTOMERS SET AGEGROUP='65 +'
WHERE DATEDIFF(YEAR,BIRTHDATE,GETDATE()) >65;

-- 12: In the Customers table, group the customers according to their age 
-- and query them without using the AGEGROUP field.


SELECT AGEGROUP2, COUNT(TMP.ID) AS CUSTOMERSCOUNT FROM 
(SELECT *,
	CASE
		WHEN DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 20 AND 35 THEN '20-35'
		WHEN DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 36 AND 45 THEN '36-45'
		WHEN DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 46 AND 55 THEN '46-55'
		WHEN DATEDIFF(YEAR,BIRTHDATE,GETDATE()) BETWEEN 56 AND 65 THEN '56-65'
		WHEN DATEDIFF(YEAR,BIRTHDATE,GETDATE()) >65 THEN '65 +' 
	END AGEGROUP2
FROM CUSTOMERS) TMP

GROUP BY AGEGROUP2
ORDER BY AGEGROUP2 ;

-- 13: Query customers living in Istanbul but outside the province of 'Kadikoy'.

SELECT C.* , CT.CITY, D.DISTRICT FROM CUSTOMERS C
INNER JOIN CITIES CT ON CT.ID = C.CITYID
INNER JOIN DISTRICT D ON D.ID = C.DISTRICTID
WHERE CT.CITY = 'ISTANBUL' AND D.DISTRICT NOT LIKE 'KADIKÖY';

--14: Suppose we delete the record "Ankara" from the Cities table. In this case, 
-- the city field of customers whose city is "Ankara" will be empty.
-- Write the query that lists the customers with empty city field.

DELETE FROM CITIES WHERE CITY = 'ANKARA';

SELECT * FROM CITIES;

SELECT  C.* FROM CUSTOMERS C
LEFT JOIN CITIES CT ON C.CITYID=CT.ID
WHERE CT.CITY IS NULL;

SELECT * FROM CUSTOMERS
WHERE CITYID NOT IN 
(SELECT ID FROM CITIES);

-- 15: Insert the Ankara records that we deleted from the CITIES table in the 
-- previous task into the table again with the same IDs.

SET IDENTITY_INSERT CITIES ON

INSERT INTO CITIES(ID,CITY) VALUES(6, 'ANKARA')

SELECT * FROM CITIES
WHERE ID = 6;

-- 16: We want to retrieve the operator information of our customers' phone numbers. 
-- We want to bring the operator number next to the TELNRI and TELNR2 columns like (532),(505).
-- Write the SQL statement for this query.

SELECT NAMESURNAME, 
TELNR1, 
SUBSTRING(TELNR1,1,5) AS OPERATOR1,
TELNR2,
LEFT(TELNR2,5) AS OPERATOR2
FROM CUSTOMERS;


-- 17: We want to retrieve the operator information of our customers' phone numbers. For example, 
-- "X" operator whose phone numbers start with "50" or "55", 
-- "Y" operator whose phone numbers start with "54" 
-- and "Z" operator whose phone numbers start with "53". 
-- Write the query that will return the information about how many customers we have from which operator.

SELECT TOP(1)
((SELECT TOP(1) COUNT(*) FROM CUSTOMERS WHERE TELNR1 LIKE '(50%' OR TELNR1 LIKE '(55%') + (SELECT tOP(1) COUNT(*) FROM CUSTOMERS WHERE TELNR2 LIKE '(50%' OR TELNR2 LIKE '(55%')) AS XOPERATORCOUNT,
((SELECT TOP(1) COUNT(*) FROM CUSTOMERS WHERE TELNR1 LIKE '(54%')+ (SELECT TOP(1) COUNT(*) FROM CUSTOMERS WHERE TELNR2 LIKE '(54%')) AS YOPERATORCOUNT,
((SELECT TOP(1) COUNT(*) FROM CUSTOMERS WHERE TELNR1 LIKE '(53%')+ (SELECT TOP(1) COUNT(*) FROM CUSTOMERS WHERE TELNR2 LIKE '(53%')) AS ZOPERATORCOUNT
FROM CUSTOMERS;

SELECT 
SUM(TELNR1_XOPERATOR + TELNR2_XOPERATOR) AS XOPERATORCOUNT,
SUM(TELNR1_YOPERATOR + TELNR2_YOPERATOR) AS YOPERATORCOUNT,
SUM(TELNR1_ZOPERATOR + TELNR2_ZOPERATOR) AS ZOPERATORCOUNT

FROM
(
SELECT
CASE
	WHEN TELNR1 LIKE '(50%' OR TELNR1 LIKE '(55%' THEN 1
	ELSE 0
END AS TELNR1_XOPERATOR,
CASE
	WHEN TELNR1 LIKE '(54%' THEN 1
	ELSE 0
END AS TELNR1_YOPERATOR,
CASE
	WHEN TELNR1 LIKE '(53%' THEN 1
	ELSE 0
END AS TELNR1_ZOPERATOR,
CASE
	WHEN TELNR2 LIKE '(50%' OR TELNR2 LIKE '(55%' THEN 1
	ELSE 0
END AS TELNR2_XOPERATOR,
CASE
	WHEN TELNR2 LIKE '(54%' THEN 1
	ELSE 0
END AS TELNR2_YOPERATOR,
CASE
	WHEN TELNR2 LIKE '(53%' THEN 1
	ELSE 0
END AS TELNR2_ZOPERATOR FROM CUSTOMERS) AS T;

-- 18: Write the query required to bring the provinces with the highest number of customers 
-- in each province from most to least according to the number of customers.

SELECT CT.CITY, D.DISTRICT, COUNT(C.ID) FROM CUSTOMERS C
INNER JOIN CITIES CT ON CT.ID = C.CITYID
INNER JOIN DISTRICT D ON D.ID = C.DISTRICTID
GROUP BY CT.CITY, D.DISTRICT
ORDER BY 1, 3 DESC;

-- 19: Write a query that retrieves customers' birthdays as the day of the week:

SELECT DATENAME(DW,BIRTHDATE) FROM CUSTOMERS;

-- 20: Write query for customers whose birthday is today.


SELECT * FROM CUSTOMERS
WHERE DATEPART(MONTH,BIRTHDATE) = DATEPART(MONTH,GETDATE())
AND
DATEPART(DAY,BIRTHDATE) = DATEPART(DAY,GETDATE());

SELECT * FROM CUSTOMERS
WHERE MONTH(BIRTHDATE) = MONTH(GETDATE())
AND
DAY(BIRTHDATE) = DAY(GETDATE());
