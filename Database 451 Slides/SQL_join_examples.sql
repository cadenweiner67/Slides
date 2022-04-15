CREATE TABLE Sailors (
	sid INTEGER  PRIMARY KEY, 
	sname CHAR(20),
	rating INTEGER, 
	age INT)

CREATE TABLE Boats (
	bid INTEGER  PRIMARY KEY, 
	bname CHAR (20), 
	color CHAR(10) )

 CREATE TABLE Reserves (
	sid INTEGER, 
	bid INTEGER, 
	day DATE, 
  	PRIMARY KEY (sid, bid, day), 
	FOREIGN KEY (sid) REFERENCES Sailors, 
	FOREIGN KEY (bid) REFERENCES Boats)
)

------------------------
INSERT INTO Sailors VALUES(22,'Dustin',7,45);
INSERT INTO Sailors VALUES(31,'Lubber',8,55);
INSERT INTO Sailors VALUES(95,'Bob',3,60);

INSERT INTO Boats VALUES(101,'Interlake1','Blue');
INSERT INTO Boats VALUES(102,'Interlake2','Red');
INSERT INTO Boats VALUES(103,'Clipper','Green');
INSERT INTO Boats VALUES(104,'Marine','Red');

INSERT INTO Reserves VALUES(22,101,'10/10/2012');
INSERT INTO Reserves VALUES(95,103,'11/12/2012');

----

SELECT *
FROM Sailors  INNER JOIN Reserves 
ON Sailors.sid = Reserves.sid;

SELECT *
FROM Sailors, Reserves
WHERE Sailors.sid = Reserves.sid;

SELECT *
FROM Sailors  NATURAL JOIN Reserves;

SELECT *
FROM Sailors FULL OUTER JOIN Reserves 
ON Sailors.sid = Reserves.sid;

SELECT *
FROM Sailors LEFT OUTER JOIN Reserves 
ON Sailors.sid = Reserves.sid;

SELECT *
FROM Reserves  RIGHT OUTER JOIN Boats 
ON Reserves.bid = Boats.bid;

SELECT * FROM Sailors FULL OUTER JOIN Boats 
ON Sailors.sname = Boats.bname

SELECT * FROM Sailors
WHERE sid NOT IN
(SELECT sid FROM Reserves)

SELECT * FROM Sailors  
       RIGHT OUTER JOIN Reserves ON Sailors.sid = Reserves.sid 
       LEFT OUTER JOIN Boats ON Reserves.bid = Boats.bid
       
--same as 
SELECT * FROM Sailors  NATURAL JOIN RESERVES NATURAL JOIN Boats

--Employees who doesnt work on any projects (alternative)
SELECT * 
FROM Emp
WHERE ssn NOT IN (SELECT ssn FROM projectEmp);

SELECT * 
FROM Emp LEFT OUTER JOIN projectEmp ON Emp.ssn=projectEmp.ssn
WHERE projectEmp.proj_id IS NULL