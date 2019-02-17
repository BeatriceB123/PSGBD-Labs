CREATE OR REPLACE TRIGGER prevent_destruction
  BEFORE DROP OR ALTER OR TRUNCATE ON DATABASE
  declare
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_id INT;
    l_username VARCHAR2(50);
  BEGIN
    EXECUTE IMMEDIATE 'INSERT INTO illegal_actions_log SELECT COUNT(*) + 1, ora_login_user, CURRENT_TIMESTAMP FROM illegal_actions_log';
    EXECUTE IMMEDIATE 'COMMIT';
    RAISE_APPLICATION_ERROR(-20000, 'can''t drop/alter/truncate the tables');
  END;

CREATE TABLE illegal_actions_log
(
    id int PRIMARY KEY,
    username VARCHAR2(50) NOT NULL,
    access_time TIMESTAMP
);

CREATE TABLE foo
(
    column_1 int
);

DROP TABLE FOO;
ALTER TABLE FOO DROP COLUMN column_1;
TRUNCATE TABLE FOO;

SELECT CURRENT_TIMESTAMP FROM grades;
DROP TRIGGER prevent_destruction;