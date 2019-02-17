CREATE OR REPLACE TYPE vacation AS OBJECT
(
  place VARCHAR2(30),
  price NUMBER,
  arriving_date DATE,
  leaving_date DATE,
  NOT FINAL MEMBER PROCEDURE display_info,
  MEMBER PROCEDURE modify_dates(number_of_days NUMBER),
  MEMBER PROCEDURE modify_dates(number_of_days NUMBER, place VARCHAR2),
  CONSTRUCTOR FUNCTION vacation(place VARCHAR2, price NUMBER) RETURN SELF AS RESULT,
  MAP MEMBER FUNCTION order_by return DATE
)NOT FINAL;

CREATE OR REPLACE TYPE personalized_vacation UNDER vacation
(
  person_name VARCHAR2(50),
  OVERRIDING MEMBER PROCEDURE display_info
  -- the ORDER functions and static methods cannot be overridden.
);

CREATE OR REPLACE TYPE BODY vacation AS
  MEMBER PROCEDURE display_info AS
    BEGIN
      DBMS_OUTPUT.PUT_LINE('Place: ' || SELF.place);
      DBMS_OUTPUT.PUT_LINE('Price: ' || SELF.price || '$');
      DBMS_OUTPUT.PUT_LINE('Arriving date: ' || SELF.arriving_date);
      DBMS_OUTPUT.PUT_LINE('Leaving date: ' || SELF.leaving_date);
    END display_info;

  MEMBER PROCEDURE modify_dates(number_of_days NUMBER) AS
    BEGIN
      SELF.arriving_date := SELF.arriving_date + number_of_days;
      SELF.leaving_date := SELF.leaving_date + number_of_days;
    END modify_dates;

  MEMBER PROCEDURE modify_dates(number_of_days NUMBER, place VARCHAR2) AS
    BEGIN
      SELF.arriving_date := SELF.arriving_date + number_of_days;
      SELF.leaving_date := SELF.leaving_date + number_of_days;
      SELF.place := place;
    END modify_dates;

  CONSTRUCTOR FUNCTION vacation(place VARCHAR2, price NUMBER) RETURN SELF AS RESULT AS
    BEGIN
      SELF.place := place;
      SELF.price := price;
      SELF.arriving_date := SYSDATE ;
      SELF.leaving_date := SYSDATE + 7;
      RETURN;
    END;

  MAP MEMBER FUNCTION order_by RETURN DATE AS
    BEGIN
      RETURN SELF.arriving_date;
    END order_by;
END;

CREATE OR REPLACE TYPE BODY personalized_vacation AS
  OVERRIDING MEMBER PROCEDURE display_info AS
    BEGIN
      DBMS_OUTPUT.PUT_LINE('Name: ' || SELF.person_name);
      DBMS_OUTPUT.PUT_LINE('Place: ' || SELF.place);
      DBMS_OUTPUT.PUT_LINE('Price: ' || SELF.price || '$');
      DBMS_OUTPUT.PUT_LINE('Arriving date: ' || SELF.arriving_date);
      DBMS_OUTPUT.PUT_LINE('Leaving date: ' || SELF.leaving_date);
    END display_info;
END;

CREATE TABLE VACATIONS
(
    id NUMBER PRIMARY KEY NOT NULL,
    vacation VACATION NOT NULL
);

DECLARE
  v_vacation1 vacation;
  v_vacation2 vacation;
  v_vacation3 vacation;
  v_vacation4 vacation;
  v_vacation5 vacation;
  v_personalized_vacation personalized_vacation;
BEGIN
  v_vacation1 := vacation('Maldive', 1500, TO_DATE('12.06.2018', 'dd.mm.yyyy'), TO_DATE('26.06.2018', 'dd.mm.yyyy'));
  v_vacation2 := vacation('Busteni', 150);
  v_vacation3 := vacation('Mamaia', 300, TO_DATE('15.07.2018', 'dd.mm.yyyy'), TO_DATE('22.07.2018', 'dd.mm.yyyy'));
  v_vacation4 := vacation('Vama Veche', 0);
  v_vacation5 := vacation('Sölden', 800, TO_DATE('03.01.2019', 'dd.mm.yyyy'), TO_DATE('11.01.2019', 'dd.mm.yyyy'));
  v_vacation1.display_info();
  v_personalized_vacation := personalized_vacation(v_vacation1.PLACE, v_vacation1.PRICE, v_vacation1.ARRIVING_DATE, v_vacation1.LEAVING_DATE, 'David');
  v_personalized_vacation.display_info();
  v_vacation2.display_info();
  v_vacation2.modify_dates(10);
  v_vacation2.display_info();
  v_vacation2.modify_dates(-5, 'Azuga');
  v_vacation2.display_info();
  INSERT INTO VACATIONS VALUES (10, v_vacation1);
  INSERT INTO VACATIONS VALUES (11, v_vacation2);
  INSERT INTO VACATIONS VALUES (12, v_vacation3);
  INSERT INTO VACATIONS VALUES (13, v_vacation4);
  INSERT INTO VACATIONS VALUES (14, v_vacation5);
  COMMIT;
