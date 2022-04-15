-- Selection examples 
SELECT  ename
  FROM  Emp
 WHERE  dno=132;


SELECT  mgr
  FROM  Dept
 WHERE  dname = 'Marketing';

SELECT  *
  FROM  Emp
 WHERE  ename = 'Jack' 
   AND  sal>50000;

-----------------------------------------------------------------

-- Theta/Equi join examples
SELECT  *
  FROM  Emp, Dept
 WHERE  Emp.dno = Dept.dno;

SELECT  *
  FROM  Emp, Dept, ProjectEmp, Proj
 WHERE  Emp.dno = Dept.dno 
   AND  Emp.ssn = ProjectEmp.ssn 
   AND  ProjectEmp.proj_id = Proj.proj_id;

SELECT  Emp.ename, 
        Dept.dno, 
        Proj.ptitle
  FROM  Emp, Dept, ProjectEmp, Proj
 WHERE  Emp.dno = Dept.dno 
   AND  Emp.ssn = ProjectEmp.ssn 
   AND  ProjectEmp.proj_id = Proj.proj_id;

SELECT  distinct  dno
  FROM  Emp;

SELECT  ename, 
        mgr
  FROM  Emp, Dept
 WHERE  Emp.dno = Dept.dno 
   AND  mgr ='Alice';

SELECT  ename, 
        mgr as manager
  FROM  Emp, Dept
 WHERE  Emp.dno = Dept.dno 
   AND  manager='Alice';

-----------------------------------------------------------------

-- Renaming attributes
SELECT  ename,dno, 'temporary' as status
  FROM  Emp
 WHERE  sal<50000;  


SELECT  ename, sal
  FROM  Emp
 WHERE  ename='O''Fallon';

SELECT  eNaMe, sal*1.05 as newSalary
  FROM  Emp
 WHERE  ename='O''Fallon';

-----------------------------------------------------------------

-- Renaming relations

--employees who make more money than their manager
SELECT  E1.ename, 
        D.dname,
        E1.sal, 
        D.mgr, 
        E2.sal as manager_sal
  FROM  Emp as E1, Dept as D, Emp as E2
 WHERE  E1.dno = D.dno 
   AND  D.mgr = E2.ename 
   AND  E1.sal > E2.sal;

			 
-- Employees who earn the same salary
-- in the below query we get each pair twice   
SELECT  E1.ssn, 
        E1.ename, 
        E1.sal, 
        E2.ssn, 
        E2.ename, 
        E2.sal
  FROM  Emp as E1, Emp as E2
 WHERE  E1.sal = E2.sal 
   AND  E1.ssn<>E2.ssn;

-- Employees who earn the same salary - CORRECTED
-- in the below query we get each pair once only
SELECT  E1.ssn, 
        E1.ename, 
        E1.sal, 
        E2.ssn, 
        E2.ename, 
        E2.sal
  FROM  Emp as E1, Emp as E2
 WHERE  E1.sal = E2.sal AND E1.ssn < E2.ssn;


--the employees who work on the same project as their manager        
SELECT  E1.ename, 
        D.dname, E2.ename, PE1.proj_id, PE2.proj_id,P.ptitle
  FROM  Emp as E1, Dept D, Emp as E2, ProjectEmp as PE1, ProjectEmp as PE2, Proj as P
 WHERE  E1.dno = D.dno 
   AND  PE1.ssn = E1.ssn 
   AND  PE2.ssn = E2.ssn 
   AND  P.proj_id = PE1.proj_id
   AND  D.mgr = E2.ename AND E1.ename <> E2.ename  
   AND  PE1.proj_id = PE2.proj_id;

-----------------------------------------------------------------
-- Conditions on dates and strings
SELECT  *
  FROM 	Emp, Dept, ProjectEmp, Proj
 WHERE  Emp.dno = Dept.dno AND Emp.ssn = ProjectEmp.ssn AND ProjectEmp.proj_id = Proj.proj_id AND
		 ename >'J' AND sal < 70000 
         AND Proj.startdate> '1/1/2017' AND ptitle LIKE '%Software' AND ename <>'Mary';;

-----------------------------------------------------------------
-- Querying for NULL values
SELECT  ename, sal
  FROM  Emp
 WHERE  sal<=50K     
    OR  sal>50K; 

SELECT  ename, sal
  FROM  Emp
 WHERE  sal<=50000 
    OR  sal>50000 
    OR  sal is NULL; 

-----------------------------------------------------------------
-- Ordering 
  SELECT  *
    FROM  Emp
   WHERE  sal<=50000
ORDER BY  dno, sal desc, ename;

  SELECT  *
    FROM  Emp
   WHERE  sal<=50000 
      OR  sal IS NULL
ORDER BY  dno NULLS FIRST, sal desc, ename;

-----------------------------------------------------------------
--Set operations

-- Union 
-- eliminates duplicates in the result
(SELECT  ename FROM Emp, Dept 
  WHERE Emp.dno=Dept.dno  AND dname = 'Purchasing')
  UNION
(SELECT  ename FROM Emp, Dept 
  WHERE Emp.dno=Dept.dno  AND dname ='HR')
 
--Alternative implementation of the above query using joins
--have duplicates
SELECT  ename  
FROM Emp, Dept 
WHERE Emp.dno=Dept.dno  AND (dname = 'Purchasing' OR dname='HR');


-- Intersection
-- eliminates duplicates in the result
(SELECT  ename FROM Emp, Dept 
  WHERE Emp.dno=Dept.dno  AND dname = 'Purchasing')
  INTERSECT
(SELECT  ename FROM Emp, Dept 
  WHERE Emp.dno=Dept.dno  AND dname ='HR')
 
