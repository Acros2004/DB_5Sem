SET serveroutput ON;
alter session set nls_date_format = 'DD-MM-YYYY';

-- 1. �������� � ������� TEACHERS ��� ������� BIRTHDAY� SALARY, ��������� �� ����������.
alter table TEACHER add BIRTHDAY Date;
alter table TEACHER add SALARY number(4,0);
select * from teacher;

UPDATE TEACHER SET BIRTHDAY='10.11.1963', SALARY=50 WHERE TEACHER='����';
UPDATE TEACHER SET BIRTHDAY='14.11.2022', SALARY=78 WHERE TEACHER='���';
UPDATE TEACHER SET BIRTHDAY='23.05.1978', SALARY=5 WHERE TEACHER='���';
UPDATE TEACHER SET BIRTHDAY='10.11.1959', SALARY=12 WHERE TEACHER='������';
UPDATE TEACHER SET BIRTHDAY='03.06.1983', SALARY=34 WHERE TEACHER='�����';
UPDATE TEACHER SET BIRTHDAY='30.08.1987', SALARY=45 WHERE TEACHER='������';
UPDATE TEACHER SET BIRTHDAY='15.01.1995', SALARY=33 WHERE TEACHER='����';
UPDATE TEACHER SET BIRTHDAY='17.03.1999', SALARY=80 WHERE TEACHER='����';
UPDATE TEACHER SET BIRTHDAY='02.12.1932', SALARY=120 WHERE TEACHER='����';


-- 2. �������� ������ �������������� � ���� ������� �.�.
select teacher_name from TEACHER;
      select regexp_substr(teacher_name,'(\S+)',1, 1)||' '||
      substr(regexp_substr(teacher_name,'(\S+)',1, 2),1, 1)||'. '||
      substr(regexp_substr(teacher_name,'(\S+)',1, 3),1, 1)||'. '
    from teacher;

-- 3. �������� ������ ��������������, ���������� � �����������.
select * from teacher
    where TO_CHAR((birthday), 'd') = 1;

-- 4. �������� �������������, � ������� ��������� ������ ��������������, ������� �������� � ��������� ������.
create view NextMonthBirth as
    select * from teacher
    where TO_CHAR(sysdate,'mm') + 1 = TO_CHAR(birthday, 'mm');
    
    select * from NextMonthBirth;
    --drop view NextMonthBirth;
--5
drop view Count_Birthday;
create view Count_Birthday as 
    select TO_CHAR(birthday,'mm') "�����",count(*) "���-��"
    from teacher
    group by TO_CHAR(birthday,'mm')
    having count(*) >= 1;

select * from Count_Birthday;
-- 6. ������� ������ � ������� ������ ��������������, � ������� � ��������� ���� ������.
select TO_CHAR(birthday, 'yyyy') from teacher where teacher.teacher = '����';
    
cursor TeacherBirtday(teacher%rowtype) 
    return teacher%rowtype is
    select * from teacher
    where MOD(((TO_CHAR(sysdate,'yyyy') + 1) - TO_CHAR(birthday, 'yyyy')), 5) = 0; 

-- 7. ������� ������ � ������� ������� ���������� ����� �� �������� � ����������� ���� �� �����, ������� ������� �������� �������� ��� ������� ���������� � ��� ���� ����������� � �����.
cursor tAvgSalary(teacher.salary%type,teacher.pulpit%type) 
      return teacher.salary%type,teacher.pulpit%type  is
        select floor(avg(salary)), pulpit
        from teacher
        group by pulpit;

--���� �������� ��� �. ���������� 
    select round(AVG(T.salary),3),P.faculty
    from teacher T
    inner join pulpit P
    on T.pulpit = P.pulpit
    group by P.faculty
    union
      select floor(avg(salary)), teacher.pulpit
        from teacher
        group by teacher.pulpit
    order by faculty;

-- ��� ���� ����������� � �����
    select round(avg(salary),3) from teacher;
    
-- 8. �������� ����������� ��� PL/SQL-������ (record) � ����������������� ������ � ���. ����������������� ������ � ���������� ��������. ����������������� � ��������� �������� ����������. 
    declare
        type ADDRESS is record
        (
          town nvarchar2(20),
          country nvarchar2(20)
        );
        type PERSON is record
        (
          name teacher.teacher_name%type,
          pulp teacher.pulpit%type,
          homeAddress ADDRESS
        );
      per1 PERSON;
      per2 PERSON;
    begin
      select teacher_name, pulpit into per1.name, per1.PULP
      from teacher
      where teacher='���';
      per1.homeAddress.town := '�����';
      per1.homeAddress.country := '��������';
      per2 := per1;
      dbms_output.put_line( per2.name||' '|| per2.pulp||' �� '||
                            per2.homeAddress.town||', '|| per2.homeAddress.country);
    end;