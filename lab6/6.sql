--1
--C:\WINDOWS.X64_193000_db_home\network\admin

--2 connect system (Qwerty12345)
show parameter instance

--3
--sqlplus
--connect /as SYSDBA
--alter pluggable database all open;
--connect system
--alter session set container=KNS_PDB;
--
select * from v$tablespace;
select * from sys.dba_data_files;
select * from dba_role_privs;
select * from all_users;

--4 regedit
--Компьютер\HKEY_LOCAL_MACHINE\SOFTWARE\ORACLE
--5,6 
--connect U1_KNS_PDB/Pa$$w0rd@//localhost:1521/KNS_PDB.mshome.net
--CREATE TABLE KNS_table (i number);
--INSERT INTO KNS_table VALUES (1);

--7
select * from KNS_table;


--8
help timing
timi start
timi show
select * from KNS_table;
timi stop

--9
describe KNS_table

--10-cdb
select *from dba_segments where owner = 'U1_KNS_PDB'; 
select * from user_segments; 

--11
create view L6 as
select count(*) as count,
    sum(extents) as count_extents,
    sum(blocks) as count_blocks,
    sum(bytes) as Kb from user_segments;
    
select * from L6;