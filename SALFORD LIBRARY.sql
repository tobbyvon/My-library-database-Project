
--TASK 1 QUESTION 1
CREATE DATABASE SalfordLibrary

CREATE TABLE AddressTable (
AddressID int IDENTITY(1000,1) PRIMARY KEY,
Address1 nvarchar(30) NOT NULL,
Address2 nvarchar(30) NULL,
Postcode nvarchar(30) NOT NULL)


CREATE TABLE MemberInformation (
MembersID int IDENTITY(1010,1) PRIMARY KEY,
FirstName nvarchar(30) NOT NULL,
MiddleName nvarchar(30) NULL,
LastName nvarchar(30) NOT NULL,
AddressID int  NOT NULL,FOREIGN KEY (AddressID)REFERENCES AddressTable (AddressID),
DOB date NOT NULL,
EmailAddress nvarchar(50) UNIQUE,CHECK(EmailAddress LIKE '%_@_%._%'),
Tel_No int NULL,
UserName nvarchar(30) unique,
Password nvarchar(30) NOT NULL,
StartDate Date NOT NULL)


CREATE TABLE LibraryCatalogue (
ItemNo int IDENTITY(110,1) PRIMARY KEY,
ItemTitle nvarchar(30) NOT NULL,
ItemType nvarchar(30) NOT NULL,
Author nvarchar(30) NOT NULL,
DateAdded date NOT NULL,
YearOfPublication date NOT NULL,
ISBN int NULL UNIQUE,
ItemStatus nvarchar(30) NOT NULL,
DateRemove_Lost Date  NULL)


CREATE TABLE Loan_History (
LoanId int IDENTITY(110,1) PRIMARY KEY,
MembersID int NOT NULL FOREIGN KEY (MembersID)REFERENCES MemberInformation (MembersID),
ItemNo int NOT NULL FOREIGN KEY (ItemNo)REFERENCES LibraryCatalogue (ItemNo),
LoanDate date NOT NULL,
DueDate date NOT NULL,
DateReturned date  NULL)


CREATE TABLE Overdue_Payment (
PaymentID int IDENTITY(900,1) PRIMARY KEY,
LoanId int NOT NULL FOREIGN KEY (LoanId)REFERENCES Loan_History (LoanId),
TotalFine money NOT NULL,
PaymentPlan nvarchar(30) NOT NULL constraint instalment check ( PaymentPlan in ('1st installment', '2nd instalment', 'full Payement')),
AmountPaid Money NOT NULL,
PaymentDate_Time DateTIME default getdate(),
ModeOfPayment nvarchar(30) NOT NULL constraint Payment check ( ModeOfPayment in ('Card','Cash')),
OutstandingBalance Money   NOT NULL)

CREATE TABLE MarketingArchived (
MembersID int PRIMARY KEY,
FirstName nvarchar(30) NOT NULL,
MiddleName nvarchar(30) NULL,
LastName nvarchar(30) NOT NULL,
AddressID int  NOT NULL,
DOB date NOT NULL,
EmailAddress nvarchar(50) NOT NULL,
Tel_No int NULL,
UserName nvarchar(30) unique,
Password nvarchar(30) NOT NULL,
StartDate Date NOT NULL,
EndDate Date NOT NULL  default getdate())





 
    -- 2A Insert a new member into the database
CREATE FUNCTION Search(@TITLE AS VARCHAR(30))
RETURNS TABLE AS
RETURN 
(SELECT  TOP 1000 C.*
FROM [dbo].[LibraryCatalogue] C
WHERE C.ItemTitle = @TITLE
order by c.YearOfPublication);

--EXECUTION
SELECT * FROM Search('finding me')



-- 2b Insert a new member into the database
CREATE PROCEDURE OverdueItems
AS
BEGIN
    SELECT Loan_History.LoanId, Loan_History.MembersID, LibraryCatalogue.ItemTitle, 
    Loan_History.DueDate, MemberInformation.FirstName + MemberInformation.LastName as FullName
    FROM Loan_History
    JOIN MemberInformation ON Loan_History.MembersID = MemberInformation.MembersID
    JOIN LibraryCatalogue ON Loan_History.ItemNo = LibraryCatalogue.ItemNO
    WHERE Loan_History.DateReturned IS NULL 
    AND DATEDIFF(day, DueDate, GETDATE()) > -5 
    AND DATEDIFF(day, DueDate, GETDATE()) <= 0
END

EXEC OverdueItems



