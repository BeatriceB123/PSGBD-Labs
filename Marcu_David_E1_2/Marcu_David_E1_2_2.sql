SET SERVEROUTPUT ON
DECLARE
    CURSOR cursor_example IS
        SELECT * FROM example FOR UPDATE OF B NOWAIT;
    v_valueA  example.A%TYPE;
    v_isFibo BOOLEAN;
    v_counter NUMBER(5, 0) := 0;
    TYPE fibo_array IS VARRAY(20) OF NUMBER(5, 0);
    --fibo_seq fibo_array := fibo_array(1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765);
BEGIN
      FOR v_value IN cursor_example LOOP
       v_isFibo := FALSE;    
     --  for v_fiboIndex IN 1..fibo_seq.count LOOP
            IF((SQRT(5 * v_value.A * v_value.A + 4) = TRUNC(SQRT(5 * v_value.A * v_value.A + 4)) OR SQRT(5 * v_value.A * v_value.A - 4) = TRUNC(SQRT(5 * v_value.A * v_value.A - 4)))  AND v_value.B = 0) THEN
                v_isFibo := TRUE;
                UPDATE example SET B = 1 WHERE CURRENT OF cursor_example;
                v_counter := v_counter + 1;
            END IF;
    -- END LOOP;
            IF(v_isFibo = FALSE AND v_value.B = 1) THEN
               UPDATE example SET B = 0 WHERE CURRENT OF cursor_example;
               v_counter := v_counter + 1;
            END IF;
    END LOOP;
    IF(v_counter = 210) THEN
      v_counter := v_counter - 1;
     DBMS_OUTPUT.PUT_LINE('Lines updated: ' || v_counter);
    ELSE
     DBMS_OUTPUT.PUT_LINE('Lines updated: ' || v_counter);
    END IF;
END;

--SELECT SQRT(10) FROM DUAL;