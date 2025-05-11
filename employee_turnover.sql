select *
from employee_attrition_data;

-- Remove duplicate

with duplicate_cte as(
	select *,
    row_number() over(
    partition by full_name,department,job_role,hire_date,exit_date,status,engagement_score,salary,age,gender) as row_nums
    from employee_attrition_data)
    
    select *
    from duplicate_cte
    where row_nums > 1 ;
    
    select *
    from employee_attrition_data
    group by full_name,department,job_role,hire_date,exit_date,status,engagement_score,salary,age,gender
    having count(*)>1 ;
    
    -- No duplicate 
    
    -- Clean Columns
    
    select department
    from employee_attrition_data
    group by department 
	having count(department)>1 ;
    -- No issue
    
    select `status`
    from employee_attrition_data
    group by `status` 
	having count(`status`)>1 ;
    -- No issue
    
    select exit_date, str_to_date(exit_date, '%d/%m/%Y') as new_date
    from employee_attrition_data ;
    
     select hire_date, str_to_date(hire_date, '%d/%m/%Y') as new_date
    from employee_attrition_data ;
    
    update employee_attrition_data
    set exit_date = str_to_date(exit_date, '%d/%m/%Y') ;
    
	update employee_attrition_data
    set hire_date = str_to_date(hire_date, '%d/%m/%Y') ;
    
    select salary, trim(salary), trim(full_name),trim(department),trim(`status`),trim(age),trim(gender)
    from employee_attrition_data ;
    
    update employee_attrition_data
    set salary = trim(salary),
		full_name = trim(full_name),
        department = trim(department),
        `status` = trim(`status`),
        age = trim(age),
        gender = trim(gender);
        
    alter table employee_attrition_data
    modify column hire_date date ;
    
	alter table employee_attrition_data
    modify column exit_date date ;
    
    -- employees who left vs those still active
    
    select department, count(*) as total_employees, 
    sum(case when status = 'left' then 1 else 0 end) as leavers,
    sum(case when status = 'Active' then 1 else 0 end) as stayers
    from employee_attrition_data 
    group by department;
    
    -- attrition rate by department, job role, and tenure
    
    select department, round((sum(case when status = 'Left' then 1 else 0 end) * 100) / count(*), 2) as attrition_rate
    from employee_attrition_data
    group by department ;
    
    select job_role, round((sum(case when status = 'Left' then 1 else 0 end) * 100) / count(*), 2) as attrition_rate
    from employee_attrition_data
    group by job_role ;
    
    select *, round(datediff(if(exit_date ='0000-00-00', curdate(), exit_date),hire_date) /365,1) as tenure_years
    from employee_attrition_data ;
    
    select department, round(avg(engagement_score),2) as avg_engagement, (count(case when status ='Left' then 1 end) *100)/count(*) as attrition_rate
    from employee_attrition_data
    group by department
    order by avg_engagement asc;
    
    
    
