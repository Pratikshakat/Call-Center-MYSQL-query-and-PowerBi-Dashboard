-- Create Sql file for analysis of call center 

-- Show Databases in system
Show databases;

-- Drop if there exists any database of same name and datatype
drop database if exists call_center_project;

-- Create datatype Call Center project
create database call_center_project;

-- Use the database call center project 
use call_center_project;

/* Create table for analysis */

set sql_mode = "";

-- Create table calls if exists then drop it and create new

drop table if exists calls;

create table calls(
                  ID varchar(30),
                  customer_name varchar(50),
                  sentiment varchar(15),
                  csat_score varchar(2) default NULL,
                  call_timestamp varchar(10),
                  reason varchar(30),
                  city varchar(40),
                  state varchar(30),
                  channel varchar(15),
                  response_time varchar(15),
                  call_duration_in_minutes int,
                  call_center varchar(20)
                  );

-- Describe calls table
desc calls;

-- Show all data in table of calls
select * from calls;

-- if Sql query is in safe mode then make it zero to update it easily
set sql_safe_updates = 0;

-- Update calls date call timestamp to change in date format
update calls 
set call_timestamp = str_to_date(call_timestamp, "%d-%m-%Y");

-- Alter datatype of call timestamp
alter table calls
change column call_timestamp call_timestamp date;

-- Update Customer Satisfaction Score in calls table
update calls 
set csat_score = NULL where csat_score = 0.0;

-- Alter datatype Customer Satisfaction Score to integer
alter table calls
change column csat_score csat_score int;

-- After all updates activate safe updates to one to make file safe
set sql_safe_updates = 1;

-- Show all tables in database
show tables;

-- Checking distinct values of some columns:

select distinct sentiment from calls;
select distinct reason from calls;
select distinct state from calls;
select distinct channel from calls;
select distinct response_time from calls;
select distinct call_center from calls;

-- Total Count of rows in Calls Center Data
select count(*) as Total_Count_Call_Center_Data from calls;

/* The Count and Percentage from 
 total from each of the distinct values we got from calls. 
 To see the distribution of our calls amoung different
 columns. Let's see the reason column:*/
 
 select sentiment, count(*) as Total_Count_Per_Sentiment, 
 round(count(*)/(select count(*) from calls) * 100, 1) as Percentage 
 from calls 
 group by sentiment
 order by 3 desc; 
 
 select reason, count(*) as Total_Count_per_reason, 
 round(count(*)/(select count(*) from calls) * 100, 1) as Percentage 
 from calls 
 group by reason
 order by 3 desc; 
 
 /* Here we can see that Billing Questions amount 
 to a whooping 71% of all calls, with service outage 
 and payment related calls both are 14.4% of all calls.*/
 
 select channel, count(*) as Total_Count_per_Channel, 
 round(count(*)/(select count(*) from calls) * 100, 1) as Percentage 
 from calls 
 group by channel
 order by 3 desc;
 
 select response_time, count(*) as Total_Count_per_Responce_Time, 
 round(count(*)/(select count(*) from calls) * 100, 1) as Percentage 
 from calls 
 group by response_time
 order by 3 desc;
 
 select call_center, count(*) as Total_Count_per_Call_Center, 
 round(count(*)/(select count(*) from calls) * 100, 1) as Percentage 
 from calls 
 group by call_center
 order by 3 desc;
 
 select state, count(*) as Total_Count_per_State,
 round(count(*)/(select count(*) from calls) * 100, 1) as Percentage
 from calls group by state order by 2 desc;
 
 

 -- Moving on, Which day has the most call?
 
 select dayname(call_timestamp) as Day_of_call,
 count(*) as num_of_calls from calls
 group by Day_of_call
 order by num_of_calls desc;
 
 -- Friday has the most number of calls while Sunday has the least.
 
 -- Aggregations :
 
 -- Minimum, Maximum and Average Customer Satisfaction score 
 
 select min(csat_score) as Minimum_Csat_Score,
 max(csat_score) as Maximum_Csat_Score,
 avg(csat_score) as Average_Csat_Score
 from calls where csat_score != 0; # Why csat_score != 0, 
 # MySql added 0 to blank rows. But the minimum is 1.
 
 -- Earliest and Most Recent Call Timestamp(date)
 
 select min(call_timestamp) as earliest_date, 
 max(call_timestamp) as most_recent from calls;
 
 /* 2020-01-01 is earliest date and 
 2020-01-31 is most recent date from calls data */
 
 -- Minimum, Maximum and Average Call Duration Minutes from Calls
 
 select min(call_duration_in_minutes) as Minimum_Call_duration,
 max(call_duration_in_minutes) as Maximum_Call_duration,
 avg(call_duration_in_minutes) as Average_Call_duration
 from calls;
 
 /* Minimum call duration - 5 Minute
 Maximum call duration - 45 Minute
 Average call duration - 25.0122 Minute */
 
 -- Call center wise responce time and count of call records.
 
 select call_center, response_time, count(*) as count_of_call_records
 from calls
 group by call_center, response_time
 order by 1,3 desc;
 
 /* Here we are checking how many calls are within, below or above 
 the Service-Level -Agreement time. For example we see that Chicago/IL 
 call center has around 3359 calls Within SLA , and then Denver/CO has 
 692 calls below SLA. you get it.*/
 
 -- Average call Duration in minutes of each call center
 
 select call_center, 
 avg(call_duration_in_minutes) as Average_call_duration
 from calls group by call_center order by 2 desc;
 
 
-- Average call Duration in minutes of each channel
 
 select channel,avg(call_duration_in_minutes) as Average_call_duration
 from calls group by channel order by 2 desc;
 
 -- Count of Call records State wise
 
 select state, count(*) as Count_call_records from calls
 group by 1 order by 2 desc;
 
 -- Count of Call records State and Reason wise
 
 select state, reason, count(*) as Count_call_records from calls
 group by 1, 2 order by 1,3 desc;
 
 -- Count of Call records State and Sentiment wise
 
 select state, sentiment, count(*) as Count_call_records from calls
 group by 1,2 order by 1,3 desc;
 
 -- Average Customer Satisfaction Score(Csat_Score) for each State
 
 select state, avg(csat_score) as Average_Csat_Score from calls
 group by state order by 2 desc;
 
 -- Average Call Duration Minutes for each State
 
 select state, avg(call_duration_in_minutes) as Average_Call_Duration_in_Minutes
 from calls group by state order by 2 desc;
 
 -- 1055 error only full group by then replace it by ''
 
 SELECT @@sql_mode; 
 SET local sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));
 
 /* query the maximum call duration each day and then sort by it.*/
 
select call_timestamp, 
max(call_duration_in_minutes) over(partition by call_timestamp) as 
maximum_call_duration_in_minutes from calls 
group by call_timestamp order by 2 desc;

/* Here we see that for example on Oct 4th the maximum call duration was 45 minutes
 long while on Oct 8th it was 27 minutes long.*/