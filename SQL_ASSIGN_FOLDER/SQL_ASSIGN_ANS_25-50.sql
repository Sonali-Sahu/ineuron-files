show DATABASES


use mysql

/*q.26.Write an SQL query to get the names of products that
 have at least 100 units ordered in February 2020
and their amount. Return result table in any order */

create table if not EXISTS products(
	product_id int,
    product_name varchar(100),
    product_category varchar(100),
  	PRIMARY KEY(product_id)
);



create table if not exists orders(
	product_id int,
order_date date,
unit int,
  FOREIGN KEY(product_id) references products(product_id)
);


insert into orders(
	product_id,
order_date ,
unit
) VALUES
(5 ,"2020-03-01", 50);


select product_name ,sum(unit) from products p ,orders o
where p.product_id = o.product_id
and o.order_date BETWEEN "2020-02-01"  AND "2020-02-29"

GROUP BY p.product_id
having sum(unit) >=100




/*q.27.Write an SQL query to find the users who have valid emails.
A valid e-mail has a prefix name and a domain where:
● The prefix name is a string that may contain letters 
(upper or lower case), digits, underscore
'_', period '.', and/or dash '-'. The prefix name must start with a letter.
● The domain is '@leetcode.com'.
Return the result table in any orde */

create table if not exists users
(
	user_id int,
    name varchar(30),
    mail varchar(50),
    PRIMARY KEY(user_id)
);


insert into users
(user_id,name,mail) VALUES
(7 ,"Shapiro"," .shapo@leetcode.com");


select * from users
    where mail regexp '^[a-zA-Z]+[a-zA-Z0-9_\\./\\-]{0,}@leetcode.com$'
    order by user_id;




/*q.28. Write an SQL query to report the customer_id and customer_name 
of customers who have spent at
least $100 in each month of June and July 2020.
Return the result table in any order */  


create table if not exists customers
(
	customer_id int,
    name varchar(30),
    country varchar(30),
  PRIMARY KEY(customer_id)
);

create table if not exists product
(
	product_id int,
	description varchar(30),
	price int,
  PRIMARY KEY(product_id)
);

create table if not exists orders
(
	order_id int,
customer_id int,
product_id int,
order_date date,
quantity int,
  PRIMARY KEY(order_id)
);


with temp as
(select c.customer_id,NAME  , sum(price*quantity) amount , month(order_date)
from customers c , orders o , product p
where c.customer_id = o.customer_id
and p.product_id = o.product_id
and month(o.order_date) in(6,7)
GROUP BY c.customer_id, name , month(order_date)
 
having sum(price*quantity)>=100
) 

select customer_id , name from temp
GROUP BY customer_id
having count(*) = 2


/*q.29. Write an SQL query to report the
 distinct titles of the kid-friendly movies streamed in June 2020. */
create table if not exists TVProgram
(
	program_date date,
content_id int,
channel varchar(30),
  PRIMARY KEY(program_date, content_id)
);


insert into TVProgram
(
	program_date ,
content_id ,
channel 
) VALUES
(
"2020-07-15 16:00" ,5 ,"Disney Ch"
);

create table if not exists Content
(
	content_id int,
title varchar(30),
Kids_content enum ("Y","N"),
content_type varchar(30),
  PRIMARY KEY(content_id)
);


insert into Content
(
	content_id ,
title ,
Kids_content,
content_type
) VALUES(
5 ,"Cinderella","Y", "Movies"
)

select title from TVProgram t , Content c
where month(program_date) = 6
and t.content_id = c.content_id
and kids_content like "Y"



/*q.30. Write an SQL query to find the npv
of each query of the Queries table.*/


create table if not exists NPV
(
	id int,
year int,
npv int,
  PRIMARY KEY(id, year)
);


Table: Queries
Column Name Type
id int
year int
(id, year) is the primary key of this table.


select q.id,q.year , IFNULL(npv,0) from
Queries q
left join
NPV n 

on n.id = q.id
and  n.year = q.year




/*q.31. */

select q.id,q.year , IFNULL(npv,0) from
Queries q
left join
NPV n 

on n.id = q.id
and  n.year = q.year



/*q.32. Write an SQL query to show the unique ID of each user,
 If a user does not have a unique ID replace just
show null.
Return the result table in any orde*/

create table employees(
	id int,
name varchar(30),
  PRIMARY KEY(id)
);


create table EmployeeUNI(
	id int,
unique_id int,
  PRIMARY KEY(id,unique_id)
);


