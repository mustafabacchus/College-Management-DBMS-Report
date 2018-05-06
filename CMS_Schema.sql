/*drop database if exists college_mangement_system;
create database college_mangement_system;
use college_mangement_system;*/


	drop table if exists Department;
    create table Department (
		ID int not null,
        Name varchar(30) not null,
        primary key Pk_Department (ID)
	);
    
	drop table if exists Course;
    create table Course (
		ID int not null,
        Name varchar(50) not null,
        DeptID int not null,
        primary key Pk_Course (ID),
        foreign key Fk_Course_Department (DeptID) references Department(ID)
	);
    
	drop table if exists Faculty;
    create table Faculty (
		ID int not null,
        FirstName varchar(30) not null,
        LastName varchar(50) not null,
        DeptID int not null,
        primary key Pk_Faculty (ID),
        foreign key Fk_Faculty_Department (DeptID) references Department(ID)
	);
    
	drop table if exists FacultyCourse;
	create table FacultyCourse (
		FacultyID int not null,
		CourseID int not null,
        primary key Pk_FacultyCourse (FacultyID, CourseID),
        foreign key Fk_FacultyCourse_Faculty (FacultyID) references Faculty(ID),
        foreign key Fk_FacultyCourse_Course (CourseID) references Course(ID)
	);
    
    drop table if exists Student;
    create table Student (
		ID int not null,
		FirstName varchar(30) not null,
        LastName varchar(50) not null,
        Street varchar(50) not null,
        StreetDetail varchar(30) default null,
        City varchar(30) not null,
        State varchar(30) not null,
        PostalCode char(5) not null,
        MajorID int not null,
        primary key Pk_Student (ID),
        foreign key Fk_Student_Department (MajorID) references Department(ID)
	);
    
    drop table if exists StudentCourse;
    create table StudentCourse (
		CourseID int not null,
        StudentID int not null,
        Progress int null,
        StartDate date not null,
        primary key Pk_StudentCourse (CourseID, StudentID),
        foreign key Fk_StudentCourse_Course (CourseID) references Course(ID),
        foreign key Fk_StudentCourse_Student (StudentID) references Student(ID)
	);
    
    