-- 2CInsert a new member into the database
CREATE PROCEDURE uspMemberInformation
@FirstName nvarchar(30) ,
@MiddleName nvarchar(30),
@LastName nvarchar(30) ,
@AddressID int  ,
@DOB date ,
@EmailAddress nvarchar(50) ,
@Tel_No int NULL,
@UserName nvarchar(30) ,
@Password nvarchar(30) ,
@StartDate Date 
AS
--Insert customer record
INSERT INTO MemberInformation( FirstName,	MiddleName, LastName, AddressID, DOB, EmailAddress, Tel_No, 
UserName,	Password, StartDate)
VALUES (@FirstName,
@MiddleName ,
@LastName ,
@AddressID   ,
@DOB  ,
@EmailAddress,
@Tel_No,
@UserName ,
@Password ,
@StartDate);

EXEC uspMemberInformation
'TOLA' , 	'Obi',	'Eze',1013,' 	1960-03-11	 ' ,'tobi@gmail.com',	758234992 ,     ' ezetee0 ' ,	 ' ezetee5136 '  , 	 ' 2018-1-19 '


-- 2D Insert a new member into the database
CREATE PROCEDURE uspUPDATEMemberInformation
@MembersID INT, 
@FirstName nvarchar(30) ,
@MiddleName nvarchar(30),
@LastName nvarchar(30) ,
@AddressID int  ,
@DOB date ,
@EmailAddress nvarchar(50) ,
@Tel_No int NULL,
@UserName nvarchar(30) ,
@Password nvarchar(30) ,
@StartDate Date 
AS
--UPDATE MemberInformation record
UPDATE MemberInformation 
SET FirstName = @FirstName,	MiddleName = @MiddleName , 
LastName = @LastName, AddressID = @AddressID, DOB = @DOB, 
EmailAddress = @EmailAddress, Tel_No = @Tel_No, 
UserName= @UserName ,	Password = @Password, StartDate = @StartDate
WHERE 
 MembersID = @MembersID


 -- TASK 1 QUESTION 3
 CREATE VIEW LoanHistory AS
SELECT Loan_History.LoanId, MemberInformation.MembersID, 
       CONCAT(MemberInformation.FirstName, ' ', MemberInformation.LastName) AS FullName, 
       LibraryCatalogue.ItemTitle AS Title, Loan_History.ItemNo, 
       Loan_History.LoanDate AS DateTakenOut, Loan_History.DueDate AS DateDueBack, 
       Loan_History.DateReturned AS DateReturned,
       CASE
            WHEN Loan_History.DateReturned IS NOT NULL AND 
			     Loan_History.DateReturned > Loan_History.DueDate THEN
                DATEDIFF(day, Loan_History.DueDate, Loan_History.DateReturned) * 0.10
            WHEN Loan_History.DateReturned IS NULL AND 
			     Loan_History.DueDate < GETDATE() THEN
                DATEDIFF(day, Loan_History.DueDate, GETDATE()) * 0.10
            ELSE
                0
       END AS FineAmount
FROM Loan_History
JOIN MemberInformation ON Loan_History.MembersID = MemberInformation.MembersID
JOIN LibraryCatalogue ON Loan_History.ItemNo = LibraryCatalogue.ItemNo;
--EXECUTION
SELECT * FROM LoanHistory


 -- TASK 1 (Question 4)
CREATE TRIGGER ItemStatusUpdate
on  Loan_History
AFTER UPDATE
AS 
BEGIN
    IF UPDATE (DateReturned) 
	BEGIN
   UPDATE LibraryCatalogue
   SET ItemStatus = 'Available'
   FROM LibraryCatalogue
   JOIN Loan_History on LibraryCatalogue.ItemNo = Loan_History.ItemNo
   JOIN inserted ON inserted.LoanId =Loan_History.LoanId
   WHERE inserted.DateReturned IS NOT NULL
   END
END
-- Execute question 4
EXEC sp_helptrigger 'Loan_History';


--Task 1 Quetion 5
--FUNCTION TOTAL NO DAYS LOAN
CREATE FUNCTION Daily_Loan(@DailyLoan AS DATE)
RETURNS TABLE AS
RETURN 

(SELECT  COUNT (*) as Total_No_Loan
from Loan_History
WHERE LoanDate = @DailyLoan);

-- EXECUTION
SELECT * FROM  Daily_Loan('2014-10-28')