select em.unique_id,e.name from 
employees  e  left join EmployeeUNI em
on e.id = em.id





/*q.33.Write an SQL query to report the distance travelled by each user. */


create table users
(
	id int,
    name varchar(30),
    PRIMARY KEY(id)
);


create table Rides
(
	id int,
   user_id int,
distance int,
    PRIMARY KEY(id)
);


select u.name , IFNULL(sum(distance),0) from
 users u left join Rides r 

on u.id = r.user_id 
GROUP BY u.id
order by sum(distance) desc ,name



/*q.34*/

create table Products
(
	product_id int,
product_name varchar(20),
product_category varchar(20),
    PRIMARY KEY(product_id)
);


create table Orders(
product_id int,
order_date date,
unit int,
foreign key(product_id) references Products(product_id)
);




-- ORDERS TABLE DATA IS NOT GIVEN IN THIS QUESTIONS


/*q35.Write an SQL query to:
● Find the name of the user who has rated the greatest number of movies. In case of a tie,
return the lexicographically smaller user name.
● Find the movie name with the highest average rating in February 2020. In case of a tie, return
the lexicographically smaller movie name */





create table  Movies
(
	movie_id int,
title varchar(20),
    PRIMARY KEY(movie_id)
);

create table  Users
(
	user_id int,
name varchar(20),
    PRIMARY KEY(user_id)
);
create table  MovieRating
(
	movie_id int,
user_id int,
rating int,
created_at date,
    PRIMARY KEY(movie_id, user_id)
);



SELECT u.name
FROM Users u left join MovieRating mr 
ON u.user_id = mr.user_id
GROUP BY name
ORDER BY count(mr.rating) DESC ,name LIMIT 1;



SELECT title , avg(mr.rating)
FROM Movies m inner join MovieRating mr 
ON m.movie_id = mr.movie_id
GROUP BY title
ORDER BY avg(mr.rating) DESC ,title LIMIT 1;



/*q.36.Write an SQL query to report the distance travelled by each user.
Return the result table ordered by travelled_distance in descending order, if two or more users
travelled the same distance, order them by their name in ascending order. */

create table  Users
(
	id int,
name varchar(20),
    PRIMARY KEY(id)
);


create table Rides
(
	id int,
   user_id int,
distance int,
    PRIMARY KEY(id)
);




select u.name , IFNULL(sum(distance),0) from
 users u left join Rides r 

on u.id = r.user_id 
GROUP BY u.id
order by sum(distance) desc ,name






/*q.37. Write an SQL query to show the unique ID of each user, 
If a user does not have a unique ID replace just
show null.*/

select em.unique_id,e.name from 
employees  e  left join EmployeeUNI em
on e.id = em.id

/*q.38. Write an SQL query to find the id and the name of 
all students who are enrolled in departments that no longer exist.
*/

create table Departments
(
	id int,
name varchar(30),
    PRIMARY KEY(id)
);

create table Students
(
	id int,
name varchar(30),
  department_id int,
    PRIMARY KEY(id)
);


select s.id,s.name
from Departments d right join Students s
on d.id=s.department_id
where d.name is null;

/*q.39.Write an SQL query to report the number of calls and 
the total call duration between each pair of
distinct persons (person1, person2) where person1 < person2.
 */
create table Calls(
from_id int,
to_id int,
duration int
);


select from_id  person1 ,to_id  person2,
count(*)  call_count,sum(duration)  total_duration
from
(
select * from Calls
union all
select to_id,from_id,duration from Calls
)s
where from_id < to_id
group by person1 ,person2;


/*q.40. Write an SQL query to find the average selling price
 for each product. average_price should be rounded to 2 decimal places*/


select p.product_id ,
round(sum(units*price)/sum(units),2) as average_price
from prices p ,unitssold u
where 
	p.product_id = u.product_id
    and u.purchase_date BETWEEN p.start_date  AND  p.end_date
    
    GROUP BY product_id


/*q.41. Write an SQL query to report the number of cubic feet of volume
 the inventory occupies in each warehouse.*/    

create table warehouse(
name varchar(30),
product_id int,
units int,
primary key(name, product_id)
);


create table products3(
product_id int,
product_name varchar(30),
width int,
length int,
height int,
primary key(product_id)
);

select w.name  warehouse_name,
sum(w.units*p.width*p.length*p.height)  volume

from warehouse w left join products3 p

