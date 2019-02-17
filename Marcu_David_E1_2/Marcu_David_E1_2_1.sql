DROP TABLE example CASCADE CONSTRAINTS;
CREATE TABLE example
    (
        A NUMBER(5, 0),
        B NUMBER(1, 0)
    );
SET serveroutput ON;
DECLARE
    c_CONSTANT INTEGER := 7;
    v_aux INTEGER;
    v_digitSum INTEGER;
    v_prime NUMBER(1, 0);
BEGIN
    FOR v_number IN 1..10000 LOOP
        v_aux := v_number;
        v_digitSum := 0;
        v_prime := 1;
        WHILE(v_aux > 0) LOOP
            v_digitSum := v_digitSum + MOD(v_aux, 10);
            v_aux := TRUNC(v_aux / 10);
        END LOOP;
        
        <<prime>>
        FOR v_div IN 2..SQRT(v_number) LOOP
            IF(MOD(v_number, v_div) = 0) THEN
                v_prime := 0;
                EXIT prime WHEN (MOD(v_number, v_div) = 0);
                END IF;
        END LOOP;
        
        IF(MOD(v_digitSum, 9) = c_CONSTANT) THEN
            INSERT INTO example VALUES(v_number, v_prime);
        END IF;
    END LOOP;

END;
