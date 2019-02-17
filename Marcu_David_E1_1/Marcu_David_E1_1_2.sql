set SERVEROUT ON;
DECLARE
   c_DATE_OF_BIRTH CONSTANT VARCHAR(30) := '28-02-2018';
   v_monthsPassed NUMBER(4, 0);
   v_daysInTheMonth NUMBER(8, 0);
   
BEGIN   
    SELECT MONTHS_BETWEEN(CURRENT_DATE , TO_DATE(c_DATE_OF_BIRTH, 'DD-MM-YYYY')) INTO v_monthsPassed FROM dual;
    DBMS_OUTPUT.PUT_LINE('Months passed: ' || v_monthsPassed || ' months.');
    v_daysInTheMonth := CURRENT_DATE - LAST_DAY(ADD_MONTHS(CURRENT_DATE, -1));
    DBMS_OUTPUT.PUT_LINE('Days passed: ' || v_daysInTheMonth || ' days.');
    DBMS_OUTPUT.PUT_LINE('Day of the week of DOB: ' || TO_CHAR(TO_DATE(c_DATE_OF_BIRTH, 'DD-MM-YYYY'), 'Day'));
END;
