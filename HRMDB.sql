/*
Date:7 feb 2020
Create scripts

*/
Drop DATABASE hrmdb;
CREATE DATABASE hrmdb;

Create TABLE `gender` (
    id int not null AUTO_INCREMENT,
    value VARCHAR(15),
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY(id)     
);

CREATE TABLE hrmdb.`position` (
    id int(5) AUTO_INCREMENT,
    description text not null,
    title VARCHAR(30) not null,
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY(id)
);


CREATE TABLE hrmdb.`status` (
    id int(5) AUTO_INCREMENT,
    value VARCHAR(15) not null,
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY(id)
);


CREATE TABLE hrmdb.`currency`(
    id int(5) AUTO_INCREMENT,
    name VARCHAR(30) not null,
    code VARCHAR(8) not null,
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY(id)   
);


CREATE TABLE hrmdb.`country`(
    id int(5) AUTO_INCREMENT,
    name VARCHAR(25) not null,
    code VARCHAR(10),
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY(id)
);

use hrmdb;
CREATE TABLE hrmdb.`district` (
    id int(5) AUTO_INCREMENT,
    name VARCHAR(25) not null,
    code VARCHAR(10),
    countryId int(5),
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY (id),
    FOREIGN KEY (countryId) REFERENCES country(id)
);

CREATE TABLE hrmdb.`document` (
    id int(5) AUTO_INCREMENT,
    documentName VARCHAR(80) not null,
    fileName VARCHAR(150) not null,  
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY (id)
);

use hrmdb;
CREATE TABLE hrmdb.`employee`(
    id int(5) AUTO_INCREMENT,
    firstName VARCHAR(50) not null,
    lastName VARCHAR(50) not null,
    maidenName VARCHAR(50),
    birthDate DATE not null,
    statusId int(5) not null,
    genderId int(5) not null,
    startDate Date not null,
    address VARCHAR(40) not null,
    phonenumber VARCHAR(15) not null,
    email VARCHAR(30) not null,
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY key (id),
    FOREIGN Key (statusId) REFERENCES status(id),
    FOREIGN Key(genderId) REFERENCES gender(id)
);

use hrmdb;
CREATE TABLE hrmdb.`employeecontract` (
    id int(5) AUTO_INCREMENT,
    oldContractid int(5),
    employeeId int(5)not null,
    documentId int(5)not NULL,
    position VARCHAR(30) not null,
    grossSalary VARCHAR(30) not null,
    netSalary VARCHAR(3) not null,
    statusId int(5)not null,
    signDate DATE not null,
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY (id),
    FOREIGN KEY (statusId) REFERENCES status(id),
    FOREIGN Key (documentId) REFERENCES document(id),
    FOREIGN KEY (employeeId) REFERENCES employee(id)
);

use hrmdb;
CREATE TABLE hrmdb.`branch` (
    id int(5) AUTO_INCREMENT,
    address VARCHAR(50) not null,
    districtId int(5)not null,
    phonenumber VARCHAR(20) not null,
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY (id),
    FOREIGN KEY (districtId) REFERENCES district(id)
);

use hrmdb;
CREATE TABLE hrmdb.`division` (
    id int(5) AUTO_INCREMENT,
    headId int(5)not null ,
    description text not null,
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY (id),
    FOREIGN key (headId) REFERENCES employee(id)
);

use hrmdb;
CREATE TABLE hrmdb.`SalaryPayment`(
    id int(5) AUTO_INCREMENT,
    paymentDate DATE not null,
    contractId int(5)not null,
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY (id),
    FOREIGN KEY (contractId) REFERENCES employeecontract(id)
);

use hrmdb;
CREATE TABLE hrmdb.`salarypaymentdocument` (
    id int(5) AUTO_INCREMENT,
    SalaryPaymentId int(5)not null ,
    documentId int(5)not null,
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY (id),
    FOREIGN key (SalarypaymentId) REFERENCES salarypayment(id),
    FOREIGN KEY (documentId) REFERENCES document(id)
);



use hrmdb;
CREATE TABLE hrmdb.`financeruletypes`(
    id int(5) AUTO_INCREMENT,
    value VARCHAR(20) not null,
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY (id)
);

use hrmdb;
CREATE TABLE hrmdb.`fincancerules`(
    id int(5) AUTO_INCREMENT,
    name VARCHAR(30) not null,
    description text not null,
    typeOfRuleId int(5)not null,
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY (id),
    FOREIGN Key (typeOfRuleId) REFERENCES financeruletypes(id)
);

use hrmdb;
CREATE TABLE hrmdb.`leave`(
    id int(5) AUTO_INCREMENT,
    employeeId int(5)not null ,
    requestedOn DATETIME not null,
    approvedOn DATETIME not null,
    fromDate Date not null,
    toDate Date not null,
    statusId int(5)not null ,
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY (id),
    FOREIGN Key (statusId) REFERENCES status(id),
    FOREIGN Key (employeeId) REFERENCES employee(id)
);

use hrmdb;
CREATE TABLE hrmdb.`leaveAmount`(
    id int(5) AUTO_INCREMENT,
    employeeId int(5)not null,
    totalAmount decimal not null,
    amountUsed decimal not null,
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY (id),
    FOREIGN Key (employeeId) REFERENCES employee(id)
);

create TABLE `email`(
    id int not null, AUTO_INCREMENT,
    createdDate DATETIME not null,
    modifiedDate DATETIME,
    PRIMARY KEY (id),
);

use hrmdb;
Create View vw_employeeleave as 
Select emp.id as 'employeeId',
        concat(emp.firstName, ' ', emp.lastName) AS 'employee',
       l.fromDate as 'Start Date',
       l.toDate as 'End Date',
       s.value as 'Status',
       l.approvedOn as 'Approve Date'
from `leave` l inner join `employee` emp on l.employeeId = emp.id
inner join  status s on l.statusId = s.id;

select * from hrmdb.vw_employeeleave;

Create View vw_employeedetails as
Select  emp.id as 'employeeId',
        concat(emp.firstName, ' ', emp.lastName),
        s.value as 'employeeStatus',
        emp.email as 'Email',
        emp.address as 'Address',
        emp.phonenumber as 'Phonenumber',
        emp.birthDate as 'BirthDate',
        c.position as 'Position',
        emp.startDate as 'StarDate'
from `employee` emp inner join `employeecontract` c on emp.id = c.employeeId
inner join `status` s on c.statusId = s.id;

