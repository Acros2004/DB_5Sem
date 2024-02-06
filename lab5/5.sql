--TASK 1 размер SGA
select * from V$SGA;
select SUM(value) from v$sga;

--TASK 2 размер основных пулов
select * from v$sga_dynamic_components  where current_size > 0;

--TASK 3 гранул для каждого пула
select component, granule_size from v$sga_dynamic_components  where current_size > 0;
select sum(min_size), sum(max_size), sum(current_size) from v$sga_dynamic_components;

--TASK 4 свободная память SGA
select current_size from v$sga_dynamic_free_memory;

--TASK 5 максимальный и целевой размер области SGA
SELECT value FROM v$parameter WHERE name = 'sga_max_size';
SELECT value FROM v$parameter WHERE name = 'sga_target';

--TASK 6 буферы
select component, current_size, min_size from v$sga_dynamic_components  where component='KEEP buffer cache' or component='DEFAULT buffer cache' or component='RECYCLE buffer cache';

--TASK 7 в пуле keep
create table MyTable(x int) storage(buffer_pool keep);
select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where lower(segment_name) like '%mytable%';
drop table MyTable;

--TASK 8 в пуле default
CREATE TABLE MyTable2 (x int) cache;
select segment_name, segment_type, tablespace_name, buffer_pool from user_segments where lower(segment_name) like '%mytable%';
DROP TABLE MyTable2;

--TASK 9
show parameter log_buffer;
--SELECT SUM(BYTES) FROM V$LOG;

--TASK 10 в большом пуле свободная память
select pool, name, bytes from v$sgastat where pool = 'large pool' and name = 'free memory';

--TASK 11 текущие соединения с инстенсем
select distinct username, service_name, server from v$session;

--TASK 12 фоновые процессы
select * from v$bgprocess;
select * from v$bgprocess where paddr != '00';

--TASK 13 серверных процессов
select * from v$process;

--TASK 14 сколько процессов DBW работает в настоящее время
select count(*) from v$bgprocess where paddr!= '00' and name like 'DBW%';
SELECT COUNT(*) FROM V$BGPROCESS WHERE NAME LIKE 'DBW%';

--TASK 15 сервисы
select * from v$services;

--TASK 16 параметры диспетчеров
select * from v$dispatcher;
show parameter dispatchers;

--TASK 17 процесс Listener(в services.msc)
select * from v$services;

--TASK 18 C:\WINDOWS.X64_193000_db_home\network\admin 
select * from v$active_services