create table t1 (
a number
);
insert into t1 values (1);
insert into t1 values (2);
insert into t1 values (3);

create view core as select * from  t1 where a >= 2;

select * from core;