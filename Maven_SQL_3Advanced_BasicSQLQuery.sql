Use Maven_Advanced_SQL;

Select * from [dbo].[students]
Select * from [dbo].[happiness_scores_Import];


Select * from [dbo].[happiness_scores_Import];
Drop Table [dbo].[happiness_scores_Import]
Select * from [dbo].[happiness_scores_Import];

----------------------------Basic SQL Review---------------------------------
Select  s.grade_level, MAX(s.gpa) as max_gpa
from [dbo].[students] as s
where s.school_lunch = 'Yes'
group by s.grade_level
having MAX(s.gpa) < 4.0
order by s.grade_level asc;


Select distinct grade_level from students;
Select count(distinct grade_level) from students;
Select max(gpa) - min(gpa) as gpa_range from students;
Select * from students where grade_level <12 and school_lunch ='Yes';
Select * from students where grade_level in (10,11,12);
Select * from students where email is not null;
Select * from students where email like '%.edu';
Select student_name, gpa from students order by gpa desc;
Select top 10 * from students;
Select student_name, grade_level, 
	case when grade_level=9 then 'Freshman'
		when grade_level=10 then 'Sophomore'
		when grade_level=11 then 'Junior'
		else 'Senior' end as student_class
from students;



----------------------------------------Multi Table Analysis-----------------------------------
Select * from happiness_scores hs
inner join country_stats cs
on hs.country 







