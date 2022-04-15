---------
--SUBQUERIES
-----------
SELECT E1.ssn, E1.ename
  FROM Emp as E1, Emp as E2
 WHERE E2.ename = 'Jack' 
   AND E1.dno = E2.dno

SELECT ssn,ename
  FROM Emp
 WHERE dno IN
    	(SELECT dno
	      FROM Emp
	     WHERE ename = 'Jack')

---------
--List departments which has employees with salaries more than 60K
SELECT dno,dname
  FROM Emp E1, Dept D
 WHERE E1.dno=D.dno 
   AND sal>60000;

SELECT dno,dname
  FROM Dept
 WHERE dno IN
   	( SELECT dno                              	
	      FROM Emp			
	     WHERE sal>60000); 
      

---------
--List the department names which has more than 2 employees
  SELECT Emp.dno
    FROM Emp, Dept
   WHERE Emp.dno=Dept.dno
GROUP BY Emp.dno
  HAVING COUNT(ssn)>2;

SELECT dname, dno 
  FROM Dept 
 WHERE dno IN
     ( SELECT Dept.dno
         FROM Emp, Dept
        WHERE Emp.dno=Dept.dno
     GROUP BY Dept.dno
      HAVING COUNT(ssn)>2 );

-----------------------------------------------------------------------
-- Employees who work in both Purchasing department and HR department.
(SELECT  ename FROM Emp, Dept 
  WHERE Emp.dno=Dept.dno  AND dname = 'Purchasing')
INTERSECT
(SELECT  ename FROM Emp, Dept 
  WHERE Emp.dno=Dept.dno  AND dname ='HR');

-- We previously attempted to implement it as follows. The following does not work
SELECT E1.ename 
  FROM emp as E1, Dept as D1
 WHERE E1.dno = D1.dno 
   AND D1.dname = 'Purchasing' 
   AND D1.dname='HR';
    
-- alternative implementation of "intersect"
SELECT distinct E.ename 
  FROM emp E
 WHERE E.ssn IN 
        (SELECT ssn FROM Emp,Dept where Emp.dno=Dept.dno AND dname='Purchasing') 
   AND E.ssn IN 
        (SELECT ssn FROM Emp,Dept where Emp.dno=Dept.dno AND dname='HR');


-----------------------------------------------------------------------
-- Employees who work in Purchasing department but not in HR department.
(SELECT  ename FROM Emp, Dept 
  WHERE Emp.dno=Dept.dno  AND dname = 'Purchasing')
EXCEPT
(SELECT  ename FROM Emp, Dept 
  WHERE Emp.dno=Dept.dno  AND dname ='HR');

-- We previously attempted to implement it as follows. The following does not work
SELECT E1.ename 
  FROM emp as E1, emp as E2, Dept as D1, Dept as D2
 WHERE E1.ssn = E2.ssn 
   AND E1.dno = D1.dno 
   AND D1.dname = 'Purchasing' 
   AND E2.dno<>D2.dno 
   AND D2.dname='HR';
	  
-- alternative implementation of "except"
SELECT distinct E.ename 
  FROM emp E
 WHERE E.ssn IN 
      	(SELECT ssn FROM Emp,Dept where Emp.dno=Dept.dno AND dname='Purchasing') 
   AND E.ssn NOT IN 
        (SELECT ssn FROM Emp,Dept where Emp.dno=Dept.dno AND dname='HR');

-----------------------------------------------------------------------
--Find employee(s) with the highest salary
SELECT ename,max(sal)
  FROM Emp

SELECT distinct ename, sal 
  FROM emp
 WHERE sal >= ALL 
	    ( SELECT MAX(sal) 
  	      FROM   Emp );
-- OR 
SELECT distinct ename,
       ssn
  FROM Emp 
 WHERE sal >= ALL
    	( SELECT sal
	        FROM Emp
	       WHERE sal IS NOT NULL)

--------
--Who makes more than someone in the Hardware department?

