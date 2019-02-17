SET SERVEROUTPUT ON
DECLARE
--  Cursor for all the students that have at least 3 grades
    CURSOR cursor_id_studs IS 
        SELECT id_student FROM grades GROUP BY id_student HAVING COUNT(value) >= 3 ORDER BY 1; 
-- Cursor for all the grades that one student has (receives id_student as parameter)
    CURSOR cursor_grades (p_id_stud grades.id_student%TYPE) IS
        SELECT id_student, value, id_course FROM grades WHERE id_student = p_id_stud ORDER BY 1;
-- Cursor for all students sorted by year and lexicographically
    CURSOR cursor_all_students IS
        SELECT * FROM students ORDER BY year DESC, lname, fname;
        
    v_maxAvg DOUBLE PRECISION := 4.0;
    v_avgGrade DOUBLE PRECISION;
    r_grades cursor_grades%ROWTYPE;
    v_sum_grade INTEGER;
    v_countGrade INTEGER;
    v_idStudGreatestGrade grades.id_student%TYPE := 0;
    TYPE ids IS TABLE OF students.id%TYPE INDEX BY PLS_INTEGER;
    id_students ids;
    v_greatestAvgNo INTEGER := 0;
    v_studentYear students.year%TYPE;
    v_courseTitle COURSES.COURSE_TITLE%TYPE;
    v_studentLName students.lname%TYPE;
    v_studentFName students.fname%TYPE;
    
BEGIN
    FOR id_studs IN cursor_id_studs LOOP
        v_sum_grade := 0;
        v_countGrade := 0;
        v_avgGrade := 0;
        
        -- Calculating the average grade of each student
        OPEN cursor_grades(id_studs.id_student);
        LOOP
            FETCH cursor_grades INTO r_grades;
            EXIT WHEN cursor_grades%NOTFOUND;
            v_sum_grade := v_sum_grade + r_grades.value;
            v_countGrade := v_countGrade + 1;
        END LOOP;
        CLOSE cursor_grades;
        v_avgGrade := v_sum_grade / v_countGrade;
        -- Getting the max average of students
        IF v_avgGrade > v_maxAvg THEN
            v_maxAvg := v_avgGrade;
            v_greatestAvgNo := 0;
            id_students(v_greatestAvgNo) := id_studs.id_student;
        -- Getting all the students with the max average   
        ELSIF v_avgGrade = v_maxAvg THEN 
            v_greatestAvgNo := v_greatestAvgNo + 1;
            id_students(v_greatestAvgNo) := id_studs.id_student;   
        END IF;
    END LOOP;
    -- Getting the student that respects all the conditions 
    -- (Daca sunt doi studenti care au aceeasi medie va fi afisat cel din an mai mare sau, in cazul in care sunt in acelasi an, vor fi afisate notele primului in ordine alfabetica)
    <<tag>>
    FOR student IN cursor_all_students LOOP
        FOR i_index IN 0..v_greatestAvgNo LOOP
            IF student.id = id_students(i_index) THEN
                v_idStudGreatestGrade := student.id;
                v_studentYear := student.year;
                v_studentLName := student.lname;
                v_studentFName := student.fname;
                EXIT tag WHEN v_idStudGreatestGrade > 0 ;
            END IF;
        END LOOP;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_idStudGreatestGrade || ' ' || v_studentLName || ' ' || v_studentFName || ' ' || v_studentYear || ' ' || v_maxAvg);
    -- Getting the courses titles for which the student has a grade.
    OPEN cursor_grades(v_idStudGreatestGrade);
    LOOP
        FETCH cursor_grades INTO r_grades;
        EXIT WHEN cursor_grades%NOTFOUND;
        SELECT course_title INTO v_courseTitle FROM courses WHERE id = r_grades.id_course;
        DBMS_OUTPUT.PUT_LINE(v_courseTitle || ' ' || r_grades.value);
     END LOOP;
    CLOSE cursor_grades;
END;




select T1.id, T1.fname, T1.lname, T1.year, c.course_title, n.value, T1."avg" from ( select * from (select  s.id, s.fname, s.lname, s.year, 
avg(n.value) as "avg" from students s join grades n on n.id_student=s.id group by s.id, s.fname, s.lname, s.year, s.fname, s.lname
having count(n.value) >= 3 order by avg(n.value) desc, s.year desc, s.fname asc, s.lname asc ) where rownum = 1) T1 join grades n on
n.id_student = T1.id join courses c on c.id = n.id_course;
