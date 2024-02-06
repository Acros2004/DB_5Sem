SET SERVEROUTPUT ON;
ALTER SESSION SET nls_date_format='dd-mm-yyyy hh24:mi:ss';

--1.	�������� �������, ������� ��������� ���������, ���� �� ������� ��������� ����.
    CREATE TABLE tabl(
        a int primary key,
        b varchar(30)
    );


--2.	��������� ������� �������� (10 ��.).
    DECLARE 
        i int :=0;
    BEGIN
        WHILE i<10
        LOOP
            INSERT INTO tabl(a,b)
            values (i,'a');
            i:= i+1;
        END LOOP;
    END;

    SELECT * FROM tabl;
    

--3.	�������� BEFORE � ������� ������ ��������� �� ������� INSERT, DELETE � UPDATE. 
--4.	���� � ��� ����������� �������� ������ �������� ��������� �� ��������� ������� (DMS_OUTPUT) �� ����� ����������� ������. 
    CREATE OR REPLACE TRIGGER Input_trigger_before
    before insert on tabl
    BEGIN dbms_output.put_line('Insert trigger before'); END;
    insert into tabl values (26,'nik');
    
    
    CREATE OR REPLACE TRIGGER Delete_trigger_before
    before delete on tabl
    BEGIN dbms_output.put_line('Delete trigger before'); END;
    delete tabl where a=26;
    
    
    CREATE OR REPLACE TRIGGER Update_trigger_before
    before update on tabl
    BEGIN dbms_output.put_line('Update trigger before'); END;
    update tabl set a=60 where a=3;
    
       
--5.	�������� BEFORE-������� ������ ������ �� ������� INSERT, DELETE � UPDATE.
    CREATE OR REPLACE TRIGGER Input_for_each_trigger_before
    before insert on tabl
    for each row
    BEGIN dbms_output.put_line('Input_for_each_trigger before'); END;
    
    insert into tabl values (40,'nik');

    CREATE OR REPLACE TRIGGER Update_for_each_trigger_before
    before update on tabl
    for each row
    BEGIN dbms_output.put_line('Update_for_each_trigger before'); END;
    
    update tabl set a=41 where a=40;

    CREATE OR REPLACE TRIGGER Delete_for_each_trigger_before
    before delete on tabl
    for each row
    BEGIN dbms_output.put_line('Delete_for_each_trigger before'); END;
    
    delete tabl where a=41;
    
    
--6.	��������� ��������� INSERTING, UPDATING � DELETING.
    CREATE OR REPLACE TRIGGER Trigger_ing
    after insert or update or delete on tabl
    BEGIN
    IF INSERTING then
        dbms_output.put_line('Inserting after');
    ELSIF UPDATING then
        dbms_output.put_line('Updating after');
    ELSIF DELETING then
        dbms_output.put_line('Deleting after');
    END IF;
    END; 
    
    insert into tabl values (40,'nik');
    update tabl set a=41 where a=40;
    delete tabl where a=41;
    
    
--7.	������������ AFTER-�������� ������ ��������� �� ������� INSERT, DELETE � UPDATE.
    CREATE OR REPLACE TRIGGER Input_trigger
    after insert on tabl
    BEGIN dbms_output.put_line('Insert trigger after'); END;

    CREATE OR REPLACE TRIGGER Delete_trigger
    after delete on tabl
    BEGIN dbms_output.put_line('Delete trigger after'); END;

    CREATE OR REPLACE TRIGGER Update_trigger
    after update on tabl
    BEGIN dbms_output.put_line('Update trigger after'); END;
    
    insert into tabl values (40,'nik');
    update tabl set a=41 where a=40;
    delete tabl where a=41;


--8.	������������ AFTER-�������� ������ ������ �� ������� INSERT, DELETE � UPDATE.
    CREATE OR REPLACE TRIGGER Input_for_each_trigger
    after insert on tabl
    for each row
    BEGIN dbms_output.put_line('Input_for_each_trigger after'); END;
    
    CREATE OR REPLACE TRIGGER Update_for_each_trigger
    after update on tabl
    for each row
    BEGIN dbms_output.put_line('Update_for_each_trigger after'); END;

    CREATE OR REPLACE TRIGGER Delete_for_each_trigger
    after delete on tabl
    for each row
    BEGIN dbms_output.put_line('Delete_for_each_trigger after'); END;
    
    insert into tabl values (40,'nik');
    update tabl set a=41 where a=40;
    delete tabl where a=41;
    