--Task 1 Quetion 6
INSERT INTO AddressTable(Address1,	Address2,	Postcode)
VALUES  ('aldermore close',	'opewshaw', 'M11'),
('Katie Alley',	'Stapleford	', 'LN6'),
('Rockefeller Street',	'Pentre', '	SY4'),
('Coolidge Plaza','Buckland', 'CT16'),
('Derek Hill16th Floor',	'Leeds',	'LS6'),
('Springs Parkway Suite 80',	'Buckland',	'M34'),
('Sundown Parkway 11th Floor',	'Kirkton',	'KW10'),
('Clarendon Street Suite 30',	'Carlton	','DL8'),
('Pine View Road', 	'Carlton	',		'OX7'),
('Lakewood Point 9th Floor',	 'Kirkton',	'BT2'),
('Mcguire Stree Suite 72',	'Glasgow',	'CB4');



INSERT INTO MemberInformation(AddressID, FirstName,	LastName	, EmailAddress, Tel_No, DOB,
UserName,	Password, StartDate)
VALUES (1000 , 	 'Rustie' , 	'Pandey',	'rpandey0@topsy.com',	758234482 ,  ' 	1960-03-11	 '  ,   ' rpandey0 ' ,	 ' Rustie5136 '  , 	 ' 2001-1-19 ')  , 
(1001 , 	'Ingeborg' , 	'Tytherton',	'itytherton1@jugem.jp',	752544467 ,  ' 	1938-11-02	 '  ,   ' itytherton1 ' ,	 ' Ingeborg4202 '  , 	 ' 2011-2-15 ')  , 
(1002, 	'Garik' , 	'Rennock',	'grennock2@vimeo.com',	755524065 ,  ' 	2019-10-03	 '  ,   ' grennock2 ' ,	 ' Garik3713 '  , 	 ' 2014-11-7')  , 
(1003 , 	'Brinn' , 	'Merrywether', 	'bmerrywether3@google.ru',	751273396 ,  ' 	1928-04-09	 '  ,   ' bmerrywether3 ' ,	 ' Brinn3413 '  , 	 ' 2008-9-6 '  ), 
(1004 , 	'Stanislaus' , 	'Elsie',	'selsie4@hibu.com',	756395396 ,  ' 	1942-02-07	 '  ,   ' selsie4 ' ,	 ' Stanislaus5265 '  , 	 ' 2009-8-30 ')  , 
(1005 , 	'Howard' , 	'Staning',	'hstaning5@scribd.com',	757342935 ,  ' 	1995-09-02	 '  ,   ' hstaning5 ' ,	 ' Howard5608 '  , 	 ' 2010-11-19 ')  , 
(1006 , 	'Nedi' , 	'Harrinson',	'nharrinson6@theatlantic.com',	754283276 ,  ' 	1953-08-01	 '  ,   ' nharrinson6 ' ,	 ' Nedi1479 '  , 	 ' 2011-3-25 ')  , 
(1007 , 	'Harry' , 	 'Leethem' ,	 'hleethem7@sogou.com',	226118778 ,  ' 	1946-02-14	 '  ,   ' hleethem7 ' ,	 ' Harry9413 '  , 	 ' 2009-10-15 ')  , 
(1008 , 	'Gerry' , 	'Hulburt',	'ghulburt8@comsenz.com',	267492034 ,  ' 	1982-11-24	 '  ,   ' ghulburt8 ' ,	 ' Gerry6949 '  , 	 ' 2010-2-21 ')  , 
(1009 , 	'Leroy' , 	'Bentzen',	'bentzen9@dailymotion.com',	756941521 ,  ' 	1935-07-22	 '  ,   ' Lbentzen ' ,	 ' bentzen6613 '  , 	 ' 2011-7-23 ' ) 

