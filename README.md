# My-library-database-Project

# Introduction

Salford Library database was created For a library with the aim to keep record of its library members, library items, loan records and fine payments of overdue loan. In respect to these goals Six tables are created and normalized to 3NF also unique and check constraint was added to the tables to ensure data integrity. Also Functions and stored procedures, views and trigger are created within the database to ensure atomicity, consistency, durability and data concurrency.

# Part 1 

Design and normalization of Salford Library database into 3NF and the process of implementing this design.

The Salford Library database comprises of six tables namely the Members Information, AddressTable, Library Catalogue, Loan History, Overdue Payment and Marketing archive. Just as the names of the respective tables imply they captures the library information of member in relation with the library catalogue through loans.
 
 
Members information table holds the information specific to the library members. The Members ID is the primary key to the members information table, it is also the surrogate key which has an integer data type with an identity constraint which is unique within the scope of the seed which is 1010 having the increment of 1. The  names of the members is then split into three column the nvarchar(30) data type each, allowing the middle name to be null and make the first name and lastname to be not null because they are a very important piece of information about every member.   The email, username, password was also assigned the nvarchar(30) data type while the telephone number was assigned an integer datatype. The  date of birth and start date was assigned a data type respectively. For Members information table to be in third normal form, the addresses has been put  in separate tables to remove any dependencies from the table. One foreign key was imputed to identify the Members address, which is stored in separate table. Additionally, a UNIQUE constraint and a CHECK constraint was added to the email address column to make sure that email addresses comply to the minimal format necessary for a valid email address. 

The AddressTable has a primary key with integer datatype named AddressID, and each non-key attribute such as Address1, Address2, and Postcode is dependent only on the primary key. It assumed  for the purpose of this database that the Address1 and Postcode combined should uniquely determine the address, so address 2 columns was made null as it is not a major determinant of the members address. The address 1, address 2 and postcode is assign the nvarchar data type respectively.
 

For LibraryCatalogue table to be in third normal form a primary key named an Item Number which is an integer data type was created and each non-key attribute such as ItemTitle with the data type nvarchar(30), ItemType with the data type nvarchar(30), Author with the data type nvarchar(30), DateAdded with the Date data type, YearOfPublication with the Date data type, ISBN with the integer data type, ItemStatus with the data type nvarchar(30), and DateRemove/Lost with the Date data type is dependent only on the primary key. However to help ensure a high level of data integrity all  columns were assign a not null constraint except date lost column because not all library items are lost or remove. The ISBN column also allow null value to leave room for items with no ISBN number such as DVD and other media. More so, the ISBN number was made unique as there were multiple books to one Author.
 

The Loan History table has a primary key named LoanId which is an integer datatype, and each non-key attribute such as MembersID, Item No, LoanDate, DueDate, DateReturned, and DaysOverdue is dependent only on the primary key. Two foreign key constraints was added as the table one with reference to member information table the other referencing the library catalogue table. The Foreign key constraints are been created to explicitly show the relationship between items in the library catalogue and library members, This is because there is a one-to-many relationship between members and Items loaned (a member can be associated with more than one library items the member and Library Catalogue column tables do not directly reference one another) which is why the tables were referenced as a foreign key to explicitly show their relationship. The loan date, due date, and date returned column are date data type respectively while Loan id, Members id and item id are assign the integer datatype: note that Members id and item id are integer data type because the tables with which they reference are also integer datatype. All columns are assigned a not null value except the date returned column which cannot be null during the duration of the loan.
 