--9.	�������� ������� � ������ AUDIT. ������� ������ ��������� ����: OperationDate, 
--OperationType (�������� �������, ���������� � ��������),
--TriggerName(��� ��������),
--Data (������ � ���������� ����� �� � ����� ��������).

    create table AUDITS(
        OperationDate date,         --('DD-MM-YYYY  HH24:MI:SS'),
        OperationType varchar2(40), --i.d.u.
        TriggerName varchar2(40),
        Data varchar2(40)           --���� ����� �� � ����� ��������
        );
        

--10.	�������� �������� ����� �������, ����� ��� �������������� ��� �������� � �������� �������� � ������� AUDIT.
    CREATE OR REPLACE TRIGGER AUDITS_trigger_before
    before insert or update  or delete on tabl
    BEGIN
        if inserting then
            dbms_output.put_line('before_insert_AUDITS');
            INSERT INTO AUDITS(OperationDate, OperationType, TriggerName, Data)
            SELECT sysdate,'Insert', 'AUDITS_trigger_before',concat(tabl.a ,tabl.b)
            FROM tabl;
        elsif updating then
            dbms_output.put_line('before_update_AUDITS');
            INSERT INTO AUDITS(OperationDate, OperationType, TriggerName, Data)
            SELECT sysdate,'Update', 'AUDITS_trigger_before',concat(tabl.a ,tabl.b)
            FROM tabl;
        elsif deleting then
            dbms_output.put_line('before_delete_AUDITS');
            INSERT INTO AUDITS(OperationDate, OperationType, TriggerName, Data)
            SELECT sysdate,'Delete', 'AUDITS_trigger_before',concat(a ,b)
            FROM tabl;
        END if;
    END;
    -------------------------------
    CREATE OR REPLACE TRIGGER AUDITS_trigger_after
    after insert or update  or delete on tabl
    BEGIN
        if inserting then
            dbms_output.put_line('after_insert_AUDITS');
            INSERT INTO AUDITS(OperationDate, OperationType, TriggerName, Data)
            SELECT sysdate,'Insert', 'AUDITS_trigger_after',concat(tabl.a ,tabl.b)
            FROM tabl;
        elsif updating then
            dbms_output.put_line('after_update_AUDITS');
            INSERT INTO AUDITS(OperationDate, OperationType, TriggerName, Data)
            SELECT sysdate,'Update', 'AUDITS_trigger_after',concat(tabl.a ,tabl.b)
            FROM tabl;
        elsif deleting then
            dbms_output.put_line('after_delete_AUDITS');
            INSERT INTO AUDITS(OperationDate, OperationType, TriggerName, Data)
            SELECT sysdate,'Delete', 'AUDITS_trigger_after',concat(a ,b)
            FROM tabl;
        END if;
    END;

--11.	��������� ��������, ���������� ����������� ������� �� ���������� �����. ��������, ��������������� �� ������� ��� �������. ��������� ���������.
------------------------------------------------
SELECT * from tabl;
SELECT * from audits;
UPDATE tabl SET a = 1 where a = 9;
DELETE tabl;
delete AUDITS;
    
select object_name, status from user_objects where object_type='TRIGGER';
---------------------------------------------

--12.	������� (drop) �������� �������. ��������� ���������. �������� �������, ����������� �������� �������� �������.
alter session set RECYCLEBIN = ON;

    drop table tabl;
    FLASHBACK table tabl TO BEFORE DROP;
    
--13.	������� (drop) ������� AUDIT. ����������� ��������� ��������� � ������� SQL-DEVELOPER. ��������� ���������. �������� ��������.
    drop table audits;
    FLASHBACK table audits TO BEFORE DROP;

--.. ��� �������, ������. ���� tabl
    CREATE OR REPLACE TRIGGER no_drop_trg
    BEFORE DROP ON KNSLab8.SCHEMA
    BEGIN
        IF DICTIONARY_OBJ_NAME = 'TABL'
        THEN
        RAISE_APPLICATION_ERROR (-20905, '������');
        END IF;
    END; 
---------------------------------------------

--14.	�������� ������������� ��� �������� ��������. ������������ INSTEADOF INSERT-�������. ������� ������ ��������� ������ � �������.
    create view tablview as SELECT * FROM tabl;
    
    CREATE OR REPLACE TRIGGER tabl_trigg
    instead of insert on tablview
    BEGIN
        if inserting then
            dbms_output.put_line('insert');
            insert into tabl VALUES (102, 'nikita');
        end if;
    END tabl_trigg;
    
    INSERT INTO tablview (a,b) values(12,'c');
    SELECT * FROM tablview;