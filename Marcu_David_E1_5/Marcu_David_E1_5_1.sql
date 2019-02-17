DROP TABLE ERASMUS_STUDENTS;
/
DROP INDEX ERASMUS_ID_STUDENT_uindex;
/

CREATE TABLE ERASMUS_STUDENTS
(
    ID NUMBER PRIMARY KEY NOT NULL,
    ID_STUDENT NUMBER NOT NULL,
    FNAME VARCHAR2(30) NOT NULL,
    LNAME VARCHAR2(15) NOT NULL,
    COUNTRY VARCHAR2(20) NOT NULL,
    CONSTRAINT FK_ERASMUS_ID_STUDENT FOREIGN KEY (ID_STUDENT) REFERENCES STUDENTS(ID)
);
/
CREATE UNIQUE INDEX ERASMUS_ID_STUDENT_uindex ON ERASMUS_STUDENTS (ID_STUDENT);
/

CREATE OR REPLACE TYPE studs AS VARRAY(100) OF NUMBER;
/


CREATE OR REPLACE PROCEDURE put_erasmus_students AS
    l_no_students INTEGER;
    l_stud_fname STUDENTS.fname%TYPE;
    l_stud_lname STUDENTS.lname%TYPE;
    TYPE countries IS TABLE OF VARCHAR2(30);
    l_countries countries := countries('France', 'Germany', 'Spain', 'United Kingdom', 'Italy', 'Denmark', 'Sweden', 'Netherlands', 'Belgium');
    l_lastID NUMBER;
    l_randID NUMBER;
    l_indexCountry INTEGER;
    BEGIN
        SELECT COUNT(*) INTO l_no_students FROM students;
        SELECT COUNT(*) INTO l_lastID FROM ERASMUS_STUDENTS;
        FOR i IN 1..100 LOOP
          l_lastID := l_lastID + 1;
          l_randID := TRUNC(DBMS_RANDOM.value(1, l_no_students + 1));
          l_indexCountry := TRUNC(DBMS_RANDOM.value(1, l_countries.COUNT + 1));
          SELECT FNAME, LNAME INTO l_stud_fname, l_stud_lname FROM STUDENTS WHERE ID = l_randID;
          BEGIN
            INSERT INTO ERASMUS_STUDENTS VALUES(l_lastID, l_randID, l_stud_fname, l_stud_lname, l_countries(l_indexCountry));
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Student with the ID: ' || l_randID || ' has been successfully introduced in the ERASMUS table.');
            EXCEPTION
             WHEN DUP_VAL_ON_INDEX THEN
              DBMS_OUTPUT.PUT_LINE('Student with the ID: ' || l_randID || ' is already in the ERASMUS table');
          END;
        END LOOP;
END;

  BEGIN
    put_erasmus_students();
  END;

    SELECT * FROM ERASMUS_STUDENTS;