create table KNS_t( x number(3), s varchar2(50) primary key);
--
insert into KNS_t values (1, 'im');
insert into KNS_t values (1, 'best');
insert into KNS_t values (1, 'student');
commit;
select * from KNS_t;
--
update KNS_t set x = 2 where s = 'best';
update KNS_t set x = 3 where s = 'student';
commit;
--
select * from KNS_t where x >= 2;
select x,count(*) from KNS_t group by x;
--
insert into KNS_t values (4, 'test');
delete KNS_t where x = 4;
commit;
--
create table KNS_t1 
(
    z number(3) primary key, b varchar2(50),
    foreign key (b) references KNS_t (s)
);
insert into KNS_t1 values (2, 'best');
insert into KNS_t1 values (5, 'student');
commit;
--
select * from KNS_t1;

select x,s,z,b from KNS_t
    inner join KNS_t1 on x = z;

select x,s,z,b from KNS_t
    left outer join KNS_t1 on x = z;

select x,s,z,b from KNS_t
    right outer join KNS_t1 on x = z;
--
drop table KNS_t;
drop table KNS_t1;

