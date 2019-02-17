set serveroutput on;

DECLARE
    v_lNameInput VARCHAR(15) := &i_nameInput;
    v_fName students.FNAME%TYPE;
    v_noStudents NUMBER(4, 0);
    v_ID students.ID%TYPE;
    v_minGrade grades.value%TYPE;
    v_maxGrade grades.value%TYPE;
    
BEGIN
    SELECT COUNT(lname) INTO v_noStudents FROM students WHERE lname = v_lNameInput; 
    IF(v_noStudents = 0)
        THEN DBMS_OUTPUT.PUT_LINE('No students have that last name!');
        ELSE 
            DBMS_OUTPUT.PUT_LINE(v_noStudents || ' students with that name.');
            SELECT id, fname INTO v_ID, v_fName FROM students WHERE lname = v_lNameInput AND ROWNUM = 1 ORDER BY fname;
            DBMS_OUTPUT.PUT_LINE('ID student: ' || v_ID || ', student first name: ' || v_fName);
            SELECT MIN(value), MAX(value) INTO v_minGrade, v_maxGrade FROM grades WHERE ID_STUDENT = v_ID;
            DBMS_OUTPUT.PUT_LINE('Lowest grade: ' || v_minGrade || ', Highest grade: ' || v_maxGrade);
            DBMS_OUTPUT.PUT_LINE(POWER(v_maxGrade, v_minGrade));         
    END IF;
END;

--SELECT lname, COUNT(lname) FROM students GROUP BY lname;