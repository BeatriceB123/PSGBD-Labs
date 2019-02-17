CREATE OR REPLACE PACKAGE faculty_manager AS
    PROCEDURE add_student(i_fname IN students.fname%TYPE, i_lname IN students.lname%TYPE);
    PROCEDURE remove_student(i_idStud IN students.id%TYPE);
    PROCEDURE display_info(i_idStud IN students.id%TYPE);
END faculty_manager;

CREATE OR REPLACE PACKAGE BODY faculty_manager AS
    PROCEDURE get_age(i_id IN students.id%TYPE, o_years OUT NUMBER, o_months OUT NUMBER, o_days OUT NUMBER) AS
        l_todayDate DATE := CURRENT_DATE;
        l_dob DATE;
        BEGIN
            SELECT dob INTO l_dob FROM students WHERE id = i_id;
            SELECT TRUNC(MONTHS_BETWEEN(l_todayDate, l_dob)/ 12) INTO o_years FROM DUAL;
            SELECT TRUNC(MONTHS_BETWEEN(l_todayDate, l_dob) - (TRUNC(MONTHS_BETWEEN(l_todayDate, l_dob)/12)*12)) INTO o_months FROM dual;
            SELECT TRUNC(l_todayDate - ADD_MONTHS(l_dob, MONTHS_BETWEEN(l_todayDate, l_dob))) INTO o_days FROM dual;       
    END get_age;
    
    PROCEDURE add_student(i_fname IN students.fname%TYPE, i_lname IN students.lname%TYPE) AS
        l_id students.id%TYPE;
        l_registrationNumber students.registration_number%TYPE;
        l_year students.year%TYPE;
        l_groupNo students.groupno%TYPE;
        l_scholarship students.scholarship%TYPE;
        l_dob students.dob%TYPE;
        l_email students.email%TYPE;
        l_randomDate DATE := to_date('01-01-1996', 'dd-mm-yyyy');
        
        l_lastGradeId grades.id%TYPE;
        l_value grades.value%TYPE;
        l_examDate grades.grading_date%TYPE;
        
        l_numberOfFriendships INTEGER;
        l_lastFriendshipId friendships.id%TYPE;
        l_idFriend friendships.id_student1%TYPE;
    --    TYPE isFriend IS TABLE OF INTEGER INDEX BY PLS_INTEGER;
    --    friends isFriend;
        
        BEGIN
            SELECT id INTO l_id FROM students WHERE ROWNUM < 2 ORDER BY id DESC;
            l_registrationNumber := TRUNC(DBMS_RANDOM.value(0, 10)) || TRUNC(DBMS_RANDOM.value(0, 10)) || TRUNC(DBMS_RANDOM.value(0, 10)) || DBMS_RANDOM.string('U', 2)
                                     || TRUNC(DBMS_RANDOM.value(0, 10));
            l_year := TRUNC(DBMS_RANDOM.value(1, 4));
            l_groupNo := CHR(TRUNC(DBMS_RANDOM.value(65,67))) || TRUNC(DBMS_RANDOM.value(1, 8));
            l_scholarship := TRUNC(DBMS_RANDOM.value(0, 2));
            IF (l_scholarship = 1) THEN
                l_scholarship := TRUNC(DBMS_RANDOM.value(5, 16));
            ELSE
                l_scholarship := null;
            END IF;
            l_dob := TRUNC(l_randomDate + TRUNC(DBMS_RANDOM.value(0, 1097)));
            l_email := i_fname || '.' || i_lname || '@info.uaic.ro';      
            INSERT INTO students VALUES(l_id + 1, l_registrationNumber, i_fname, i_lname, l_year, l_groupNo, 
                100 * l_scholarship, l_dob, l_email, CURRENT_DATE, CURRENT_DATE);
            
            SELECT id into l_lastGradeId FROM grades WHERE ROWNUM < 2 ORDER BY id DESC;
            FOR index_course IN 1..8*(l_year - 1) LOOP
                l_value := TRUNC(DBMS_RANDOM.value(4, 11));
                IF (MOD(index_course, 8) <= 4) THEN
                    l_randomDate := to_date('12-02-2014', 'dd-mm-yyyy');
                    l_examDate := l_randomDate + NUMTOYMINTERVAL(l_year, 'year') + TRUNC(DBMS_RANDOM.value(0, 12));
                ELSE
                    l_randomDate := to_date('10-07-2014', 'dd-mm-yyyy');
                    l_examDate := l_randomDate + NUMTOYMINTERVAL(l_year, 'year') + TRUNC(DBMS_RANDOM.value(0, 12));
                END IF;
                INSERT INTO grades VALUES(l_lastGradeId + index_course, l_id + 1, index_course, l_value, l_examDate, l_examDate, l_examDate);
            END LOOP;
            
            SELECT id into l_lastFriendshipId FROM friendships WHERE ROWNUM < 2 ORDER BY id DESC;
            l_numberOfFriendships := TRUNC(DBMS_RANDOM.value(1, 11));
            FOR i IN 1..l_numberOfFriendships LOOP
                l_idFriend := TRUNC(DBMS_RANDOM.value(1, l_id + 1));