SELECT ename,
       sal
  FROM Emp
 WHERE sal >= ANY
  		( SELECT sal
		      FROM Emp,  Dept
		     WHERE Emp.dno = Dept.dno 
           AND  Dept.dname = 'Hardware' 
           AND sal IS NOT NULL);

SELECT ename,
       sal
  FROM Emp 
 WHERE sal >= ALL
		 ( SELECT sal 
		     FROM Emp,  Dept
		    WHERE Emp.dno = Dept.dno 
          AND  Dept.dname = 'Hardware' 
          AND sal IS NOT NULL);
		
--------
--Who works in the 'Production' department?
SELECT ename,
       dno
  FROM Emp
 WHERE Emp.dno =
		(SELECT dno
		   FROM Dept
		  WHERE dname='Production');
         
-- We can have more than one attribute in the comparison
SELECT ename,
       dno
  FROM Emp
 WHERE (dno,ename)  IN
    (SELECT Emp.dno, Emp.ename
       FROM Dept, 
            Emp
      WHERE Dept.dno=Emp.dno
        AND dname='Production');

---------
--Employees who work on some project
SELECT distinct Emp.ssn, 
       ename 
  FROM projectEmp, Emp
 WHERE ProjectEmp.ssn=Emp.ssn;

SELECT * 
  FROM Emp
 WHERE ssn IN 
       ( SELECT ssn FROM projectEmp);


SELECT * 
FROM Emp as E
WHERE EXISTS 
      ( SELECT * 
          FROM projectEmp AS PE
         WHERE E.ssn = PE.ssn);


--Employees who doesnt work on any projects
SELECT * 
FROM Emp
WHERE ssn NOT IN (SELECT ssn FROM projectEmp);

SELECT * 
FROM Emp as E
WHERE NOT EXISTS (SELECT * FROM projectEmp PE
                   WHERE E.ssn = PE.ssn);
				   
-----------
--Find the employee with highest salary 
SELECT distinct ename, sal 
  FROM emp
 WHERE sal >= ALL 
     	( SELECT MAX(sal) 
	        FROM Emp);

SELECT distinct ename, sal 
  FROM Emp as E1
 WHERE NOT EXISTS 
           ( SELECT * 
               FROM Emp E2
              WHERE E1.sal < E2.sal) 
   AND E1.sal IS NOT NULL;

------------------------------------------------------------------------

---Employees that work on all projects
select * from proj
select * from projectemp where ssn='111-00-1111'

select ssn,count(proj_id)  from projectemp
group by ssn
order by ssn

--there shouldn't exsist a project that the employee doesn't work on
--1. Find the projects employee X works on
--2. Find the projects that doesnt exist in "1"
--3. if 2 is empty for employee X, include it in the result.

SELECT * 
  FROM Emp E
 WHERE NOT EXISTS 
       ( SELECT *
           FROM Proj
	        WHERE proj_id NOT IN 
     	          ( SELECT proj_id 
	 	                FROM ProjectEmp
		               WHERE ssn = E.ssn )  );

------------------------------------------------------------------------

--SUBQUERIES in FROM

--T00tal salary and number of employees for each department. 
  SELECT dno, 
         SUM(sal) as totalSal, 
         COUNT(ename) as numEmp
    FROM Emp
GROUP BY dno
  HAVING COUNT(ssn)>1;

  SELECT Temp.dno, 
         Temp.totalSal, 
         Temp.numEmp
    FROM  ( SELECT dno, 
                   SUM(sal) as totalSal , 
                   COUNT(ename) as numEmp
	            FROM Emp
	        GROUP BY dno ) AS Temp
   WHERE Temp.numEmp > 1;

----
--List the dno, total salary, and number of employees for all departments with more than one employee.
SELECT ssn, 
       ename, 
       dno, 
       (sal*1.1+5000) as newsal
  FROM Emp 
 WHERE (sal*1.1+5000)< 65000;

SELECT * 
  FROM ( SELECT ssn, 
                ename, 
                dno, 
                (sal*1.1+5000) as newsal
	       FROM Emp) as newEmp
 WHERE newEmp.newsal>65000;

 -----
