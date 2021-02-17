CREATE DATABASE GiraffeCourse;
USE GiraffeCourse;

-- create tables

CREATE TABLE employee(
	employee_id INT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    birth_day DATE,
    sex VARCHAR(1),
    salary INT,
    supervisor_id INT,
    branch_id INT    
);

ALTER TABLE employee 
RENAME COLUMN birth_day TO birth_date;

CREATE TABLE branch (
	branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    manager_id INT,
    manager_start_date DATE,
    FOREIGN KEY (manager_id) REFERENCES employee(employee_id) ON DELETE SET NULL
);

ALTER TABLE employee 
ADD FOREIGN KEY(branch_id) 
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(supervisor_id)
REFERENCES employee(employee_id)
ON DELETE SET NULL;

CREATE TABLE client (
	client_id INT PRIMARY KEY,
    client_name VARCHAR(40), 
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
	employee_id INT,
    client_id INT,
    total_sales INT, 
    PRIMARY KEY(employee_id, client_id),
    FOREIGN KEY(employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier(
	branch_id INT,
    supplier_name VARCHAR(40),
    supply_type VARCHAR(40),
    PRIMARY KEY(branch_id, supplier_name),
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

-- (employee, branch) table data entry

INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE employee_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE employee_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE employee_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);

SELECT * FROM employee;
SELECT * FROM branch;

-- branch supplier table data entry

INSERT INTO branch_supplier VALUES(2, 'Hammer Hill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Hill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Labels', 'Custome Labels');

SELECT * FROM branch_supplier;

-- client table data entry

INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Lax, LCC', 3);

UPDATE client
SET client_name = 'John Daly Lax, LLC'
WHERE client_id = 403;

INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

SELECT * FROM client;

-- works_with table data entry

INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

-- QUERIES: --------------------------

-- find out TOP 3 best payed employees 		
SELECT first_name AS Forename, last_name AS Lastname
FROM employee
ORDER BY salary DESC
LIMIT 3;

-- find out supplies types
SELECT DISTINCT supply_type	
FROM branch_supplier
ORDER BY supply_type;

-- find the number of employees	
SELECT COUNT(employee_id)
FROM employee;

-- find the number of female employees born after 1970
SELECT COUNT(employee_id)
FROM employee
WHERE sex = 'F' AND birth_date > '1970-01-01';

-- find the average of all male employees salaries
SELECT AVG(salary)
FROM employee
WHERE sex = 'M';

-- find the sum of all  employees salaries
SELECT SUM(salary)
FROM employee;

-- find how many males and females
SELECT sex AS 'employee gender', COUNT(sex) AS quantity
FROM employee
GROUP BY sex;

-- find total sales of each salesman	
SELECT employee_id, SUM(total_sales)
FROM works_with
GROUP BY employee_id;

-- find out MIN and MAX sale amount and salesman  ** CODE BY FJ ;) **

SELECT MIN(total_sales) AS 'min & max sales', employee_id
FROM works_with
WHERE total_sales = (
	SELECT  MIN(total_sales)
	FROM works_with
)
UNION
SELECT MAX(total_sales), employee_id
FROM works_with
WHERE total_sales = (
	SELECT  MAX(total_sales)
	FROM works_with
);

SELECT e.first_name, e.last_name, w.total_sales
FROM employee AS e, works_with AS w
WHERE w.total_sales = 5000 OR w.total_sales = 267000
LIMIT 2;

-- how much money each client spent on each brand
SELECT client_id, SUM(total_sales)
FROM works_with
GROUP BY client_id;

-- find any client who are in LLC

SELECT *
FROM client
WHERE client_name LIKE '%LLC';

-- find branch suppliers that are in label business

SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '%Label%';

-- find any employee born in october

SELECT employee_id, birth_date
FROM employee
WHERE birth_date LIKE '%-10-%';
-- other option  WHERE birth_date LIKE '____-10-%';

-- find if any client is a school 
SELECT *
FROM client
WHERE client_name LIKE '%school%';

-- find a list of all clients & branch supplier's names

SELECT client_name AS 'clients & branch supplier''s names', client.branch_id
FROM client
UNION
SELECT supplier_name, branch_supplier.branch_id
FROM branch_supplier;

-- new value in branch table
INSERT INTO branch VALUES(4, 'Buffalo', NULL, NULL);

-- find all branches and the names of their managers
SELECT employee.employee_id, employee.first_name AS manager_name, branch.branch_name
FROM employee
INNER JOIN branch -- also just JOIN would do
ON employee.employee_id = branch.manager_id;

-- find names of all employees who have sold over 30,000 to a single client

SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.employee_id IN (
	SELECT works_with.employee_id
	FROM works_with
	WHERE works_with.total_sales > 30000
);

-- Find all clients who are handled by the branch that Michael Scott manages
-- Michael´s ID is #102

SELECT client.client_name
FROM client
WHERE client.branch_id = (
	SELECT branch.branch_id
	FROM branch
	WHERE branch.manager_id = 102 
    LIMIT 1
);

-- Trigger --------------------------

CREATE TABLE trigger_test(
	message VARCHAR(100)
);

-- executing this in "MySQL command line client" shell 
-- input must be 
-- use giraffecourse * enter * DELIMITER $$ * enter * code * enter * delimiter ; * enter

DELIMITER $$
CREATE 
     TRIGGER my_trigger BEFORE INSERT
     ON employee
     FOR EACH ROW BEGIN
          INSERT INTO trigger_test VALUES('added new employee');
     END$$
DELIMITER ;

-- testing trigger
INSERT INTO employee 
VALUES(109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);

-- other trigger

DELIMITER $$
CREATE
     TRIGGER my_trigger1 BEFORE INSERT
     ON employee
     FOR EACH ROW BEGIN
          INSERT INTO trigger_test VALUES(NEW.first_name);
     END$$
DELIMITER ;

INSERT INTO employee
VALUES(110, 'Kevin', 'Malone', '1978-02-19', 'M', 88000, 106, 3);

-- last trigger, more complex one..

DELIMITER $$
CREATE
    TRIGGER my_trigger2 BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        IF NEW.sex = 'M' THEN
            INSERT INTO trigger_test VALUES('added male employee');
	    ELSEIF NEW.sex = 'F' THEN
            INSERT INTO trigger_test VALUES('added female employee');
	    ELSE
            INSERT INTO trigger_test VALUES('added other employee');
        END IF;
	END$$
DELIMITER ;
    
INSERT INTO employee
VALUES(111, 'Pam', 'Beesly', '1988-02-19', 'F', 101000, 106, 3);

SELECT * FROM trigger_test;

DROP TRIGGER my_trigger; -- on terminal




