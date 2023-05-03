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

# Conclusions 

In conclusion the Salford Library is database with six tables, stored procedures which have one to many entity relationship, it is normalized to 3NF, its contains stored procedure and function created to maintain data durability. To ensure data security, a delete trigger has been created to keep information of member into the marketing  archive table.
