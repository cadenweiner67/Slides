CREATE TABLE Musician  (
	  ssn CHAR(9),
	  musicianname VARCHAR,
	  PRIMARY KEY(SSN)
);

CREATE TABLE  Instrument (
	 instrNum INTEGER,
	 instrName VARCHAR,
	 mkey VARCHAR,
	 PRIMARY KEY (instrNum,instrName)
);

CREATE TABLE Album  (
	 albumID INTEGER,
	 title VARCHAR,
	 copyrightDate DATE,
	 musician_ssn CHAR(9) NOT NULL,  -- total participation of Album in produces
	 PRIMARY KEY (albumID),
	 FOREIGN KEY (musician_ssn) REFERENCES Musician(ssn)
);

CREATE TABLE Song  (
	 albumID INTEGER,
	 title VARCHAR,
	 author VARCHAR,
	 PRIMARY KEY (albumID,title),
	 FOREIGN KEY (albumID) REFERENCES Album (albumID)
);

CREATE TABLE Performs  (
	 ssn CHAR(9),
     albumID INTEGER,
     title VARCHAR,
	 PRIMARY KEY (ssn,albumID,title),
	 FOREIGN KEY (ssn) REFERENCES Musician(ssn),
	 FOREIGN KEY (albumID,title) REFERENCES Song(albumID,title)
);
-- total participation of Song in Performs relation can't be enforced.


CREATE TABLE Plays (
	 instrNum INTEGER,
	 instrName VARCHAR,	
	 ssn CHAR(9), 
	 PRIMARY KEY (ssn,instrNum,instrName),
	 FOREIGN KEY (ssn) REFERENCES Musician(ssn),
	 FOREIGN KEY (instrNum,instrName) REFERENCES Instrument(instrNum,instrName)
);

CREATE TABLE PhoneAddress (
	 phoneNo CHAR(10), 
	 addr VARCHAR,
	 PRIMARY KEY(phoneNo),
	 FOREIGN KEY (addr) REFERENCES Address(addr)
);

-- We may drop the Address table and remove the addr foreign key in PhoneAddress. 
CREATE TABLE  Address (
	 addr VARCHAR PRIMARY KEY
);

CREATE TABLE HasPhoneAddress (
	 phoneNo CHAR(10), 
	 ssn CHAR(9),
	 PRIMARY KEY (phoneNo,ssn),
	 FOREIGN KEY (phoneNo) REFERENCES PhoneAddress(phoneNo),
	 FOREIGN KEY (ssn) REFERENCES Musician(ssn)
);
-- total participation of Musician in HasPhoneAddress relation can't be enforced.
