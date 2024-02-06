--1 
grant create session, create sequence, create cluster, create synonym, 
create public synonym, create view, create MATERIALIZED view to U1_KNS_PDB;
commit;
--2 
create sequence S1
increment by 10
start with 1000
nominvalue
nomaxvalue
nocycle
nocache
noorder;
    
select S1.nextval from dual;
select S1.currval from dual;
select S1.currval, S1.nextval from dual; 
drop sequence S1;
--3 
create sequence S2
start with 10
increment by 10
maxvalue 100
nocycle;

select S2.nextval, S2.nextval from dual;
select S2.currval from dual;
--ORA-08004
drop sequence S2;
--4 
create sequence S3
start with 10
increment by -10
minvalue -100
nocycle
order;
--ORA-04008: START WITH не может превышать MAXVALUE
create sequence S3
start with -10
increment by -10
minvalue -100
nocycle
order;

select S3.nextval from dual;
select S3.currval from dual;
--ORA-08004
drop sequence S3;
--5
create sequence S4
start with 1
increment by 1
minvalue 10
cycle
cache 5
noorder;
--ORA-04015: должен задавать MAXVALUE
create sequence S4
start with 1
increment by 1
maxvalue 10
cycle
cache 5
noorder;
    
select S4.nextval from dual;
select S4.currval from dual;
drop sequence S4;
--6 
select *from SYS.all_sequences where sequence_owner like 'U1_KNS_PDB';
--7 
create table T1 (
N1 number(20),
N2 number(20),
N3 number(20),
N4 number(20)) 
cache storage(buffer_pool keep);

begin
for i in 1..7
loop
insert into T1(N1, N2, N3, N4) values (S1.nextval, S2.nextval, S3.nextval, S4.nextval);
end loop;
end;

select *from T1;
drop table T1;
--8 
create cluster ABC (
X number(10),
V varchar2(12)) 
hashkeys 200;

drop cluster ABC;
--9 
create table A(
XA number(10),
VA varchar2(12), 
ZA number(10))
cluster ABC (XA, VA); 

drop table A;
--10 
create table B(
XB number(10),
VB varchar2(12), 
ZB number(10)) cluster ABC (XB, VB); 

drop table B;
--11
create table C(
XC number(10),
VC varchar2(12), 
ZC number(10)) cluster ABC (XC, VC); 

drop table C;
--12--от system
select * from dba_segments where owner like 'U1_KNS_PDB';
select * from dba_clusters where owner like 'U1_KNS_PDB';
--13  
create synonym SC for U1_KNS_PDB.C;
select * from SC;

drop synonym SC;
--14 
create public synonym SB for U1_KNS_PDB.B;
select * from SB;create table A1(
x number(10) primary key,
y varchar(12));

drop public synonym SB;
--15

create table B1(
x number(10),
foreign key (x) references A1(x),
y varchar(12));

create view V1 as 
select A1.y as AY, B1.y as BYY,A1.x 
from A1 inner join B1 on A1.x=B1.x;

insert into A1 (x, y) values (1,'a');
insert into A1 (x, y) values (2,'b');
insert into A1 (x, y) values (3,'c');
insert into B1 (x, y) values (1,'d');
insert into B1 (x, y) values (2,'e');
insert into B1 (x, y) values (3,'f');

select * from A1;
select * from B1;
select * from V1;

drop view V1;
drop table B1;
drop table A1;
--16 
create materialized view MV
build immediate 
refresh complete on demand next sysdate + numtodsinterval(1, 'minute') 
as select * from A1;
select * from MV;    

insert into A1 (x, y) values (4,'aa');
insert into A1 (x, y) values (6,'bbc');
commit;

drop materialized view MV;