The overdue payment table is been create to track the payment of overdue loans. A trigger will be attached to this table to automatically calculate the fine based on the number of days overdue. To give more details to the payment, the LoanId column is made the foreign key with reference to the Loan history table.  In addition, all column in this table is set to be not null to ensure that no information in this table is missing.  When a member has overdue fines, they can repay some or all the overdue fines to implement this, a check constraint was added to the PaymentPlan to check that only first, second and full payment option could be input into the payment plan each payment made in this table will then in turn be dependent on the payment ID which is a surrogate key with identity constraint and also the primary key which makes every payment unique. check constraint was also added to the ModeOfPayment column to ensure that only either card or cash inputted these constraints was added to ensure the data integrity of the payment. The amount paid and total fine and outstanding balance was assigned a money data type. More so, the payment id, loan id, days overdue is assigned the integer data type. Likewise, the payment plan and the mode of payment table was is assigned the nvarchar(30) data type while the payment date  column is assign date data type.
 
 
In conclusion the tables in the Salford Library database has one to many entity- relationship. This is because the "MemberInformation" table represents information about library members, and has a one-to-many relationship with the "AddressTable" table, as many members can have the same address, but each member can have only one address. The "AddressID" column is a foreign key that references the primary key "AddressID" in the "AddressTable" table. The "MemberInformation" table also has a one-to-many relationship with the "Loan_History" table, as each member can have multiple loan history records, but each loan history record belongs to only one member. The "MembersID" column in the "Loan_History" table is a foreign key that references the primary key "MembersID" in the "MemberInformation" table. Finally, there is no direct connection between the "MemberInformation" table and the "LibraryCatalogue" or "Overdue_Payment" tables; however, there is an indirect connection through the "Loan_History" table..

# Part 2

Functions and stored procedures for Salford library.
a.	Functions to query Salford library catalogue for matching character string
 
The code above is a T-SQL query  used to create "Search" function for Salford Library, to create this function, only one parameter called @TITLE is taken as an input of type varchar(30). The SELECT statement is used to extract matching character string from the table named “LibraryCatalogue”. The Query result provides a table with up to a 1000 rows that meet the search parameters. The WHERE clause filters the results based on the ItemTitle column of the “LibraryCatalogue” table in comparison to the @TITLE parameter value. Finally, the Query result table is then arranged based on the YearOfPublication column in ascending order.
 
The above shows the execution of the Salford library Search function and the result set.

b.	Stored procedure to return a full list of all items currently on loan which have a due date of less than five days from the current date.
 

The stored procedure created is named "OverdueItems". It includes a SELECT statement that retrieves information from three tables: "Loan_History", "MembersInformation", and "LibraryCatalogue". The SELECT statement picks the following columns from these tables: "LoanId" column from "Loan_History" table, "MembersID" column from "Loan_History" table, "ItemTitle" column from "LibraryCatalogue" table, "DueDate" column from "Loan_History" table, "FirstName" and "LastName" columns from "MembersInformation" table concatenated into a single column named "FullName" using the "+" operator. The SELECT statement also includes three join statements: A join between "Loan_History" and "MembersInformation" tables on the "MembersID" column, A join between "Loan_History" and "LibraryCatalogue" tables on the "ItemId" column.
A WHERE clause that filters the results to include only records where the "ReturnDate" column in "Loan_History" table is NULL, and where the difference between the current date (obtained using the GETDATE() function) and the "DueDate" column in "Loan_History" table is between -5 and 0 days.
Generally, the stored procedure is made to get details about items that have a due date of less than five days from the current date.



c.	Stored procedure to insert a new member into the database.
 

The stored procedure to insert new members is named "uspMemberInformation", it takes in ten input parameters for a new member's information. These parameters are: @FirstName: a string parameter that represents the member's first name, @MiddleName: a string parameter that represents the member's middle name, @LastName: a string parameter that represents the member's last name, @AddressID: an integer parameter that represents the member's address ID, @DOB: a date parameter that represents the member's date of birth, @EmailAddress: a string parameter that represents the member's email address, @Tel_No: an integer parameter that represents the member's telephone number, @UserName: a string parameter that represents the member's username, @Password: a string parameter that represents the member's password, @StartDate: a date parameter that represents the start date of the member's membership. The uspMemberInformation stored procedure then includes an INSERT statement that inserts a new record into the "MemberInformation" table with the input parameter values provided. The column values of the new record are mapped to the input parameters in the VALUES clause of the INSERT statement.
Overall, this stored procedure is designed to provide a reusable way of inserting new member records into the "MemberInformation" table in the database. This procedure can be called from an application or another SQL script, providing an easy way to insert new member information into the database
d.	Stored procedure to Update the details for an existing member
 