--Find the employees in the departments whose total salary amount is more than $200K
--- find the total salary in each department
--- return those whose total salary is > 200K
SELECT Emp.ename
  FROM Emp
 WHERE Emp.dno IN 
            ( SELECT dno
	              FROM Emp
	          GROUP BY dno
	            HAVING SUM(sal) >200000);
SELECT Emp.ename
  FROM ( SELECT dno, 
                SUM(sal) as totalSal 
	         FROM Emp
	     GROUP BY dno ) AS Temp, Emp
WHERE Temp.dno=Emp.dno  AND Temp.totalSal>200000;

------
--Find the department names that has the max total salary amount among all departments
-- 1. find the total sal in each dept
-- 2. find the max among the total sal.

	SELECT dno, SUM(sal) as totalSal 
	  FROM Emp
	GROUP BY dno;


SELECT  MAX(Temp.totalSal)
  FROM (  SELECT dno, 
                 SUM(sal) as totalSal 
	          FROM Emp
	      GROUP BY dno) AS Temp;

SELECT *
  FROM ( SELECT dno, 
                SUM(sal) as totalSal 
	         FROM Emp
	     GROUP BY dno) as Temp2
 WHERE totalSal = 
	     	   (SELECT max(Temp1.totalSal)
		          FROM (   SELECT dno, SUM(sal) as totalSal 
		 	                   FROM Emp
			               GROUP BY dno) as Temp1 )
	
-- Alternatively, we may store the Temp2 data in the above query to a table and run the following.   
	SELECT *
    FROM SalTotal
	 WHERE totalSal = 
	       	( SELECT max(Temp1.totalSal)
		          FROM SalTotal)

-------
--“Find the employees whose salary is greater than overall average salary”.
SELECT *
  FROM Emp E
 WHERE sal > 
		 ( SELECT AVG(sal) 
		     FROM Emp E2);

-- “Find the employees whose avg salary is greater than the average salary in the department they work in”.
SELECT *
  FROM Emp E1
 WHERE sal > 
  		( SELECT AVG(sal) 
		      FROM Emp E2
         WHERE E1.dno = E2.dno );
         
select dno,avg(sal) from emp
group by dno;


---------------------------------------------------------------------------------------------------------

-- Additional SQL Subquery Examples:
   
   
-- Schema
--Suppliers(sid, sname, address)  
--Parts(pid, pname, color)  
--Catalog(sid, pid, cost)

--Query 1: “Find the distinct  “sids” of suppliers who charge more for some part 
--than the average cost of that part 
--(averaged over all the suppliers who supply that part)”.

SELECT distinct sid
  FROM Catalog as C1
 WHERE cost > 
   	   ( SELECT avg(cost)
           FROM Catalog as C2
	        WHERE C1.pid=C2.pid
       GROUP BY pid )
	 
	 
--Suppliers(sid, sname, address)  
--Parts(pid, pname, color)  
--Catalog(sid, pid, cost)

--Query 2: “Find the distinct “sids” of suppliers who supply only red parts”.

SELECT distinct C.sid
  FROM Catalog C1, Parts P1
 WHERE C1.pid = P1.pid 
   AND P1.color='Red' 
   AND NOT EXISTS 
          ( SELECT * FROM Catalog C2, Parts P2
             WHERE C2.pid=P2.pid 
               AND P2.color<>'Red' 
               AND C1.sid=C2.sid );
                         
SELECT distinct sid
  FROM Catalog 
 WHERE sid IN 
  	  ( SELECT sid 
          FROM Catalog C1, Parts P1
         WHERE C1.pid=P1.pid 
           AND P1.color='Red' ) 
   AND sid NOT IN 
	    ( SELECT sid 
          FROM Catalog C2, Parts P2
         WHERE C2.pid=P2.pid 
           AND P2.color<>'Red'); 

-- OR    
( SELECT sid 
    FROM Catalog C1, Parts P1
   WHERE C1.pid=P1.pid 
     AND P1.color='Red') 
EXCEPT
( SELECT sid 
    FROM Catalog C2, Parts P2
   WHERE C2.pid=P2.pid 
     AND P2.color<>'Red'); 
           