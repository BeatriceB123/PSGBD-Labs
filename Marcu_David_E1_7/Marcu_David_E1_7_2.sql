CREATE TABLE update_grades_log
(
    id int PRIMARY KEY,
    no_updates int NOT NULL,
    date_time TIMESTAMP
);

CREATE OR REPLACE TRIGGER log_updates
  FOR UPDATE of VALUE ON grades
  COMPOUND TRIGGER
    l_no_modified INT := 0;
    l_id INT ;

    BEFORE EACH ROW IS
    BEGIN
      IF(:OLD.VALUE < :NEW.VALUE) THEN
        l_no_modified := l_no_modified + 1;
      ELSE
        :NEW.VALUE := :OLD.VALUE;
      END IF;
    end BEFORE EACH ROW;

    AFTER STATEMENT IS
    BEGIN
     SELECT COUNT(*) INTO l_id FROM update_grades_log;
      INSERT INTO update_grades_log VALUES (l_id + 1, l_no_modified, CURRENT_TIMESTAMP);
    END AFTER STATEMENT;
END log_updates;

UPDATE GRADES SET VALUE = 7 WHERE id < 30;
SELECT * FROM GRADES WHERE  id < 20;
select * from sys.user_errors where type = 'TRIGGER';
COMMIT;
ROLLBACK;