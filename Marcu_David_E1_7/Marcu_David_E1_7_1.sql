CREATE TABLE uber_cars
(
    automaker VARCHAR2(25),
    id_car int PRIMARY KEY,
    model VARCHAR2(50),
    year int
);

CREATE TABLE uber_drivers
(
    driver_name VARCHAR2(60),
    id_driver int PRIMARY KEY,
    id_car int,
    CONSTRAINT id_car__fk FOREIGN KEY (id_car) REFERENCES UBER_CARS(id_car)
);

CREATE VIEW uber AS SELECT uc.automaker, uc.model, uc.year, ud.driver_name, ud.id_driver, uc.id_car FROM uber_cars uc FULL OUTER JOIN uber_drivers ud ON uc.id_car = ud.id_car;

INSERT INTO uber_cars VALUES ('Ford', 1, 'Focus', 2015);
INSERT INTO uber_cars VALUES ('Ford', 2, 'Flex', 2014);
INSERT INTO uber_cars VALUES ('Honda', 3, 'Civic', 2016);
INSERT INTO uber_cars VALUES ('Honda', 4, 'Odyssey', 2015);
INSERT INTO uber_cars VALUES ('Hyundai', 5, 'Santa Fe', 2012);
INSERT INTO uber_cars VALUES ('Jaguar', 6, 'F-Pace', 2017);
INSERT INTO uber_cars VALUES ('Lexus', 7, 'RX', 2018);
INSERT INTO uber_cars VALUES ('Porsche', 8, 'Cayenne', 2017);
INSERT INTO uber_cars VALUES ('Rolls-Royce', 9, 'Ghost', 2016);
INSERT INTO uber_cars VALUES ('Rolls-Royce', 10, 'Phantom', 2015);

INSERT INTO uber_drivers VALUES ('Paul Jenkins', 1, 3);
INSERT INTO uber_drivers VALUES ('James Mann', 2, 9);
INSERT INTO uber_drivers VALUES ('Ken Parker', 3, 1);
INSERT INTO uber_drivers VALUES ('Maya Martin', 4, 3);
INSERT INTO uber_drivers VALUES ('Han Lee', 5, 5);
INSERT INTO uber_drivers VALUES ('Alfredo Rodriguez', 6, 1);
INSERT INTO uber_drivers VALUES ('Daniel Ionescu', 7, 1);
INSERT INTO uber_drivers VALUES ('Miguel Martinez', 8, 3);
INSERT INTO uber_drivers VALUES ('Jenny Stark', 9, 7);
INSERT INTO uber_drivers VALUES ('Penny Montana', 10, 2);
COMMIT;
ROLLBACK;

CREATE OR REPLACE TRIGGER dml_uber
    INSTEAD OF DELETE OR INSERT OR UPDATE on uber
    FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('DML operation on uber view');
    CASE
        WHEN DELETING THEN
            DBMS_OUTPUT.PUT_LINE('Deleteing row');
            DELETE FROM uber_drivers WHERE id_car = :OLD.id_car;
            DELETE FROM uber_cars WHERE id_car = :OLD.id_car;
        WHEN INSERTING THEN
            DBMS_OUTPUT.PUT_LINE('Inserting row');
            INSERT INTO uber_cars VALUES (:NEW.automaker, :NEW.id_car, :NEW.model, :NEW.year);
            INSERT INTO uber_drivers VALUES (:NEW.driver_name, :NEW.id_driver, :NEW.id_car);
        WHEN UPDATING THEN
            DBMS_OUTPUT.PUT_LINE('Updating row');
            UPDATE uber_cars SET year = :NEW.year, automaker = :NEW.automaker, model = :NEW.model WHERE id_car = :OLD.id_car;
            UPDATE uber_drivers SET driver_name = :NEW.driver_name WHERE id_car = :OLD.id_car and id_driver = :OLD.id_driver;
        END CASE;
end;

select * from sys.user_errors where type = 'TRIGGER';

DELETE FROM uber WHERE id_car > 5;
INSERT INTO uber VALUES ('Tesla', 'Model S', 2017, 'Rajesh Koothrappali', 11, 11);
UPDATE uber SET year = year - 5 WHERE id_car < 3;
UPDATE uber SET driver_name  = 'A' WHERE automaker = 'Ford';
COMMIT;
ROLLBACK;

SELECT * FROM uber;
DROP VIEW uber;


DROP TABLE uber_drivers;
DROP TABLE uber_cars;

DROP TRIGGER prevent_destruction;

ALTER TRIGGER prevent_destruction DISABLE;
ALTER TRIGGER dml_uber ENABLE ;