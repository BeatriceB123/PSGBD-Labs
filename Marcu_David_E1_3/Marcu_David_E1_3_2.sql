
--SELECT DISTINCT id_student1 || '-' || id_student2 FROM friendships f JOIN grades g1 ON f.id_student1 = g1.id_student
--JOIN grades g2 ON f.id_student2 = g2.id_student WHERE  /*id_student1 = &i_idStud AND */
--(SELECT TRUNC(AVG(value)) FROM grades gg WHERE id_student = id_student1 GROUP BY id_student) = 
--(SELECT TRUNC(AVG(value)) FROM grades gg WHERE id_student = id_student2 GROUP BY id_student);

(SELECT TRUNC(AVG(value)) FROM grades gg WHERE id_student = &id_student2 GROUP BY id_student);

CREATE INDEX idx_values on grades(id_student);
DROP INDEX idx_values;

SET SERVEROUT ON;
CREATE OR REPLACE PROCEDURE avgEqual AS
    CURSOR cursor_friendship IS SELECT id_student1, id_student2 FROM friendships;
    l_avgValue1 INTEGER;
    l_avgValue2 INTEGER;
    l_indexStatement VARCHAR2(200);
    BEGIN
    --   l_indexStatement := 'create index idx_values on grades (id_student)';
    --   EXECUTE IMMEDIATE l_indexStatement;
        FOR friend IN cursor_friendship LOOP
            SELECT TRUNC(AVG(value)) INTO l_avgValue1 FROM grades WHERE id_student = friend.id_student1;
            SELECT TRUNC(AVG(value)) INTO l_avgValue2 FROM grades WHERE id_student = friend.id_student2;
            IF(l_avgValue1 = l_avgValue2) THEN
                DBMS_OUTPUT.PUT_LINE(friend.id_student1 || '-' || friend.id_student2);
            END IF;
        END LOOP;
     --   l_indexStatement := 'drop index idx_values';
     --   EXECUTE IMMEDIATE l_indexStatement;
END;
/
EXECUTE avgEqual;