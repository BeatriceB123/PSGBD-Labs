CREATE OR REPLACE TYPE split_arr AS
  TABLE OF VARCHAR2(100)
  /

CREATE OR REPLACE FUNCTION comma_to_table(p_list IN VARCHAR2)
  RETURN split_arr AS
  l_string      VARCHAR2(32767) := p_list || ',';
  l_comma_index PLS_INTEGER;
  l_index       PLS_INTEGER := 1;
  l_tab         split_arr := split_arr();
  BEGIN
    LOOP
      l_comma_index := INSTR(l_string, ',', l_index);
      EXIT
      WHEN l_comma_index = 0;
      l_tab.EXTEND;
      l_tab(l_tab.COUNT) := SUBSTR(l_string, l_index, l_comma_index - l_index);
      l_index := l_comma_index + 1;
    END LOOP;
    RETURN l_tab;
  END comma_to_table;



CREATE OR REPLACE PROCEDURE db_importer AS
  l_importer_studs UTL_FILE.FILE_TYPE;
  l_importer_friendships UTL_FILE.FILE_TYPE;
  l_stud_row VARCHAR2(4000);
  l_friendship_row VARCHAR2(4000);
  l_count binary_integer;
  l_stud_row_array split_arr := split_arr();
  l_friendship_row_array split_arr := split_arr();

   CHECK_CONSTRAINT_VIOLATED EXCEPTION;
  PRAGMA EXCEPTION_INIT(CHECK_CONSTRAINT_VIOLATED, -2291);

     CAST_EXCEPTION EXCEPTION;
  PRAGMA EXCEPTION_INIT(CAST_EXCEPTION, -1722);
  BEGIN
    l_stud_row_array.EXTEND(11);
    l_friendship_row_array.EXTEND(5);

    l_importer_studs := UTL_FILE.FOPEN('MYDIR', 'myexporterstuds.csv', 'R');
    BEGIN
    LOOP
      UTL_FILE.GET_LINE(l_importer_studs, l_stud_row);
      l_stud_row_array := STUDENT.COMMA_TO_TABLE(l_stud_row);
      BEGIN
        INSERT INTO STUDENTS VALUES (l_stud_row_array(1), l_stud_row_array(2), l_stud_row_array(3), l_stud_row_array(4), l_stud_row_array(5),
        l_stud_row_array(6), l_stud_row_array(7), l_stud_row_array(8), l_stud_row_array(9), l_stud_row_array(10),
        l_stud_row_array(11));
        EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Student with the ID: ' || l_stud_row_array(1) || ' is already in the STUDENTS table');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Something unexpected occurred');
      END;
    end loop;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        COMMIT;
        UTL_FILE.FCLOSE(l_importer_studs);
    END;

    l_importer_friendships := UTL_FILE.FOPEN('MYDIR', 'myexporterfriendships.csv', 'R');
    BEGIN
    LOOP
      UTL_FILE.GET_LINE(l_importer_friendships, l_friendship_row);
      l_friendship_row_array := STUDENT.COMMA_TO_TABLE(l_friendship_row);
      BEGIN
        INSERT INTO FRIENDSHIPS VALUES (l_friendship_row_array(1), l_friendship_row_array(2), l_friendship_row_array(3), l_friendship_row_array(4),
                                      l_friendship_row_array(5));
        EXCEPTION
        WHEN CHECK_CONSTRAINT_VIOLATED THEN
          DBMS_OUTPUT.PUT_LINE('No such id in students table.');
        WHEN DUP_VAL_ON_INDEX THEN
          DBMS_OUTPUT.PUT_LINE('Entry with the ID: ' || l_friendship_row_array(1) || ' is already in the FRIENDSHIPS table');
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Something unexpected occurred');
      END;
    end loop;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          COMMIT;
          UTL_FILE.FCLOSE(l_importer_friendships);
    END;
  end;

  BEGIN
  db_importer();
END;
/