--                WHILE (friends(l_idFriend) IS NOT NULL) LOOP
--                    l_idFriend := TRUNC(DBMS_RANDOM.value(1, l_id + 1));
--                END LOOP; 
--                friends(l_idFriend) := 1;
                l_lastFriendshipId := l_lastFriendshipId + 1;
                INSERT INTO friendships VALUES(l_lastFriendshipId, l_id + 1, l_idFriend, CURRENT_DATE, CURRENT_DATE);
                l_lastFriendshipId := l_lastFriendshipId + 1;
                INSERT INTO friendships VALUES(l_lastFriendshipId, l_idFriend, l_id + 1, CURRENT_DATE, CURRENT_DATE);
             END LOOP;
                  
    END add_student;
    
    PROCEDURE remove_student(i_idStud IN students.id%TYPE) AS
        BEGIN
            DELETE FROM grades WHERE id_student = i_idStud;
           -- UPDATE grades SET id = id - 1 WHERE id_student > i_idStud;
            DELETE FROM friendships WHERE id_student1 = i_idStud OR id_student2 = i_idStud;
            DELETE FROM students WHERE id = i_idStud;
            --UPDATE students SET id = id - 1 WHERE id > i_idStud; 
         
    END remove_student;
    
    PROCEDURE display_info(i_idStud IN students.id%TYPE) AS
        cursor c_stud(p_id students.id%TYPE) is SELECT s.id, fname, lname, value, course_title FROM students s JOIN grades g ON s.id = g.id_student JOIN courses c ON c.id = g.id_course
                WHERE p_id = s.id;
        cursor c_groupStud(p_year students.year%TYPE, p_groupno students.groupno%TYPE) is SELECT ROWNUM, id_student FROM (SELECT id_student, AVG(value) FROM students s JOIN grades g ON s.id = g.id_student
                WHERE year = p_year AND groupno = p_groupno GROUP BY id_student ORDER BY 2 DESC);
        cursor c_friends(p_id students.id%TYPE) IS SELECT id_student2, fname, lname FROM friendships f JOIN students s ON id_student2 = s.id WHERE id_student1 = p_id;
        r_eachStudFromGroup c_groupStud%ROWTYPE;
        l_avgValue DOUBLE PRECISION;
        l_years NUMBER;
        l_months NUMBER;
        l_days NUMBER;
        l_studYear students.year%TYPE;
        l_groupno students.groupno%TYPE;
        l_place NUMBER;
        BEGIN
           FOR v_reportCard IN c_stud(i_idStud) LOOP
             DBMS_OUTPUT.PUT_LINE(v_reportCard.id || ' ' || v_reportCard.fname || ' ' || v_reportCard.lname || ' ' || v_reportCard.value || ' ' || v_reportCard.course_title);
           END LOOP;
           SELECT AVG(value) INTO l_avgValue FROM grades WHERE id_student = i_idStud GROUP BY id_student;
           DBMS_OUTPUT.PUT_LINE('Average value: ' || l_avgValue);
           get_age(i_idStud, l_years, l_months, l_days);
           DBMS_OUTPUT.PUT_LINE('Exact age: ' || l_years || 'yrs ' || l_months || 'months ' || l_days || 'days');
           SELECT year, groupno INTO l_studYear, l_groupno FROM students WHERE id = i_idStud;
           OPEN c_groupStud(l_studYear, l_groupno);
           LOOP
              FETCH c_groupStud INTO r_eachStudFromGroup;
              l_place := r_eachStudFromGroup.ROWNUM;
              EXIT WHEN r_eachStudFromGroup.id_student = i_idStud;
           END LOOP;
           CLOSE c_groupStud;
           DBMS_OUTPUT.PUT_LINE('Place: ' || l_place);
           DBMS_OUTPUT.PUT_LINE('Friends: ');
           FOR v_friend IN c_friends(i_idStud) LOOP
              DBMS_OUTPUT.PUT_LINE(v_friend.fname || ' ' || v_friend.lname);
           END LOOP;
    END display_info;
    
END faculty_manager;

