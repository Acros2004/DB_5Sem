set serveroutput on;
alter session set NLS_LANGUAGE='AMERICAN';

-- 1. ������������ ���������� ��������� ���� PL/SQL (��), �� ���������� ����������. 
begin 
    null;
end;

-- 2. ������������ ��, ��������� �Hello World!�. ��������� ��� � SQLDev � SQL+.
begin
        dbms_output.put_line('Hello, world');
end;
    
-- 3. ����������������� ������ ���������� � ���������� ������� sqlerrm, sqlcode.
declare
        x number(3) := 3;
        y number(3) := 0;
        z number (10,2);
    begin
        z:=x/y;
        DBMS_OUTPUT.put_line(z);
        exception when others
           then dbms_output.put_line(sqlcode||': error = '||sqlerrm);
    end;
    
-- 4. ������������ ��������� ����. ����������������� ������� ��������� ���������� �� ��������� ������.
declare
  -- ������� ����������
  x number := 10;
  y number := 0;
begin
  -- ������� ����
  DBMS_OUTPUT.PUT_LINE('������ �������� �����');
  -- ��������� ����
  Declare
    result number;
  begin
    DBMS_OUTPUT.PUT_LINE('������ ���������� �����'); 
    -- ������� ��������� �������
    result := x / y;   
    -- ���� ��� ������� �� ���������� ��-�� ����������
    DBMS_OUTPUT.PUT_LINE('���� ��� �� ����� ��������');
  exception
    when ZERO_DIVIDE then
      DBMS_OUTPUT.PUT_LINE('����������: ������� ������� �� ����');
  end;
  -- ����������� �������� �����
  DBMS_OUTPUT.PUT_LINE('����������� �������� �����');
exception
  when others then
    DBMS_OUTPUT.PUT_LINE('���������� � ������� �����: ' || sqlerrm);
end;

-- 5. ��������, ����� ���� �������������� ����������� �������������� � ������ ������.
SHOW PARAMETERS plsql_warnings; --by system in sql developer
SELECT name, value FROM v$parameter WHERE name = 'plsql_warnings'; --by system

-- 6. ������������ ������, ����������� ����������� ��� ����������� PL/SQL.
select keyword from v$reserved_words
        where length = 1  order by keyword;
        
-- 7. ������������ ������, ����������� ����������� ��� �������� �����  PL/SQL.
select keyword from v$reserved_words
        where length > 1 order by keyword;
        
-- 8. ������������ ������, ����������� ����������� ��� ��������� Oracle Server, ��������� � PL/SQL. ����������� ��� �� ��������� � ������� SQL+-������� show.
select name,value from v$parameter
        where name like 'plsql%';
show parameter plsql;

--9. ������������ ��������� ����, ��������������� (��������� � �������� ��������� ����� ����������):
--10. ���������� � ������������� ����� number-����������;
-- 11. �������������� �������� ��� ����� ������ number-����������, ������� ������� � ��������;
-- 12. ���������� � ������������� number-���������� � ������������� ������;
-- 13. ���������� � ������������� number-���������� � ������������� ������ � ������������� ��������� (����������);
-- 14. ���������� � ������������� BINARY_FLOAT-����������;
-- 15. ���������� � ������������� BINARY_DOUBLE-����������;
-- 16. ���������� number-���������� � ������ � ����������� ������� E (������� 10) ��� �������������/����������;
-- 17. ���������� � ������������� BOOLEAN-����������. 


--9
declare
  v_name varchar2(50) := '������ ������';
  v_age number := 19;
begin
  DBMS_OUTPUT.PUT_LINE('������, '||  v_name );
  DBMS_OUTPUT.PUT_LINE('����� 5 ��� ��� ����� '||  (v_age + 5));
  v_age := v_age + 10;
  DBMS_OUTPUT.PUT_LINE('����� ��� 10 ��� ��� ����� '||  v_age);
end;