This stored procedure to update member information table is named uspUPDATEMemberInformation. This procedure takes in 10 parameters: @MembersID, @FirstName, @MiddleName, @LastName, @AddressID, @DOB, @EmailAddress, @Tel_No, @UserName, and @Password. These parameters are used to update the existing record in the MemberInformation table with the new information provided. The UPDATE statement in the stored procedure modifies the MemberInformation table by setting the values of various columns (i.e. FirstName, MiddleName, LastName, AddressID, DOB, EmailAddress, Tel_No, UserName, Password, and StartDate) to the corresponding parameter values passed to the procedure while the WHERE clause filters the records in the MemberInformation table and updates only the record with a matching MembersID value passed to the procedure.

# Part 3 

Creating Loan History View
This view named Loan History retrieves data from the tables: Loan_History, MemberInformation, and LibraryCatalogue. The view was created such that If the item type is returned late and the Date it was returned is after the DueDate, the fine is calculated as minus between the DateReturned and DueDate in days, multiplied by 0.10 (assuming the fine of 10 pence per day)
If the item has not been returned and the DueDate has passed, the fine is calculated as the minus between the current date and the DueDate in days, multiplied by 0.10
And If the item was returned on time, no fine is charged. By creating this view, this query provides a convenient and reusable way to collect loan history data for reporting and analysis purposes. 
 

# Part 4

Trigger that updates the current status of an item automatically to Available when the book is returned.
 
This trigger is called "ItemStatusUpdate" . It checks if the "DateReturned" column has been updated, and if so, it updates the "ItemStatus" column in the "LibraryCatalogue" table to "Available" for the item that was returned. This trigger uses the "JOIN" clause to join the "LibraryCatalogue" table with the "Loan_History" table on the "ItemNo" column to get the corresponding item that was returned. It then joins the "inserted" virtual table with the "Loan_History" table on the "LoanId" column to get the loan record that was updated. The "WHERE" clause then filters the joined result to only include loan records where the "DateReturned" column is not null, indicating that the item has been returned. The "UPDATE" statement then updates the "ItemStatus" column in the "LibraryCatalogue" table to "Available" for the returned item.

# Part 5

Function that allows the library to identify the total number of loans made on a specified date.
 
This user-defined table-valued function called "Daily_Loan" takes a date parameter (@DailyLoan) and returns a table with one column called "Total_No_Loan". It  performs a SELECT statement that counts the total number of loan records in the "Loan_History" table where the "LoanDate" column matches the input parameter (@DailyLoan). This count is returned as a single row in the result set.
To execute the function, the "SELECT" statement at the bottom of the code is used, passing a specific date value ('2014-10-28') as the input parameter to the function. 

# Part 6

Inserting records into each of the tables.
In the process of inserting into each row the data containing values for the columns of each table, the "VALUES" clause is used, followed by a set of parentheses for each row of data separated by comma.

 
 

# Part 7
Creating Delete Trigger.
 
This trigger is designed to take action when a row is deleted from the "MemberInformation" table, performing the following steps:
The trigger is named "deleted_members" and is linked with the "MemberInformation" table. It is set to Execute "AFTER DELETE," which means that it will execute after a row has been deleted from the table. The purpose of this trigger is to allow Salford library database to retain the information of members even after they end their membership. 



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





# Conclusions 

In conclusion the Salford Library is database with six tables, stored procedures which have one to many entity relationship, it is normalized to 3NF, its contains stored procedure and function created to maintain data durability. To ensure data security, a delete trigger has been created to keep information of member into the marketing  archive table.