on w.product_id=p.product_id
group by w.name; 

/*q.42.rite an SQL query to report the difference between
 the number of apples and oranges sold each day. */


create table sales(
sale_date date,
fruit varchar(30),
sold_num int,
primary key(sale_date, fruit)
);


with temp as(
      select * ,
		    case when fruit='oranges' then -1*sold_num else sold_num end  gp_num
        from sales1
        )
        select sale_date,sum(gp_num)  diff from temp 
        group by sale_date
        order by sale_date;


/*q.43.Write an SQL query to report the fraction of players that logged in again on the day after the day they
first logged in, rounded to 2 decimal places. In other words, you need to count the number of players
that logged in for at least two consecutive days starting from their first login date, then divide that
number by the total number of players.
 */


create table activity(
player_id int,
device_id int,
event_date date,
games_played int,
primary key(player_id, event_date)
);


with temp as(
select player_id,event_date  curr_date,
lead(event_date) over(partition by player_Id order by event_date)  next_date
from activity
)
select 
round(100.0*count
(distinct case when datediff(next_date,curr_date)=1 then 1 else null end)
/count(distinct player_id),2)  fraction
from temp;



/*q.44. Write an SQL query to report the managers with at least five direct reports*/

create table employee(
id int ,
name varchar(30),
department varchar(30),
manager_id int,
primary key(id)
);


with temp as(
select e.id,e.name ,m.id  manager_id,m.name  manager_name 
from employee e 
left	 join employee m
on m.id=e.manager_id 
where e.manager_id is not null
)
select manager_name as name from temp
group by manager_name having count(*)>=5;



/*q.45.Write an SQL query to report the respective department name and number of students majoring in
each department for all departments in the Department table (even ones with no current students).
Return the result table ordered by student_number in descending order. In case of a tie, order them by
dept_name alphabetically.
 */



 reate table student(
student_id int,
student_name varchar(30),
gender varchar(30),
dept_id int,
primary key(student_id)
);
create table department(
dept_id int,
dept_name varchar(30),
primary key(dept_id)
);


select d.dept_name,count(student_name)  student_numbers
from department d left join student s
on d.dept_id=s.dept_id
group by d.dept_name
order by student_numbers desc,dept_name;



/*q.46. Write an SQL query to report the customer ids from the Customer table that bought all the products in
the Product table.
*/

create table customer(
customer_id int,
product_key int,
foreign key (product_key) references product(product_key)
);
create table product(
product_key int,
primary key(product_key)
);


with temp as(
select c.customer_id,p.product_key,
count(p.product_key)  pro_count
from product p left join customer c 
on p.product_key=c.product_key
group by c.customer_id
)
select customer_id from temp 
where 
pro_count = (select count(*) from product);


/*q.47. Write an SQL query that reports the most experienced employees in each project. In case of a tie,
report all employees with the maximum number of experience years.*/



create table project(
project_id int,
employee_id int,
primary key(project_id,employee_id),
foreign key(employee_id) references employee(employee_id)
);
create table employee(
employee_id int,
name varchar(30),
experience_years int,
primary key(employee_id)
);



with temp as(
select p.project_id,p.employee_id,e.experience_years
from project p left join employee e
on p.employee_id=e.employee_id
)
select project_id,employee_id from temp c
where experience_years = 
(select max(experience_years) from cte where project_id = c.project_id group by project_id)
order by project_id; 



/*q.48. Write an SQL query that reports the books that have sold less than 10 copies in the last year,
excluding books that have been available for less than one month from today. Assume today is
2019-06-23.*/



create table books(
book_id int,
name varchar(30),
available_from date,
primary key(book_id)
);



create table orders(
order_id int,
book_id int,
quantity int,
dispatch_date date,
primary key(order_id),
foreign key(book_id) references books(book_id)
);


--- DOnt know how to solve IT





/*q.49.Write a SQL query to find the highest grade with its corresponding course for each student. In case of
a tie, you should find the course with the smallest course_id.
Return the result table ordered by student_id in ascending order. */

create table enrollments(
student_id int,
course_id int,
grade int,
primary key(student_id,course_id)
);

select student_id,course_id,grade 
from(
select *,rank() over(partition by student_id order by grade desc,course_id) rn 
from enrollments
)a
where rn=1
order by student_id;



/*q.50. Write an SQL query to find the winner in each group.
Return the result table in any order*/


-- doesn't hold any relation between 2 tables
