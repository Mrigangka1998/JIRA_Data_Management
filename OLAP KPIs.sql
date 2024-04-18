--KPIs

--1.	Number of issues created, resolved, and closed per project: 

select project_id, project_name, num_issues as created_issues, resolved_issues, closed_issues
from mydb.jira_analytics.project_fact;

--2.	User Activity:

select u.user_key, u.user_id, u.name, a.num_issues_created, b.num_issues_resolved, c.num_issues_commented
from 
	mydb.jira_analytics.user_dim u
	left join 
	(
	select CREATE_USER_KEY as user_key, count(*) as num_issues_created
	from 
	    (
	    select issue_id, resolved_flag, CREATE_USER_KEY, RESOLVED_USER_KEY
	    from mydb.jira_analytics.issue_fact
	    )
	group by CREATE_USER_KEY
	) a 
	on u.user_key = a.user_key
	left join 
	(
	select RESOLVED_USER_KEY as user_key, sum(resolved_flag) as num_issues_resolved
	from 
	    (
	    select issue_id, resolved_flag, CREATE_USER_KEY, RESOLVED_USER_KEY
	    from mydb.jira_analytics.issue_fact
	    )
	group by RESOLVED_USER_KEY
	) b 
	on u.user_key = b.user_key 
	left join 
	(
	select AUTHOR_USER_KEY as user_key, count(distinct issue_id) as num_issues_commented
	from mydb.jira_analytics.comment_fact
	group by AUTHOR_USER_KEY
	) c 
	on u.user_key = c.user_key;

--3.	Project Completion Rate: 

select project_id, project_name,PERC_RESOLVED_BEFORE_DUE_DATE_ISSUES
from mydb.jira_analytics.project_fact;


select (select count(*) from mydb.jira_analytics.project_fact where PERC_RESOLVED_BEFORE_DUE_DATE_ISSUES = 100) / (select count(*) from mydb.jira_analytics.project_fact) as perc_projects_completed_before_due_date;


--4.	Cycle Time


select issue_id, 
datediff(second, creation_datetime, resolution_datetime) as cycle_time_secs,
datediff(minute, creation_datetime, resolution_datetime) as cycle_time_mins,
datediff(hour, creation_datetime, resolution_datetime) as cycle_time_hrs,
datediff(day, creation_datetime, resolution_datetime) as cycle_time_days
from
	(
	select a.issue_id, 
	TIMESTAMP_NTZ_FROM_PARTS(b.date::DATE, c.time_of_day::TIME) as creation_datetime,
	TIMESTAMP_NTZ_FROM_PARTS(d.date::DATE, e.time_of_day::TIME) as resolution_datetime
	from mydb.jira_analytics.issue_fact a
	inner join mydb.jira_analytics.date_dim b
	on a.CREATE_DATE_KEY = b.DATE_KEY
	inner join mydb.jira_analytics.timeofday_dim c
	on a.create_time_key = c.timeofday_key
	inner join mydb.jira_analytics.date_dim d
	on a.RESOLVED_DATE_KEY = d.DATE_KEY
	inner join mydb.jira_analytics.timeofday_dim e
	on a.RESOLVED_TIME_KEY = e.timeofday_key
	where a.resolved_flag = 1
	) a ;


select  
avg(datediff(second, creation_datetime, resolution_datetime)) as avg_cycle_time_secs,
avg(datediff(minute, creation_datetime, resolution_datetime)) as avg_cycle_time_mins,
avg(datediff(hour, creation_datetime, resolution_datetime)) as avg_cycle_time_hrs,
avg(datediff(day, creation_datetime, resolution_datetime)) as avg_cycle_time_days
from
	(
	select a.issue_id, 
	TIMESTAMP_NTZ_FROM_PARTS(b.date::DATE, c.time_of_day::TIME) as creation_datetime,
	TIMESTAMP_NTZ_FROM_PARTS(d.date::DATE, e.time_of_day::TIME) as resolution_datetime
	from mydb.jira_analytics.issue_fact a
	inner join mydb.jira_analytics.date_dim b
	on a.CREATE_DATE_KEY = b.DATE_KEY
	inner join mydb.jira_analytics.timeofday_dim c
	on a.create_time_key = c.timeofday_key
	inner join mydb.jira_analytics.date_dim d
	on a.RESOLVED_DATE_KEY = d.DATE_KEY
	inner join mydb.jira_analytics.timeofday_dim e
	on a.RESOLVED_TIME_KEY = e.timeofday_key
	where a.resolved_flag = 1
	) a ;


--5.	Project progress and status based on issue statuses, priorities, and due dates

select project_id, project_name, 
num_issues, to_do_issues, resolved_issues, in_progress_issues, 
lowest_priority_issues, low_priority_issues, medium_priority_issues, high_priority_issues, highest_priority_issues, 
resolved_before_due_date_issues, perc_to_do_issues, perc_resolved_issues, perc_in_progress_issues, 
perc_lowest_priority_issues, perc_low_priority_issues, perc_medium_priority_issues, 
perc_high_priority_issues, perc_highest_priority_issues, perc_lowest_priority_issues_done, 
perc_low_priority_issues_done,  perc_medium_priority_issues_done, perc_high_priority_issues_done, 
perc_highest_priority_issues_done, perc_resolved_before_due_date_issues
from mydb.jira_analytics.project_fact;



