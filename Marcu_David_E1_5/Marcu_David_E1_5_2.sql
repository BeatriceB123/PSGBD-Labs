CREATE OR REPLACE PROCEDURE raise_scholarship(stud IN students.ID%TYPE) AS
  l_scholarship NUMBER(6, 2);
  err_scholarship_overflow EXCEPTION;
  PRAGMA EXCEPTION_INIT (err_scholarship_overflow, -20001);
  BEGIN
      SELECT NVL(SCHOLARSHIP, 0) INTO l_scholarship FROM STUDENTS WHERE ID = stud;
      l_scholarship := l_scholarship + 1000;
      IF(l_scholarship > 3000) THEN
        UPDATE STUDENTS SET SCHOLARSHIP = 3000 WHERE stud = ID;
        RAISE err_scholarship_overflow;
      ELSE
        UPDATE STUDENTS SET SCHOLARSHIP = l_scholarship WHERE stud = ID;
      END IF;
  END;


DECLARE
  err_scholarship_overflow EXCEPTION;
  PRAGMA EXCEPTION_INIT (err_scholarship_overflow, -20001);
  v_studID NUMBER;
  CURSOR topStuds IS SELECT ID, NVL(SCHOLARSHIP, 0) AS "SCHOLARSHIP" FROM STUDENTS ORDER BY SCHOLARSHIP DESC, ID;
  TYPE topScholarship IS TABLE OF NUMBER(6, 2) INDEX BY PLS_INTEGER;
  v_topScholarship topScholarship;
  v_indexTop INTEGER;
  v_counter INTEGER := 1;
BEGIN
  FOR i IN topStuds LOOP
    v_topScholarship(i.ID) := i.SCHOLARSHIP;
  END LOOP;

  FOR i IN 1..100 LOOP
    v_studID := TRUNC(DBMS_RANDOM.value(1, 1026));
    BEGIN
      raise_scholarship(v_studID);
      EXCEPTION
      WHEN err_scholarship_overflow THEN
        DBMS_OUTPUT.PUT_LINE('The student with the ID: ' || v_studID || ' would have the scholarship over 3000.');
    END;
  END LOOP;
    FOR counter IN topStuds LOOP
      EXIT WHEN v_counter > 10;
       DBMS_OUTPUT.PUT_LINE('Id of the student: ' || counter.ID || ', old scholarship: ' || v_topScholarship(counter.ID) || ', new scholarship: ' || counter.SCHOLARSHIP);
       v_counter := v_counter + 1;
    END LOOP;
END;

SELECT * FROM STUDENTS WHERE SCHOLARSHIP IS NOT NULL;

--CURSOR topStuds IS SELECT * FROM (SELECT ID, SCHOLARSHIP FROM STUDENTS WHERE SCHOLARSHIP IS NOT NULL ORDER BY SCHOLARSHIP DESC, ID) WHERE ROWNUM <= 10;

--   FOR i IN topStuds LOOP
--     v_topScholarship(i.ID) := i.SCHOLARSHIP;
--   END LOOP;

-- v_indexTop := v_topScholarship.FIRST;
--     WHILE (v_indexTop IS NOT NULL) LOOP
--       DBMS_OUTPUT.PUT('Id of the student: ' || v_indexTop || ', old scholarship: ' || v_topScholarship(v_indexTop) || ', new scholarship: ');
--       SELECT SCHOLARSHIP INTO v_topScholarship(v_indexTop) FROM STUDENTS WHERE v_indexTop = ID;
--       DBMS_OUTPUT.PUT_LINE(v_topScholarship(v_indexTop));
--       v_indexTop := v_topScholarship.NEXT(v_indexTop);
--   END LOOP;