END;
/

DELETE FROM VACATIONS WHERE id BETWEEN 10 AND 14;
BEGIN
  SELECT * FROM VACATIONS ORDER BY 2;
end;

DROP TABLE VACATIONS;
/

-- import oracle.jdbc.pool.OracleDataSource;
-- import oracle.sql.STRUCT;
-- import oracle.sql.StructDescriptor;
--
-- import java.io.Serializable;
-- import java.math.BigDecimal;
-- import java.sql.*;
-- import java.time.LocalDate;
-- import java.util.Scanner;
--
--
-- class Vacation implements Serializable
-- {
--     String place;
--     int price;
--     Date leaving_date;
--     Date arriving_date;
--     public Vacation(String place, int price, Date leaving_date, Date arriving_date)
--     {
--         this.place = place;
--         this.price = price;
--         this.leaving_date = leaving_date;
--         this.arriving_date = arriving_date;
--     }
--
--     public Vacation(String place, int price)
--     {
--         this.place = place;
--         this.price = price;
--         LocalDate today = LocalDate.now();
--         this.arriving_date = Date.valueOf(today);
--         this.leaving_date = Date.valueOf(today.minusDays(-7));
--     }
-- }
--
-- public class Connection
-- {
--     public static void main(String[] args)
--     {
--         Scanner in = new Scanner(System.in);
--         final String GET_LAST_ID = "SELECT MAX(id) FROM STUDENT.vacations";
--         final String INSERT_VALUE_SQL = "INSERT INTO STUDENT.vacations " +
--                 "VALUES(?, ?)";
--         System.out.println("Introduce a place for your vacation: ");
--         String vacationPlace = in.next();
--         System.out.println("State the price of your vacation: ");
--         int vacationPrice = in.nextInt();
--         Vacation vacation = new Vacation(vacationPlace, vacationPrice);
--         OracleDataSource ods;
--         java.sql.Connection conn;
--         int id = -1;
--         try
--         {
--             ods = new OracleDataSource();
--             ods.setURL("jdbc:oracle:thin:@localhost:1521:XE");
--             conn = ods.getConnection("student","STUDENT");
--             Statement lastIdStatement = conn.createStatement();
--             ResultSet lastId = lastIdStatement.executeQuery(GET_LAST_ID);
--             if(lastId.next())
--             {
--                id = lastId.getInt(1);
--             }
--
--             StructDescriptor structDescriptor = StructDescriptor.createDescriptor("VACATION", conn);
--             PreparedStatement preparedStatement = conn.prepareStatement(INSERT_VALUE_SQL);
--             preparedStatement.setInt(1, id + 1);
--             preparedStatement.setObject(2, new STRUCT(structDescriptor, conn, new Object[]{vacation.place, vacation.price , vacation.arriving_date, vacation.leaving_date}), Types.STRUCT);
--             preparedStatement.execute();
--             preparedStatement.close();
--             conn.close();
--         }
--         catch (SQLException dbException)
--         {
--             dbException.printStackTrace();
--         }
--
--         final String GET_VALUE_SQL = "SELECT vacation FROM STUDENT.vacations WHERE id = ?";
--         System.out.println("Introduce a number beetween 1 and " + (id + 1));
--         try
--         {
--             ods = new OracleDataSource();
--             ods.setURL("jdbc:oracle:thin:@localhost:1521:XE");
--             conn = ods.getConnection("student","STUDENT");
--             PreparedStatement statement = conn.prepareStatement(GET_VALUE_SQL);
--             int inputId = in.nextInt();
--             statement.setInt(1, inputId);
--             statement.execute();
--             ResultSet resultSet = statement.getResultSet();
--             if(resultSet.next())
--             {
--                 STRUCT retrievedObject = (STRUCT) resultSet.getObject(1);
--                 vacation.place = (String) retrievedObject.getAttributes()[0];
--                 vacation.price = ((BigDecimal) retrievedObject.getAttributes()[1]).intValue();
--                 Timestamp arriving_time = (Timestamp) retrievedObject.getAttributes()[2];
--                 vacation.arriving_date.setTime(arriving_time.getTime());
--                 Timestamp leaving_time = (Timestamp) retrievedObject.getAttributes()[3];
--                 vacation.leaving_date.setTime(leaving_time.getTime());
--             }
--             System.out.println(vacation.place + " " + vacation.price + " " + vacation.arriving_date + " " + vacation.leaving_date);
--             statement.close();
--             conn.close();
--         }
--         catch (SQLException e)
--         {
--             e.printStackTrace();
--         }
--     }
-- }
