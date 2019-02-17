CREATE OR REPLACE PACKAGE scholarship_manager AS
    TYPE studs_scholarship IS RECORD (id_stud students.id%TYPE, percentage INTEGER);
    TYPE list_studs_scholarship IS TABLE OF studs_scholarship;
    PROCEDURE modify_scholarship (i_studs IN list_studs_scholarship);
    PROCEDURE get_modifications;
END scholarship_manager;

SET serveroutput ON;
CREATE OR REPLACE PACKAGE BODY scholarship_manager AS
    PROCEDURE modify_scholarship (i_studs IN list_studs_scholarship) AS
        l_scholarship students.scholarship%TYPE := 0;
        l_history_scholarships scholarship_history := scholarship_history();
        BEGIN
        FOR stud IN i_studs.FIRST..i_studs.LAST LOOP
            IF(i_studs.EXISTS(stud)) THEN
                SELECT scholarship, all_scholarships INTO l_scholarship, l_history_scholarships FROM students WHERE id = i_studs(stud).id_stud;
                if(l_history_scholarships IS NULL) THEN
                    l_history_scholarships := scholarship_history(); 
                END IF;
                l_history_scholarships.EXTEND();
                IF(l_history_scholarships.EXISTS(l_history_scholarships.COUNT)) THEN
                    l_history_scholarships(l_history_scholarships.COUNT) := l_scholarship;
                END IF;
                IF(l_scholarship IS NULL) THEN
                    UPDATE students SET scholarship = 100 WHERE id = i_studs(stud).id_stud;
                END IF;
                UPDATE students SET scholarship = scholarship + scholarship * i_studs(stud).percentage/100, all_scholarships = l_history_scholarships
                                WHERE id = i_studs(stud).id_stud;
            END IF;
        END LOOP;
    END modify_scholarship;
    
    PROCEDURE get_modifications AS
        CURSOR studs IS SELECT id, fname, lname, all_scholarships FROM students;
        BEGIN
        FOR stud IN studs LOOP
            IF (stud.all_scholarships IS NOT NULL) THEN
                DBMS_OUTPUT.PUT(stud.id || '->' || stud.fname || ' ' || stud.lname || ': ');
                FOR i IN stud.all_scholarships.first..stud.all_scholarships.last LOOP
                    IF(stud.all_scholarships.EXISTS(i)) THEN
                        DBMS_OUTPUT.PUT(stud.all_scholarships(i)|| ', ');
                    END IF;
                END LOOP;
                DBMS_OUTPUT.PUT_LINE(null);
            END IF;
        END LOOP;
    END get_modifications;
    
END scholarship_manager;

CREATE OR REPLACE TYPE scholarship_history AS TABLE OF NUMBER(6, 2);
/
ALTER TABLE students ADD(all_scholarships scholarship_history) NESTED TABLE all_scholarships STORE AS scholarship_list;
/

SET SERVEROUTPUT ON
DECLARE
    test_studs scholarship_manager.list_studs_scholarship := scholarship_manager.list_studs_scholarship();
    stud scholarship_manager.studs_scholarship;
BEGIN
   SCHOLARSHIP_MANAGER.GET_MODIFICATIONS;
   DBMS_OUTPUT.PUT_LINE(null);
   test_studs.EXTEND(5);
   stud.id_stud := 1025;
   stud.percentage := 10;
   test_studs(1) := stud;
 
   stud.id_stud := 1024;
   stud.percentage := 50;
   test_studs(2) := stud;
 
   stud.id_stud := 1023;
   stud.percentage := 50;
   test_studs(3) := stud;

   stud.id_stud := 1022;
   stud.percentage := 50;
   test_studs(4) := stud;

   stud.id_stud := 1021;
   stud.percentage := -10;
   test_studs(5) := stud;
  SCHOLARSHIP_MANAGER.MODIFY_SCHOLARSHIP(test_studs);
  SCHOLARSHIP_MANAGER.GET_MODIFICATIONS;
END;


SELECT * FROM students WHERE id > 1020;
UPDATE students SET scholarship = 1200 WHERE id = 1025;
UPDATE students SET all_scholarships = null, scholarship = null WHERE id > 1020 AND id < 1026;