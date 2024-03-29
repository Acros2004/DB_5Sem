set serveroutput on;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello');
END;
select * from TEACHER;
select * from PULPIT;

--1.��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����), ���������� �� ������� �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
CREATE OR REPLACE PROCEDURE GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE) IS
  CURSOR my_curs IS SELECT TEACHER_NAME, TEACHER FROM TEACHER WHERE PULPIT = PCODE;
  t_name TEACHER.TEACHER_NAME%type;
  t_code TEACHER.TEACHER%type;
BEGIN
  OPEN my_curs;
  LOOP
    DBMS_OUTPUT.PUT_LINE(t_code||' '||t_name);
    FETCH my_curs INTO t_name, t_code;
    EXIT WHEN my_curs%notfound;
  END LOOP;
  CLOSE my_curs;
END;

BEGIN
    GET_TEACHERS('����');
END;

--2. ������� ������ �������� ���������� �������������� �� ������� TEACHER, ���������� �� ������� �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
CREATE OR REPLACE FUNCTION GET_NUM_TEACHERS(PCODE TEACHER.PULPIT%TYPE)
  RETURN NUMBER IS
    tCount NUMBER;
BEGIN
  SELECT COUNT(*) INTO tCount FROM TEACHER WHERE PULPIT = PCODE;
  RETURN tCount;
END;

BEGIN
  DBMS_OUTPUT.PUT_LINE(GET_NUM_TEACHERS('������'));
END;

-- 3. ��������� ������ �������� ������ �������������� �� ������� TEACHER (� ����������� ��������� �����), ���������� �� ����������, �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
CREATE OR REPLACE PROCEDURE GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE) IS
  CURSOR my_curs IS
    SELECT T.TEACHER_NAME, T.TEACHER, P.FACULTY
    FROM TEACHER T
    INNER JOIN PULPIT P
    ON T.PULPIT = P.PULPIT
    WHERE P.FACULTY = FCODE;
  t_name TEACHER.TEACHER_NAME%type;
  t_code TEACHER.TEACHER%type;
  t_faculty PULPIT.FACULTY%type;
BEGIN
  OPEN my_curs;
  LOOP
    DBMS_OUTPUT.PUT_LINE(t_name||' '||t_code||' '||t_faculty);
    FETCH my_curs INTO t_name, t_code, t_faculty;
    EXIT WHEN my_curs%notfound;
  END LOOP;
  CLOSE my_curs;
END;


BEGIN
    GET_TEACHERS('����');
END;

-- ��������� ������ �������� ������ ��������� �� ������� SUBJECT, ������������ �� ��������, �������� ����� ������� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
CREATE OR REPLACE PROCEDURE GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) IS
  CURSOR my_curs IS
      SELECT SUBJECT, SUBJECT_NAME, S.PULPIT
        FROM SUBJECT S
        WHERE S.PULPIT = PCODE;
  s_subject SUBJECT.SUBJECT%TYPE;
  s_subject_name SUBJECT.SUBJECT_NAME%TYPE;
  s_pulpit SUBJECT.PULPIT%TYPE;
BEGIN
  OPEN my_curs;
  LOOP
    DBMS_OUTPUT.PUT_LINE(s_subject||' '||s_subject_name||' '||s_pulpit);
    FETCH my_curs INTO s_subject, s_subject_name, s_pulpit;
    EXIT WHEN my_curs%notfound;
  END LOOP;
  CLOSE my_curs;
END;

BEGIN
  GET_SUBJECTS('����');
END;

--5. ������� ������ �������� ���������� �������������� �� ������� TEACHER, ���������� �� ����������, �������� ����� � ���������. ������������ ��������� ���� � ����������������� ���������� ���������.
CREATE OR REPLACE FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE)
  RETURN NUMBER IS
    tCount NUMBER;
BEGIN
  SELECT COUNT(*) INTO tCount FROM TEACHER T
  INNER JOIN PULPIT P
  ON T.PULPIT = P.PULPIT
  WHERE P.FACULTY = FCODE;
    RETURN tCount;
END;

