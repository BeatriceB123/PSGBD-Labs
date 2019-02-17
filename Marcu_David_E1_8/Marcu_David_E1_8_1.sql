CREATE OR REPLACE PROCEDURE db_exporter AS
  l_exporter_studs UTL_FILE.FILE_TYPE;
  l_exporter_friendships UTL_FILE.FILE_TYPE;
  CURSOR students IS SELECT * FROM STUDENTS;
  CURSOR friends IS SELECT * FROM FRIENDSHIPS;
  BEGIN
    l_exporter_studs := UTL_FILE.FOPEN('MYDIR', 'myexporterstuds.csv', 'W');
    FOR student in students LOOP
      UTL_FILE.PUT_LINE(l_exporter_studs, student.ID || ',' || student.REGISTRATION_NUMBER || ',' || student.LNAME || ',' || student.FNAME || ',' ||
      student.YEAR || ',' || student.GROUPNO || ',' || student.SCHOLARSHIP || ',' || student.DOB || ',' ||
      student.EMAIL || ',' || student.CREATED_AT || ',' || student.UPDATED_AT);
    end loop;
    UTL_FILE.FCLOSE(l_exporter_studs);

    l_exporter_friendships := UTL_FILE.FOPEN('MYDIR', 'myexporterfriendships.csv', 'W');
    FOR friend in friends LOOP
      UTL_FILE.PUT_LINE(l_exporter_friendships, friend.ID || ',' || friend.ID_STUDENT1 || ',' || friend.ID_STUDENT2 || ',' || friend.CREATED_AT || ',' ||
                                          friend.UPDATED_AT);
    end loop;
    UTL_FILE.FCLOSE(l_exporter_friendships);
  end;

 BEGIN
 db_exporter();
 
END;
/