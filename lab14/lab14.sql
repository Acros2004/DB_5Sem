ALTER SESSION SET nls_date_format='dd-mm-yyyy hh24:mi:ss';
ALTER SYSTEM SET JOB_QUEUE_PROCESSES = 5;
set serveroutput on;
create table max_salary_of_teacher
(
  teacher varchar(200),
  teacher_name varchar(200),
  pulpit varchar(100),
  salary int
);

create table audit_jobs
(
  status   nvarchar2(50),
  error_message nvarchar2(500),
  datetime date default sysdate
);

select * from teacher;
ALTER TABLE teacher
ADD (SALARY NUMBER);

update teacher set SALARY = 25 where teacher = 'ÌØÊÂÑÊ';
commit;

create or replace procedure procedure_copy_max_salary(l_salary number)
is
err_message varchar2(500);
cursor c_teacher is select * from teacher where SALARY > l_salary;
begin
for n in c_teacher
 loop
  insert into max_salary_of_teacher (teacher, teacher_name, pulpit, salary) values (n.teacher, n.teacher_name, n.pulpit, n.salary);
 end loop;
delete from teacher where SALARY > l_salary;
insert into audit_jobs (status) values ('success');
commit;
exception
when others then
err_message := sqlerrm;
insert into audit_jobs (status, error_message) values ('fail', err_message);
commit;
end procedure_copy_max_salary;

BEGIN procedure_copy_max_salary(30); END;

select * from max_salary_of_teacher;
select * from teacher where salary > 30;
select * from audit_jobs;

--------------JOB------------------
declare 
job_number user_jobs.job % type;
begin
dbms_job.submit(job_number, 'BEGIN procedure_copy_max_salary(30); END;', sysdate, 'SYSDATE + 1'); --SYSDATE + 30 / (60 * 24 * 60)  ÷åðåç 30 ñåê 
commit;
dbms_output.put_line(job_number);
end;



begin
dbms_job.run(5);
end;

begin
dbms_job.broken(5, true, null);
end;

begin
dbms_job.remove(3);
end;


select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;

------------- DBMS_SHEDULER ------------------

create or replace procedure procedure_copy_max_salary_no_args
is
err_message varchar2(500);
cursor c_teacher is select * from teacher where SALARY > 30;
begin
for n in c_teacher
 loop
  insert into max_salary_of_teacher (teacher, teacher_name, pulpit, salary) values (n.teacher, n.teacher_name, n.pulpit, n.salary);
 end loop;
delete from teacher where SALARY > 30;
insert into audit_jobs (status) values ('success');
commit;
exception
when others then
err_message := sqlerrm;
insert into audit_jobs (status, error_message) values ('fail', err_message);
commit;
end procedure_copy_max_salary_no_args;

begin
dbms_scheduler.create_schedule(
  schedule_name => 'SHEDULER_2',
  start_date => sysdate,
  repeat_interval => 'FREQ=DAILY',
  comments => 'SHEDULER_1 start');
end;

select * from user_scheduler_schedules;

begin
dbms_scheduler.create_program(
  program_name => 'PROGRAM_SHEDULER_2',
  program_type => 'STORED_PROCEDURE',
  program_action => 'procedure_copy_max_salary_no_args',
  number_of_arguments => 0,
  enabled => true,
  comments => 'procedure_copy_max_salary_no_args');
end;

select * from  user_scheduler_programs;
-- delete from user_scheduler_programs where PROGRAM_NAME = 'JOB_1';
begin
dbms_scheduler.create_job(
  job_name => 'JOB_2',
  program_name => 'PROGRAM_SHEDULER_2',
  schedule_name => 'SHEDULER_2',
  enabled => true);
end;

select * from user_scheduler_jobs;
select * from max_salary_of_teacher;
select * from audit_jobs;


begin
DBMS_SCHEDULER.DISABLE('JOB_2');
end;


begin
DBMS_SCHEDULER.RUN_JOB('JOB_2');
end;

begin
DBMS_SCHEDULER.STOP_JOB('JOB_2');
end;

begin
DBMS_SCHEDULER.DROP_JOB( JOB_NAME => 'JOB_2');
end;