show DATABASES;

use mysql




CREATE TABLE IF NOT EXISTS student_details (
 roll_no int(10) NOT NULL,
 registration_no int(10) NOT NULL AUTO_INCREMENT,
 first_name varchar(50) NOT NULL DEFAULT '',
 last_name varchar(50) DEFAULT '',
 class varchar(10) NOT NULL DEFAULT '',
 marks int(3) NOT NULL DEFAULT '0',
 gender varchar(6) NOT NULL DEFAULT 'male',
 PRIMARY KEY(registration_no)
) ENGINE=InnoDB;


CREATE TABLE CITY (
    ID INT,
    NAME VARCHAR(17),
    COUNTRYCODE VARCHAR(3),
    DISTRICT VARCHAR(20),
    POPULATION INT,
    PRIMARY KEY(ID)
) ENGINE=InnoDB;

show TABLES




LOAD DATA INFILE '/workspace/City.csv' 
INTO TABLE CITY 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;





INSERT into CITY (ID,NAME,COUNTRYCODE, DISTRICT,POPULATION) VALUES (3430,"Odesa","UKR","Odesa",1011000)
INSERT into CITY (ID,NAME,COUNTRYCODE, DISTRICT,POPULATION) VALUES (4058,"Boulder","USA","Colorado",91238)





COMMIT

select count(*) from CITY



/*Q1. Query all columns for all American cities in the CITY table with populations larger than 100000.
The CountryCode for America is USA.
 */

select * from CITY where COUNTRYCODE LIKE "USA" and POPULATION >100000   -- 6 rows



/* q2. Query the NAME field for all American cities in the CITY table with populations larger than 120000.
The CountryCode for America is USA.
 */
select * from CITY where COUNTRYCODE LIKE "USA" and POPULATION >120000   -- 5 ROWS


/* 3. Query all columns (attributes) for every row in the CITY table */

select * from CITY

/*4. Query all columns for a city in CITY with the ID 1661 */

select * from CITY where ID = 1661 -- SAYAMA - JPN


/*5. Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is
JPN.*/

select * from CITY where COUNTRYCODE LIKE "JPN"  -- 5 ROWS



/*6. Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is
JPN. */

select NAME from CITY where COUNTRYCODE LIKE "JPN" 


/*7. Query a list of CITY and STATE from the STATION table*/

select CITY , STATE from STATION 


/*8. Query a list of CITY names from STATION for cities that have an even ID number. Print the results
in any order, but exclude duplicates from the answer.*/

select distinct(CITY) from STATION where ID%2=0

/*9. Find the difference between the total number of CITY entries in the table and the number of
distinct CITY entries in the table.
*/

select count(CITY) - count(distinct(CITY)) from STATION

/*10.Query the two cities in STATION with the shortest and longest CITY names, as well as their
respective lengths (i.e.: number of characters in the name). If there is more than one smallest or
largest city, choose the one that comes first when ordered alphabetically.*/

select final.CITY from
(select CITY , LENGTH(CITY) len_name,
      RANK() OVER (
        PARTITION BY LENGTH(CITY)
      ORDER BY LENGTH(CITY),CITY
      ) r
from STATION,
(select max(LENGTH(CITY)) max_length,min(LENGTH(CITY)) min_length from STATION) len
where LENGTH(CITY) = len.max_length or LENGTH(CITY) = len.min_length) final
where final.r =1


/*11. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION.
 Your result cannot contain duplicates.*/


select distinct(CITY) from STATION where CITY LIKE 'A%' or CITY LIKE 'E%' 
or CITY LIKE 'I%'  or CITY LIKE 'O%' or CITY LIKE 'U%'



/*12. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION*/
select distinct(CITY) from STATION where CITY LIKE '%a' or CITY LIKE '%e' 
or CITY LIKE '%i'  or CITY LIKE '%o' or CITY LIKE '%u'


/*13. Query the list of CITY names from STATION that do not start with vowels*/

select distinct(CITY) from STATION where CITY NOT LIKE 'A%' or CITY NOT LIKE 'E%' 
or CITY NOT LIKE 'I%'  or CITY NOT LIKE 'O%' or CITY NOT LIKE 'U%'

/*.14.  Query the list of CITY names from STATION that do not end with vowels*/

select distinct(CITY) from STATION where CITY NOT LIKE '%a' or CITY NOT LIKE '%e' 
or CITY NOT LIKE '%i'  or CITY NOT LIKE '%o' or CITY NOT LIKE '%u'

/*15. Query the list of CITY names from STATION that either do not start with vowels or do not end
with vowels*/

select distinct(CITY) from STATION where 
(CITY NOT LIKE 'A%' or CITY NOT LIKE 'E%' 
or CITY NOT LIKE 'I%'  or CITY NOT LIKE 'O%' or CITY NOT LIKE 'U%' )

OR

(CITY NOT LIKE '%a' or CITY NOT LIKE '%e' 
or CITY NOT LIKE '%i'  or CITY NOT LIKE '%o' or CITY NOT LIKE '%u')


/*16. Query the list of CITY names from STATION that do not start with vowels and do not end with
vowels.*/

select distinct(CITY) from STATION where 
(CITY NOT LIKE 'A%' or CITY NOT LIKE 'E%' 
or CITY NOT LIKE 'I%'  or CITY NOT LIKE 'O%' or CITY NOT LIKE 'U%' )

AND

