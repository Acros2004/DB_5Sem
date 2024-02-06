drop tablespace kns_qdata including contents and datafiles;
-- 1
select tablespace_name, file_name from dba_data_files; 
select tablespace_name, file_name from dba_temp_files; 
-- 2
create tablespace kns_qdata 
datafile 'kns_qdata.dbf'
size 10m
extent management local
offline;

alter tablespace kns_qdata online;
-----
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
select *from DBA_USERS;
--alter session set "_oracle_script"=true;
--drop user kns cascade;
create user kns identified by 12345;
grant create session,create table, create view, 
create procedure,drop any table,drop any view,
drop any procedure to kns;
-------------
alter user kns quota 2m on kns_qdata;
-- соединение kns к orcl
create table KNS_T1(
x number(20) primary key,
y number(20)) tablespace kns_qdata;
grant insert on KNS_T1 to kns;

insert into KNS_T1 values (1, 101);
insert into KNS_T1 values (2, 102);
insert into KNS_T1 values (3, 103);
select * from KNS_T1;
-- 3--cdb
select * from dba_segments where tablespace_name = 'KNS_QDATA';
select * from dba_segments where segment_name = 'KNS_T1';
select * from dba_segments;
-- 4 --used
drop table KNS_T1;
select * from user_recyclebin;
-- 5
flashback table KNS_T1 to before drop;
SELECT * FROM KNS_T1;
-- 6
begin
for x in 4..10004
loop
insert into KNS_T1 values(x, x);
end loop;
commit;
end;

select count(*) from KNS_T1;
-- 7 --cdb
select * from DBA_EXTENTS where SEGMENT_NAME like 'KNS_T1';
select extent_id, blocks, bytes from DBA_EXTENTS where SEGMENT_NAME like 'KNS_T1';
select * from DBA_EXTENTS;
-- 8
drop tablespace kns_qdata including contents and datafiles;
-- 9
select * from v$log;
-- 10
select * from v$logfile;

-- 11--04.10.2023 --19:57
alter system switch logfile;
select * from v$log;

-- 12
alter database add logfile group 4 'C:\OracleDB\oradata\ORCL\REDO04.LOG' size 50m blocksize 512;
alter database add logfile member 'C:\OracleDB\oradata\ORCL\REDO041.LOG'  to group 4;
alter database add logfile member 'C:\OracleDB\oradata\ORCL\REDO042.LOG'  to group 4;

select * from v$logfile;
select group#, sequence#, bytes, members, status, first_change# from v$log;
-- 13
alter database drop logfile member 'C:\OracleDB\oradata\ORCL\REDO041.LOG';
alter database drop logfile member 'C:\OracleDB\oradata\ORCL\REDO042.LOG';
alter database clear unarchived logfile group 4;
alter database drop logfile group 4;

select group#, sequence#, bytes, members, status, first_change# from v$log;
select * from v$logfile;
-- 14
select name, log_mode from v$database;
select instance_name, archiver, active_state from v$instance;
-- 15
select * from v$archived_log;
-- 16 
-- включить архивирование через sqlplus на сервере
-- connect / as sysdba;
-- shutdown immediate;
-- startup mount;
-- alter database archivelog;
-- alter database open;
select name, log_mode from v$database;
select instance_name, archiver, active_state from v$instance;
-- 17
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1 ='LOCATION=C:\OracleDB\oradata\ORCL\archive.arc';
alter system switch logfile;
select * from v$archived_log;
-- 18
-- alter database noarchivelog;
select name, log_mode from v$database;
select instance_name, archiver, active_state from v$instance;
-- 19
select * from v$controlfile;
-- 20
show parameter control;
-- 21
-- C:\OracleDB\admin\orcl\pfile
-- 22 
create pfile = 'kns_pfile.ora' from spfile;
-- C:\WINDOWS.X64_193000_db_home\database\kns_pfile.ora
-- 23
-- C:\WINDOWS.X64_193000_db_home\database\PWDorcl.ora
select * from v$pwfile_users;
-- 24
select * from v$diag_info;
-- 25
-- C:\app\orcl\diag\rdbms\orcl\orcl\alert\log.xml