BEGIN
  DBMS_OUTPUT.PUT_LINE(GET_NUM_TEACHERS('����'));
END;

-- GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER ������� ������ �������� ���������� ��������� �� ������� SUBJECT, 
-- ������������ �� ��������, �������� ����� ������� ���������. ������������ ��������� ���� � ����������������� ���������� ���������. 
CREATE OR REPLACE FUNCTION GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
  RETURN NUMBER IS
    tCount NUMBER:=0;
BEGIN
    SELECT COUNT(*) INTO tCount
      FROM SUBJECT
      WHERE SUBJECT.PULPIT = PCODE;
    RETURN tCount;
END;

BEGIN
  DBMS_OUTPUT.PUT_LINE(GET_NUM_SUBJECTS('����'));
END;

--6. �����, ���. ��������� � �-���
CREATE OR REPLACE PACKAGE TEACHERS AS
    FCODE FACULTY.FACULTY%TYPE;
    PCODE SUBJECT.PULPIT%TYPE;
    PROCEDURE GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE);
    PROCEDURE GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE);
    FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER;
    FUNCTION GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER;
END TEACHERS;


CREATE OR REPLACE PACKAGE BODY TEACHERS AS
  FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER
    IS tCount NUMBER;
        BEGIN
      SELECT COUNT(*) INTO tCount FROM TEACHER T
      INNER JOIN PULPIT P
      ON T.PULPIT = P.PULPIT
      WHERE P.FACULTY = FCODE;
        RETURN tCount;
      END GET_NUM_TEACHERS;
  FUNCTION GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
      RETURN NUMBER IS
        tCount NUMBER:=0;
    BEGIN
        SELECT COUNT(*) INTO tCount
          FROM SUBJECT
          WHERE SUBJECT.PULPIT = PCODE;
        RETURN tCount;
    END GET_NUM_SUBJECTS;
    
    
  PROCEDURE GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) IS
      CURSOR my_curs IS
          SELECT SUBJECT, SUBJECT_NAME, S.PULPIT
            FROM SUBJECT S
            WHERE S.PULPIT = PCODE;
      s_subject SUBJECT.SUBJECT%TYPE;
      s_subject_name SUBJECT.SUBJECT_NAME%TYPE;
      s_pulpit SUBJECT.PULPIT%TYPE;
    BEGIN
      OPEN my_curs;
      LOOP
        DBMS_OUTPUT.PUT_LINE(s_subject||' '||s_subject_name||' '||s_pulpit);
        FETCH my_curs INTO s_subject, s_subject_name, s_pulpit;
        EXIT WHEN my_curs%notfound;
      END LOOP;
      CLOSE my_curs;
    END GET_SUBJECTS;
    
    
  PROCEDURE GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE) IS
      CURSOR my_curs IS
        SELECT T.TEACHER_NAME, T.TEACHER, P.FACULTY
        FROM TEACHER T
        INNER JOIN PULPIT P
        ON T.PULPIT = P.PULPIT
        WHERE P.FACULTY = FCODE;
      t_name TEACHER.TEACHER_NAME%type;
      t_code TEACHER.TEACHER%type;
      t_faculty PULPIT.FACULTY%type;
    BEGIN
      OPEN my_curs;
      LOOP
        DBMS_OUTPUT.PUT_LINE(t_name||' '||t_code||' '||t_faculty);
        FETCH my_curs INTO t_name, t_code, t_faculty;
        EXIT WHEN my_curs%notfound;
      END LOOP;
      CLOSE my_curs;
    END GET_TEACHERS;
END TEACHERS;
  
-- 7. ������������ ��������� ���� � ����������������� ���������� �������� � ������� ������ TEACHERS.
BEGIN
  DBMS_OUTPUT.PUT_LINE(TEACHERS.GET_NUM_TEACHERS('����'));
  DBMS_OUTPUT.PUT_LINE(TEACHERS.GET_NUM_SUBJECTS('����'));
  TEACHERS.GET_TEACHERS('����');
  TEACHERS.GET_SUBJECTS('����');
END;