(CITY NOT LIKE '%a' or CITY NOT LIKE '%e' 
or CITY NOT LIKE '%i'  or CITY NOT LIKE '%o' or CITY NOT LIKE '%u')



/*q17. Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is,
between 2019-01-01 and 2019-03-31 inclusive */ 

CREATE TABLE PRODUCT (
    PRODUCT_ID INT,
    PRODUCT_NAME VARCHAR(17),
    UNIT_PRICE INT,
    PRIMARY KEY(PRODUCT_ID)
) ENGINE=InnoDB;

CREATE TABLE SALES (
    SELLER_ID INT,
    PRODUCT_ID INT,
    BUYER_ID INT,
  	SALE_DATE DATE,
    QUANTITY INT,
    PRICE INT,
    FOREIGN KEY(PRODUCT_ID) references PRODUCT(PRODUCT_ID)
) ENGINE=InnoDB;



WITH PROD_SPRING AS (SELECT P.PRODUCT_ID , PRODUCT_NAME , SALE_DATE
	FROM PRODUCT P ,SALES S 
    WHERE P.PRODUCT_ID = S.PRODUCT_ID
    AND S.SALE_DATE BETWEEN "2019-01-01"  AND "2019-03-31")
    
    select PRODUCT_ID,PRODUCT_NAME from PROD_SPRING P
	where SALE_DATE =(select max(SALE_DATE) from SALES group by PRODUCT_ID having 
                      PRODUCT_ID=P.PRODUCT_ID)



/*Q18. Write an SQL query to find all the authors that viewed at least one of their own articles.
Return the result table sorted by id in ascending order.*/

CREATE TABLE views (
    article_id INT,
    author_id INT,
    viewer_id INT,
  	view_date DATE
) ;




insert into views  (
    article_id ,
    author_id ,
    viewer_id ,
  	view_date 
)  VALUES
(3 ,4 ,4 ,"2019-07-21")



select distinct(author_id) from views
	where author_id = viewer_id
     ORDER BY author_id



/*Q19 Write an SQL query to find the percentage of immediate orders in the table, rounded to 2 decimal
places*/


CREATE TABLE delivery (
    delivery_id INT,
    customer_id INT,
    order_date DATE,
  	customer_pref_delivery_date DATE,
  	PRIMARY KEY (delivery_id)
) ;


select round((imm.imm_count/ total.total_count) * 100,2) from
(select count(*) total_count from delivery) total,
    (select count(delivery_id) imm_count
	from delivery
    where order_date = customer_pref_delivery_date) imm



/*q20.*/


CREATE TABLE ads (
    ad_id INT,
    user_id INT,
    action ENUM ('Clicked', 'Viewed', 'Ignored'),
    PRIMARY KEY(ad_id,user_id)
);


select ad_id , IFNULL(
 round( (
    sum(check_ad.action_check) / count(check_ad.action_check)
  )*100,2)
  ,0) CTR
  
  from

(select ad_id,action,
 CASE when action = "Clicked" then 1
 		when ACTION = "Viewed" then 0
        else null end as action_check
from ads) check_ad

GROUP BY check_ad.ad_id

ORDER BY CTR DESC , ad_id


/*q21.Write an SQL query to find the team size of each of the employees. */

CREATE TABLE employee (
    employee_id INT,
    team_id INT,
    PRIMARY KEY(employee_id)
);


insert into  employee (
    employee_id ,
    team_id 
) VALUES
(6,9);


select e.employee_id , t.team_size 
from employee e,
(select count(team_id) team_size,team_id from employee
GROUP BY team_id ) t
where e.team_id = t.team_id


/*q22.*/

create table if not EXISTS countries(
  country_id INT,
  country_name VARCHAR(50),
  PRIMARY KEY(country_id)
);

create table if not EXISTS weather(
  country_id INT,
  weather_state INT,
  day DATE,
  PRIMARY KEY(country_id,day)
);


/*Write an SQL query to find the type of weather in each country for November 2019.
The type of weather is:
● Cold if the average weather_state is less than or equal 15,
● Hot if the average weather_state is greater than or equal to 25, and
● Warm otherwise.
Return result table in any orde*/


select case 
			when avg(weather_state) <= 15 then "COLD" 
            when avg(weather_state) >= 25 then "HOT" else "Warm" END  type


,c.country_id,country_name from weather w , countries c
where 
day BETWEEN "2019-11-01"  AND  "2019-11-30"
and w.country_id = c.country_id
group by country_id



/*Q23.write an SQL query to find the average selling price for each product. average_price should be
rounded to 2 decimal places. Return the result table in any order. */

create table if not exists prices
(
	product_id INT,
    start_date DATE,
    end_date DATE,
    price int,
    PRIMARY KEY(product_id, start_date, end_date)
);

create table if not exists unitssold
(
	product_id INT,
    purchase_date DATE,
    units int
);




select p.product_id ,
round(sum(units*price)/sum(units),2) as average_price
from prices p ,unitssold u
where 
	p.product_id = u.product_id
    and u.purchase_date BETWEEN p.start_date  AND  p.end_date
    
    GROUP BY product_id




/*q24. */

create table if not exists activity
(
  player_id int,
  device_id int,
  event_date DATE,
  games_played int,
  PRIMARY KEY(player_id, event_date)
);

select player_id,min(event_date) from activity
GROUP BY player_id





/*Q25.Write an SQL query to report the device that is first logged in for each player.
Return the result table in any order. */

select player_id,min(device_id) from activity
GROUP BY player_id


