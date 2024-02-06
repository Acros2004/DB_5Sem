--TASK 1, 3 
--получить список всех PDB
SELECT name, open_mode FROM v$pdbs;
alter pluggable database KNS_PDB open;
--перечень экземпл€ров
select instance_name, con_id, version from v$instance;
--получить компоненты, версию и статус
select comp_id, comp_name, version, status from dba_registry;
--TASK 4 - создание pdb

--TASK 5 -- убеждаемс€ что pdb создалась
SELECT name, open_mode FROM v$pdbs;

show parameter;
--TASK 6 --подключитьс€ к pdb  и создать объекты
create tablespace TS_KNS_PDB
datafile 'ts_kns_pdb.dbf'
size 7M
autoextend on next 5M
maxsize 20M
extent management local; 


create temporary tablespace TS_KNS_PDB_TEMP
tempfile 'ts_kns_pdb_temp.dbf'
size 5M
autoextend on next 3M
maxsize 30M
extent management local;

alter session set "_ORACLE_SCRIPT"=true;

create role RL_KNSCORE_PDB;

grant create session,
      create table, drop any table,
      create view, drop any view,
      create procedure, drop any procedure
to RL_KNSCORE_PDB;

create profile PF_KNSCORE_PDB limit
    password_life_time unlimited
    sessions_per_user 3
    failed_login_attempts 30
    password_lock_time 1
    password_reuse_time 10
    connect_time 180
    idle_time 30;
    
create user U1_KNS_PDB identified by Pa$$w0rd
  default tablespace TS_KNS_PDB quota unlimited on TS_KNS_PDB
  temporary tablespace TS_KNS_PDB_TEMP
  profile PF_KNSCORE_PDB
  account unlock;
  
grant RL_KNSCORE_PDB to U1_KNS_PDB;

--TASK 8
--все табличные пространства
SELECT tablespace_name FROM dba_tablespaces;

SELECT file_name, tablespace_name, bytes, status
FROM dba_data_files;

UNION ALL
SELECT file_name, tablespace_name, bytes, status
FROM dba_temp_files;

SELECT grantee, granted_role, admin_option
FROM dba_role_privs;

SELECT profile FROM dba_profiles;

SELECT grantee, granted_role
FROM dba_role_privs
WHERE grantee IN (SELECT username FROM dba_users WHERE default_tablespace='TS_KNS_PDB');

--TASK 9
--создать с##KNS1 и создать два подключени€ к cdb и pdb
create user c##KNS1 identified by pass;
--в cdb и в pdb
grant create session to c##KNS1;
--второй комп
create user c##KNS2 identified by pass;
grant create session to c##KNS2;
grant RESTRICTED SESSION to c##KNS2;
grant RESTRICTED SESSION to c##KNS1;
grant RESTRICTED SESSION to U1_KNS_PDB;
grant create table, drop any table,
      create view, drop any view,
      create procedure, drop any procedure to c##KNS2;

--ALTER USER C##KNS1 QUOTA 2M ON TS_KNS;

select TABLESPACE_NAME from dba_tablespaces;
--TASK11
SELECT * FROM v$session;



--alter pluggable database all open;
--drop user c##KNS CASCADE;
--drop tablespace KNS_DB INCLUDING CONTENTS AND DATAFILES