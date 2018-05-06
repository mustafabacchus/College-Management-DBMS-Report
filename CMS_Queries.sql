/*A*/
/*The Curriculum Planning Committee is attempting to fill in gaps in the current course offerings. You need to provide them with a query which lists each department 
and the number of courses offered by that department. The two columns should have headers “Department Name” and “# Courses”, and the output should be sorted 
by “# Courses” in each department (ascending).*/

select 
d.Name as 'Department Name', 
count(c.Name) as '# Courses'
from Department d
join Course c on d.ID = c.DeptID
group by 1
order by 2 asc;





/*B*/
/*The recruiting department needs to know which courses are most popular with the students. Please provide them with a query which lists the name of each course 
and the number of students in that course. The two columns should have headers “Course Name” and “# Students”, and the output should be sorted first by # Students 
descending and then by course name ascending.*/

select 
c.Name as 'Course Name',
count(sc.CourseID) as '# Students'
from Course c
join StudentCourse sc on c.ID = sc.CourseID
group by 1
order by 2 desc, 1 asc;





/*C.*/ 
/*Quite a few students have been complaining that the professors are absent from some of their courses.*/

/*1. Write a query to list the names of all courses where the # of faculty assigned to those courses is zero. The output should be in alphabetical order by course name.*/

select
c.Name as 'Course'
from Course c
join StudentCourse sc on c.ID = sc.CourseID
left join FacultyCourse fc using(CourseID)
group by 1, fc.FacultyID
having fc.FacultyID is null
order by 1 asc;


/*2 . Using the above, write a query to list the course names and the # of students in those courses for all courses where there are no assigned faculty. The output should be 
ordered first by # of students descending and then by course name ascending.*/

select
c.Name as 'Course',
count(sc.StudentID) as '# Students'
from Course c
join StudentCourse sc on c.ID = sc.CourseID
left join FacultyCourse fc using(CourseID)
group by 1, fc.FacultyID
having fc.FacultyID is null
order by 2 desc, 1 asc;





/*D. */
/*The enrollment team is gathering analytics about student enrollment throughout the years. Write a query that lists the total # of students that were enrolled in the beginning of 
classes during each semester (from January 25th 2014 up to August 25th 2017). The first column should have the header “Students”. Provide a second “Year” column showing 
the enrollment year. [HINT: combining multiple select statements into one query is one way of doing this].*/

select
year(StartDate) as 'Year',
count(distinct StudentID) as '# Students'
from StudentCourse
group by 1
order by 1;





/*E.*/ 
/*The enrollemnt team is gathering analytics about student enrollment and they now want to know about August admissions specifically. Write a query that lists the Start Date and 
# of Students who enrolled in classes in August of each year. Output should be ordered by start date ascending.*/

select
StartDate as 'Start Date',
count(distinct StudentID) as '# Students'
from StudentCourse
where month(StartDate)  = '08'
group by 1
order by 1 asc;





/*F.*/ 
/* Students are required to take 4 courses, and at least two of these courses must be from the department of their major. Write a query to list students’ First Name, Last Name, and 
Number of Courses they are taking in their major department. The output should be sorted first in increasing order of the number of courses, then by student last name.*/

select 
s.FirstName as 'First Name',
s.LastName as 'Last Name',
count(s.MajorID) as '# Courses In Major'
from Student s
join StudentCourse sc on s.ID = sc.StudentID
join Course c on sc.CourseID = c.ID
where c.DeptID = s.MajorID
group by s.ID
order by 3 asc, 2 asc;





/*G.*/ 
/*Students making average progress in their courses of less than 50% need to be offered tutoring assistance. Write a query to list First Name, Last Name and Average Progress of 
all students achieving average progress of less than 50%. The average progress as displayed should be rounded to one decimal place. Sort the output by average progress 
descending.*/

select
s.FirstName as 'First Name',
s.LastName as 'Last Name',
round(avg(sc.Progress), 1) as 'Avg Progress'
from Student s
join StudentCourse sc on s.ID = sc.StudentID
group by s.ID
having round(avg(sc.Progress), 1) < 50
order by 3 desc;





/*H.*/ 
/*Faculty are awarded bonuses based on the progress made by students in their courses.*/

/*1. Write a query to list each Course Name and the Average Progress of students in that course. The output should be sorted descending by average progress.*/

select 
c.Name as 'Course',
avg(sc.Progress) as 'Avg Progress'
from Course c
join StudentCourse sc on c.ID = sc.CourseID
group by 1
order by 2 desc;


/*2. Write a query that selects the maximum value of the average progress reported by the previous query.*/

select max(avgp) as 'Max Avg Progress' 
from (
	select c.ID,
	avg(sc.Progress) as avgp
	from Course c
	join StudentCourse sc on c.ID = sc.CourseID
	group by 1) 
as tmp;


/*3. Write a query that outputs the faculty First Name, Last Name, and average of the progress (“Avg. Progress”) made in each of their courses.*/

select 
f.FirstName as 'First Name',
f.LastName as 'Last Name',
c.Name as 'Course',
avg(sc.Progress) as 'Avg Progress'
from Faculty f
join FacultyCourse fc on f.ID = fc.FacultyID
join StudentCourse sc using(CourseID)
join Course c on c.ID = fc.CourseID
group by f.ID, fc.CourseID
order by 2, 3, 4 desc;


/*4. Write a query just like #3, but where only those faculty where average progress in their courses is 90% or more of the maximum observed in #2.*/

select 
f.FirstName as 'First Name',
f.LastName as 'Last Name',
c.Name as 'Course',
avg(sc.Progress) as 'Avg Progress'
from Faculty f
join FacultyCourse fc on f.ID = fc.FacultyID
join StudentCourse sc using (CourseID)
join Course c on c.ID = fc.CourseID
group by f.ID, fc.CourseID
having avg(sc.Progress) >=
	(
	select max(avgp) * .90
		from (
			select c.ID,
			avg(sc.Progress) as avgp
			from Course c
			join StudentCourse sc on c.ID = sc.CourseID
			group by 1) 
	as tmp)
order by 2, 3, 4 desc;





/*I.*/
/* Students are awarded two grades based on the minimum and maximum progress they are making in the courses. The grading scale is as follows:
Progress < 40: F, Progress < 50: D, Progress < 60: C, Progress < 70: B, Progress >= 70: A*/

/*Write a query which displays each student’s First Name, Last Name, Min Grade based on minimum progress, and Max Grade based on maximum progress.*/

select
s.FirstName as 'First Name',
s.LastName as 'Last Name',
case
	when min(progress) < 40 then 'F'
    when min(progress) < 50 then 'D'
    when min(progress) < 60 then 'C'
    when min(progress) < 70 then 'B'
    else 'A'
end as 'Min Grade',
case
	when max(progress) < 40 then 'F'
    when max(progress) < 50 then 'D'
    when max(progress) < 60 then 'C'
    when max(progress) < 70 then 'B'
    else 'A'
end as 'Max Grade'
from Student s
join StudentCourse sc on s.ID = sc.StudentID
group by s.ID
order by 2, 1;