-- Can't implement intersection only using joins; we will implement an alternative intersection solution using nested queries. 
-- The below query will always return empty result
SELECT ename,
       dname  
  FROM Emp, Dept 
 WHERE Emp.dno=Dept.dno  
   AND (dname = 'Purchasing' AND dname='HR');


--NOT all systems support intersect operator. 
(SELECT  ename FROM Emp, Dept 
 WHERE Emp.dno=Dept.dno  AND dname = 'Purchasing')
EXCEPT
(SELECT  ename FROM Emp, Dept 
 WHERE Emp.dno=Dept.dno  AND dname ='HR')

-- Can't implement exept only using joins; we will implement an alternative except solution using nested queries. 
-- will not work.. will get additional results
SELECT  E1.ssn,E1.ename 
FROM Emp E1, emp E2
WHERE E1.ssn = E2.ssn AND E1.dno = 111 AND E2.dno<>888;

-- CAUITION!
-- When T is empty, the fourth query will return empty results. 
#1
SELECT   R.A FROM R
 intersect 
(    (SELECT   S.A FROM S)
      union	
      (SELECT   T.A FROM T)
);
#2
((SELECT   R.A FROM R) intersect (SELECT   S.A FROM S))
union	
((SELECT   R.A FROM R) intersect (SELECT   T.A FROM T));

#3
(SELECT   R.A FROM R, S  WHERE   R.A=S.A)
union
(SELECT   R.A FROM R, T WHERE   R.A=T.A);

#4
SELECT R.A
FROM   R,S,T
WHERE  R.A=S.A or R.A=T.A;

-----------------------------------------------------------------

--Aggregation (without grouping)
SELECT  MIN(sal), 
        MAX(sal), 
        AVG(sal)
  FROM  Emp, Dept
 WHERE  Emp.dno = Dept.dno  
   AND  Dept.dname = 'Marketing';


--output: relation with a single attribute with a single row
-- if no grouping the aggragate functions are applied to complete column. 
-- Except “count,” all aggregations apply to a single attribute
-- “Count” can be used on more than one attribute, even “*”

SELECT  COUNT(ename) FROM Emp;
SELECT  COUNT(*) FROM Emp;

SELECT  COUNT(distinct ename) FROM Emp;

SELECT  COUNT(distinct dno) FROM Emp;
------------
-- When there is grouping aggregate functions applied to attribute value in each group. 
  SELECT Dept.dno,
         SUM(sal), 
         COUNT(ename)
    FROM Emp, Dept
   WHERE Emp.dno = Dept.dno 
GROUP BY Dept.dno;

  SELECT Dept.dno,
         ename, 
         SUM(sal), 
         COUNT(ename)
    FROM Emp, Dept
   WHERE Emp.dno = Dept.dno 
GROUP BY Dept.dno,ename;

-----------------------------------------------------------------
-- Group by can be used to eliminate duplicates. 

  SELECT dno
    FROM Emp 
GROUP BY dno
ORDER BY dno;
--vs
  SELECT distinct dno
    FROM Emp 
ORDER BY dno;

  SELECT distinct dno,sal
    FROM Emp
ORDER BY dno;
-- vs
  SELECT dno,sal
    FROM Emp
GROUP BY dno,sal
ORDER BY dno;

-----------------------------------------------------------------

-- The conditions on the aggregate values are applied using HAVING clause.

--  The number of employees and total salary per department
  SELECT  Dept.dno, 
          SUM(sal), 
          COUNT(ssn)  
    FROM  Emp, Dept
   WHERE  Emp.dno = Dept.dno 
GROUP BY  Dept.dno;

--  The number of employees and total salary for departments with more than 2 employees
  SELECT  Dept.dno, 
          SUM(sal), 
          COUNT(ssn)  
    FROM  Emp, Dept
   WHERE  Emp.dno = Dept.dno 
GROUP BY  Dept.dno
  HAVING COUNT(ssn)>2;

-- helper query; for each project, we display the employees that work on that project and their departments.  
SELECT   proj_id, 
         Emp.ssn,Emp.dno
    FROM ProjectEmp, Emp    
   WHERE ProjectEmp.ssn = Emp.ssn 
ORDER BY proj_id

-- Projects with 7 or more employees.   
SELECT   proj_id, 
         COUNT(Emp.ssn) as count_emp
    FROM ProjectEmp, Emp    
   WHERE ProjectEmp.ssn = Emp.ssn 
GROUP BY proj_id
  HAVING COUNT(Emp.ssn) > 7
ORDER BY count_emp;

-- gives the same result as above. 
SELECT   proj_id, 
         COUNT(Emp.dno) as count_dno
    FROM ProjectEmp, Emp    
   WHERE ProjectEmp.ssn = Emp.ssn 
GROUP BY proj_id
  HAVING COUNT(Emp.dno) > 7
ORDER BY count_dno;

-- Projects with employees from at least 6 different departments.   

SELECT   proj_id, 
         COUNT(distinct Emp.dno) as count_dno
    FROM ProjectEmp, Emp    
   WHERE ProjectEmp.ssn = Emp.ssn 
GROUP BY proj_id
  HAVING COUNT(distinct Emp.dno) >= 6
ORDER BY count_dno;
  
---------
-- For each employee that works in two or more departments, print the total salary of his/her managers. 
  SELECT E1.ssn, 
         E1.ename,  
	     SUM(E2.sal)      			
    FROM Emp  E1, Dept, Emp  E2			
   WHERE E1.dno = Dept.dno  
     AND E2.ename = Dept.mgr 
GROUP BY E1.ssn,E1.ename      			       
  HAVING count(distinct(Dept.dno)) > 1      		       
ORDER BY E1.ssn,E1.ename; 