declare
        t10 number(3):= 50;
        t11 number(3):=15;
        suma number(10,2);
        dwo number(10,2);
        t12 number(10,2):= 2.11;
        t13 number(10, -3):= 222999.45;
        t14 binary_float:= 123456789.123456789;
        t15 binary_double:= 123456789.123456789;
        t16 number(38,10):=12345E+10;
        t17 boolean:= true;
begin
    suma:=t10+t11;
    dwo:=mod(t10,t11);
    
         dbms_output.put_line('t10 = '||t10);
        dbms_output.put_line('t11 = '||t11);
        dbms_output.put_line('ostatok = '||dwo);
        dbms_output.put_line('suma = '||suma);
        dbms_output.put_line('fix = '||t12);
        dbms_output.put_line('okr = '||t13);
        dbms_output.put_line('binfl = '||t14);
        dbms_output.put_line('bindobuble = '||t15);
        dbms_output.put_line('E+10 = '||t16);
        if t17 then dbms_output.put_line('bool = '||'true'); end if;
        end;
        
-- 18. ������������ ��������� ���� PL/SQL ���������� ���������� �������� (VARCHAR2, CHAR, NUMBER). �����������������  ��������� �������� �����������.  
declare
    curr_year constant number := to_number (to_char (SYSDATE, 'YYYY'));
    vc constant varchar2(10) := 'Varchar2';
    c char(5) := 'Char';
    begin
        c := 'Nchar';
        DBMS_OUTPUT.PUT_LINE(curr_year); 
        DBMS_OUTPUT.PUT_LINE(vc); 
        DBMS_OUTPUT.PUT_LINE(c); 
    exception
      when others
      then DBMS_OUTPUT.PUT_LINE('error = ' || sqlerrm);
    end;
    
-- 19. ������������ ��, ���������� ���������� � ������ %TYPE. ����������������� �������� �����.
declare
pulp pulpit.pulpit%TYPE;
    begin 
        pulp := '����';
        DBMS_OUTPUT.PUT_LINE(pulp);
    end;

-- 20.	������������ ��, ���������� ���������� � ������ %ROWTYPE. ����������������� �������� �����.
declare
    faculty_res faculty%ROWTYPE;
    begin 
        faculty_res.faculty := '���';
        faculty_res.faculty_name := '��������� �������������� ����������';
        DBMS_OUTPUT.PUT_LINE(faculty_res.faculty);
    end;

--Task 21 & 22
-- 21. ������������ ��, ��������������� ��� ��������� ����������� ��������� IF .
declare 
    x PLS_INTEGER := 16;
    begin
        if 5 > x then
        DBMS_OUTPUT.PUT_LINE('5 > '|| x);
        elsif 5 < x then
        DBMS_OUTPUT.PUT_LINE('5 < '|| x);
        else
        DBMS_OUTPUT.PUT_LINE('5 = '|| x);
        end if;
    end;

-- 23. ������������ ��, ��������������� ������ ��������� CASE.
declare
    x PLS_INTEGER := 21;
    begin
        case
        when x between 10 and 20 then
        DBMS_OUTPUT.PUT_LINE('10 <= ' || x || ' <= 20');
        when x between 21 and 40 then
        DBMS_OUTPUT.PUT_LINE('BETWEEN 21 AND 40');
        else
        DBMS_OUTPUT.PUT_LINE('ELSE');
        end case;
    end;

-- 24. ������������ ��, ��������������� ������ ��������� LOOP.
-- 25. ������������ ��, ��������������� ������ ��������� WHILE.
-- 26. ������������ ��, ��������������� ������ ��������� FOR.

declare 
    x PLS_INTEGER := 0;
    begin
        DBMS_OUTPUT.PUT_LINE('LOOP: ');
        loop
            x := x + 1;
            DBMS_OUTPUT.PUT_LINE(x);
            exit when x >= 3;
            end loop;

DBMS_OUTPUT.PUT_LINE('FOR: ');
    for k in 1..3
    loop
        DBMS_OUTPUT.PUT_LINE(k);
    end loop;

DBMS_OUTPUT.PUT_LINE('WHILE: ');
    while (x > 0)
        loop
            x := x - 1;
            DBMS_OUTPUT.PUT_LINE(x);
        end loop;
    end;