INSERT INTO LibraryCatalogue( ItemTitle,	ItemType, Author,DateAdded, YearOfPublication,
ISBN, Itemstatus, DateRemove_Lost)
VALUES ('Little me',	'BOOKS',	'John Doe',	'2016-11-12',	'2018',	978-1-940046-76-1,	'overdue',	NULL),
('ijewele',	'jornals',	'chimamanda',	'2016-10-12',	'2011',	972-1-949666-76-1,	'overdue',	NULL),
('finding me',	'BOOKS',	'Viola Davis',	'2016-10-12',	'2018',	978-1-947746-76-1,	'overdue',	NULL),
('Becoming',	'jornals',	'Frederick Stone',	'1986-10-12',	'1999',	978-1-949976-76-1,	'overdue',	NULL),
('Narrative of Frederick',	'jornals',	'Frederick Douglass',	'1986-02-15',	'1799',	978-1-946624-76-1,	'Available',	NULL),
('Pride and Prejudice', 'BOOKS', 'Jane Austen', '2014-10-28',	'1801',	978-1-953624-76-1,	'overdue',	NULL),
('A Description of Animals', 	'BOOKS',	 'Thomas Boreman',	'1980-09-03',	'1737',	978-1-933124-74-1,	'removed',	'2008-02-05'),
('The Gigantick History', 	'BOOKS',	 'Thomas Boreman',	'1973-07-28',	'1740',	978-1-993924-76-1, '	loan', 	NULL),
('A Little Pretty Pocket-Book', 	'BOOKS',	 'John Newbery',	'2010-11-16',	'1752',	978-1-937624-76-1,	'removed',	'2015-09-12'),
('Sacred Dramas',	'DVD', 'Hannah More',	'2011-03-23',	'1801',	NULL,	'Available',	NULL),
('The Life of a Mouse', 'BOOKS',	 'Dorothy Kilner',	'1960-10-13',	'1783',	978-1-916674-75-1,	'lost',	'2006-06-08'),
('Cobwebs to Catch Flies', 	'BOOKS',	'Ellenor Fenn	','1975-02-20', '1783', 978-1-912984-72-1,	'Available',	NULL),
('The History of Sandford', 	'jornals',	'Thomas Day',	'1944-07-22',	'1783',	NULL,	'Available',	NULL),
('Anecdotes of Boarding School', 'BOOKS',	'Dorothy Kilner','1926-02-27',	'1784',	972-1-912984-79-1,	'Available'	,NULL), 
('Fabulous Histories', 	'jornals',	'Sarah Trimmer',	'1967-09-26',	'1786',	NULL,'overdue',	NULL),
('A Description of Scripture', 'BOOKS',	'Sarah Trimmer', '2014-07-10',	'1786',	978-1-912084-88-1, 'loan',NULL)
select * from LibraryCatalogue


 INSERT INTO Loan_History ( MembersID,ItemNo, LoanDate, DueDate, DateReturned)
VALUES  ( 1012,	147,	 ' 2023-03-04'  , 	  ' 2023-3-18 ' ,  ' 2023-3-20 '),
( 1017,	136,	 ' 2023-02-28'  , 	 ' 2023-4-1 '  , 	null ),
( 1013,	137,	 ' 2023-02-28'  , 	 ' 2023-04-19 '  , 	null )  ,
( 1019,	138,	 ' 2023-02-28'  , 	 ' 2023-04-23 '  , 	null ),
( 1010,	139,	 ' 2023-02-28'  , 	 ' 2023-04-25 '  , 	null )  ,
( 1011,	141,	 ' 2023-02-28'  , 	 ' 2023-06-29 '  , 	null )  , 
(1013,	143,	 ' 2023-04-1 '  , 	 ' 2023-06-2 '  , 	null  )  , 
(1015,	151,	 ' 2023-03-28 '  , 	 ' 2023-06-29 '  , 	null  )  , 
(1010,	142,	 ' 2023-04-26 '  , 	 ' 2023-06-26 '  , 	null  )  , 
(1016,	151,	 ' 2023-03-1 '  , 	 ' 2023-06-2 '  , 	null  )  ,  
(1019,	140,	 ' 2023-03-1 '  , 	 ' 2023-4-1 '  , 	 ' 2023-3-20 '   )  , 
(1012,	149,	 ' 2023-03-4 '  , 	 ' 2023-4-4 '  , 	 ' 2023-4-1 '  )  , 
(1017,	148,	 ' 2023-03-10 '  , 	 ' 2023-4-10 '  , 	 ' 2023-4-3 ' )

CREATE TRIGGER deleted_members ON MemberInformation

-- Task 1 Q7
DROP TRIGGER IF EXISTS deleted_members;
GO
CREATE TRIGGER deleted_members ON MemberInformation
AFTER DELETE
AS BEGIN
insert into [dbo].[MarketingArchived](MembersID, [FirstName], [MiddleName], [LastName],
[AddressID], [DOB], [EmailAddress], [Tel_No], [UserName], [Password], [StartDate])
select
MemberInformation.MembersID, MemberInformation.FirstName,
MemberInformation.MiddleName, MemberInformation.LastName,
MemberInformation.AddressID, MemberInformation.DOB, 
MemberInformation.EmailAddress, MemberInformation.Tel_No, 
MemberInformation.UserName, MemberInformation.Password, MemberInformation.StartDate
from 
deleted MemberInformation
END;

CREATE TRIGGER Archive_DEL ON MarketingArchived
instead of DELETE 
AS
BEGIN
	rollback transaction;
	return;
	END