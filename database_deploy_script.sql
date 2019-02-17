DROP TABLE students CASCADE CONSTRAINTS
/
DROP TABLE courses CASCADE CONSTRAINTS
/
DROP TABLE grades CASCADE CONSTRAINTS
/
DROP TABLE instructors CASCADE CONSTRAINTS
/
DROP TABLE didactic CASCADE CONSTRAINTS
/
DROP TABLE friendships CASCADE CONSTRAINTS
/


CREATE TABLE students (
  id INT NOT NULL PRIMARY KEY,
  registration_number VARCHAR2(6) NOT NULL,
  lname VARCHAR2(15) NOT NULL,
  fname VARCHAR2(30) NOT NULL,
  year NUMBER(1),
  groupno CHAR(2),
  scholarship NUMBER(6,2),
  dob DATE,
  email VARCHAR2(40),
  created_at DATE,
  updated_at DATE
)
/


CREATE TABLE courses (
  id INT NOT NULL PRIMARY KEY,
  course_title VARCHAR2(50) NOT NULL,
  year NUMBER(1),
  sem NUMBER(1),
  credits NUMBER(2),
  created_at DATE,
  updated_at DATE
)
/


CREATE TABLE grades (
  id INT NOT NULL PRIMARY KEY,
  id_student INT NOT NULL,
  id_course INT NOT NULL,
  value NUMBER(2),
  grading_date DATE,
  created_at DATE,
  updated_at DATE,
  CONSTRAINT fk_grades_id_student FOREIGN KEY (id_student) REFERENCES students(id),
  CONSTRAINT fk_grades_id_course FOREIGN KEY (id_course) REFERENCES courses(id)
)
/

CREATE TABLE instructors (
  id INT NOT NULL PRIMARY KEY,
  lname VARCHAR2(15) NOT NULL,
  fname VARCHAR2(30) NOT NULL,
  title VARCHAR2(20),
  created_at DATE,
  updated_at DATE
)
/

CREATE TABLE didactic (
  id INT NOT NULL PRIMARY KEY,
  id_instructor INT NOT NULL,
  id_course INT NOT NULL,
  created_at DATE,
  updated_at DATE,
  CONSTRAINT fk_didactic_id_instructor FOREIGN KEY (id_instructor) REFERENCES instructors(id),
  CONSTRAINT fk_didactic_id_course FOREIGN KEY (id_course) REFERENCES courses(id) 
)
/


CREATE TABLE friendships (
  id INT PRIMARY KEY,
  id_student1 INT NOT NULL, 
  id_student2 INT NOT NULL, 
  created_at DATE,
  updated_at DATE,  
  CONSTRAINT fk_friendships_id_student1 FOREIGN KEY (id_student1) REFERENCES students(id),
  CONSTRAINT fk_friendships_id_student2 FOREIGN KEY (id_student2) REFERENCES students(id),
  CONSTRAINT no_duplicates UNIQUE (id_student1, id_student2)
)
/


DECLARE
  TYPE varr IS VARRAY(1000) OF varchar2(255);
  lista_lname varr := varr('Ababei','Acasandrei','Adascalitei','Afanasie','Agafitei','Agape','Aioanei','Alexandrescu','Alexandru','Alexe','Alexii','Amarghioalei','Ambroci','andonesei','andrei','andrian','andrici','andronic','andros','anghelina','anita','antochi','antonie','Apetrei','Apostol','Arhip','Arhire','Arteni','Arvinte','Asaftei','Asofiei','Aungurenci','Avadanei','Avram','Babei','Baciu','Baetu','Balan','Balica','Banu','Barbieru','Barzu','Bazgan','Bejan','Bejenaru','Belcescu','Belciuganu','Benchea','Bilan','Birsanu','Bivol','Bizu','Boca','Bodnar','Boistean','Borcan','Bordeianu','Botezatu','Bradea','Braescu','Budaca','Bulai','Bulbuc-aioanei','Burlacu','Burloiu','Bursuc','Butacu','Bute','Buza','Calancea','Calinescu','Capusneanu','Caraiman','Carbune','Carp','Catana','Catiru','Catonoiu','Cazacu','Cazamir','Cebere','Cehan','Cernescu','Chelaru','Chelmu','Chelmus','Chibici','Chicos','Chilaboc','Chile','Chiriac','Chirila','Chistol','Chitic','Chmilevski','Cimpoesu','Ciobanu','Ciobotaru','Ciocoiu','Ciofu','Ciornei','Citea','Ciucanu','Clatinici','Clim','Cobuz','Coca','Cojocariu','Cojocaru','Condurache','Corciu','Corduneanu','Corfu','Corneanu','Corodescu','Coseru','Cosnita','Costan','Covatariu','Cozma','Cozmiuc','Craciunas','Crainiceanu','Creanga','Cretu','Cristea','Crucerescu','Cumpata','Curca','Cusmuliuc','Damian','Damoc','Daneliuc','Daniel','Danila','Darie','Dascalescu','Dascalu','Diaconu','Dima','Dimache','Dinu','Dobos','Dochitei','Dochitoiu','Dodan','Dogaru','Domnaru','Dorneanu','Dragan','Dragoman','Dragomir','Dragomirescu','Duceac','Dudau','Durnea','Edu','Eduard','Eusebiu','Fedeles','Ferestraoaru','Filibiu','Filimon','Filip','Florescu','Folvaiter','Frumosu','Frunza','Galatanu','Gavrilita','Gavriliuc','Gavrilovici','Gherase','Gherca','Ghergu','Gherman','Ghibirdic','Giosanu','Gitlan','Giurgila','Glodeanu','Goldan','Gorgan','Grama','Grigore','Grigoriu','Grosu','Grozavu','Gurau','Haba','Harabula','Hardon','Harpa','Herdes','Herscovici','Hociung','Hodoreanu','Hostiuc','Huma','Hutanu','Huzum','Iacob','Iacobuta','Iancu','Ichim','Iftimesei','Ilie','Insuratelu','Ionesei','Ionesi','Ionita','Iordache','Iordache-tiroiu','Iordan','Iosub','Iovu','Irimia','Ivascu','Jecu','Jitariuc','Jitca','Joldescu','Juravle','Larion','Lates','Latu','Lazar','Leleu','Leon','Leonte','Leuciuc','Leustean','Luca','Lucaci','Lucasi','Luncasu','Lungeanu','Lungu','Lupascu','Lupu','Macariu','Macoveschi','Maftei','Maganu','Mangalagiu','Manolache','Manole','Marcu','Marinov','Martinas','Marton','Mataca','Matcovici','Matei','Maties','Matrana','Maxim','Mazareanu','Mazilu','Mazur','Melniciuc-puica','Micu','Mihaela','Mihai','Mihaila','Mihailescu','Mihalachi','Mihalcea','Mihociu','Milut','Minea','Minghel','Minuti','Miron','Mitan','Moisa','Moniry-abyaneh','Morarescu','Morosanu','Moscu','Motrescu','Motroi','Munteanu','Murarasu','Musca','Mutescu','Nastaca','Nechita','Neghina','Negrus','Negruser','Negrutu','Nemtoc','Netedu','Nica','Nicu','Oana','Olanuta','Olarasu','Olariu','Olaru','Onu','Opariuc','Oprea','Ostafe','Otrocol','Palihovici','Pantiru','Pantiruc','Paparuz','Pascaru','Patachi','Patras','Patriche','Perciun','Perju','Petcu','Pila','Pintilie','Piriu','Platon','Plugariu','Podaru','Poenariu','Pojar','Popa','Popescu','Popovici','Poputoaia','Postolache','Predoaia','Prisecaru','Procop','Prodan','Puiu','Purice','Rachieru','Razvan','Reut','Riscanu','Riza','Robu','Roman','Romanescu','Romaniuc','Rosca','Rusu','Samson','Sandu','Sandulache','Sava','Savescu','Schifirnet','Scortanu','Scurtu','Sfarghiu','Silitra','Simiganoschi','Simion','Simionescu','Simionesei','Simon','Sitaru','Sleghel','Sofian','Soficu','Sparhat','Spiridon','Stan','Stavarache','Stefan','Stefanita','Stingaciu','Stiufliuc','Stoian','Stoica','Stoleru','Stolniceanu','Stolnicu','Strainu','Strimtu','Suhani','Tabusca','Talif','Tanasa','Teclici','Teodorescu','Tesu','Tifrea','Timofte','Tincu','Tirpescu','Toader','Tofan','Toma','Toncu','Trifan','Tudosa','Tudose','Tuduri','Tuiu','Turcu','Ulinici','Unghianu','Ungureanu','Ursache','Ursachi','Urse','Ursu','Varlan','Varteniuc','Varvaroi','Vasilache','Vasiliu','Ventaniuc','Vicol','Vidru','Vinatoru','Vlad','Voaides','Vrabie','Vulpescu','Zamosteanu','Zazuleac');
  lista_fname_fete varr := varr('Adina','Alexandra','Alina','ana','anca','anda','andra','andreea','andreia','antonia','Bianca','Camelia','Claudia','Codrina','Cristina','Daniela','Daria','Delia','Denisa','Diana','Ecaterina','Elena','Eleonora','Elisa','Ema','Emanuela','Emma','Gabriela','Georgiana','Ileana','Ilona','Ioana','Iolanda','Irina','Iulia','Iuliana','Larisa','Laura','Loredana','Madalina','Malina','Manuela','Maria','Mihaela','Mirela','Monica','Oana','Paula','Petruta','Raluca','Sabina','Sanziana','Simina','Simona','Stefana','Stefania','Tamara','Teodora','Theodora','Vasilica','Xena');
  lista_fname_baieti varr := varr('Adrian','Alex','Alexandru','Alin','andreas','andrei','Aurelian','Beniamin','Bogdan','Camil','Catalin','Cezar','Ciprian','Claudiu','Codrin','Constantin','Corneliu','Cosmin','Costel','Cristian','Damian','Dan','Daniel','Danut','Darius','Denise','Dimitrie','Dorian','Dorin','Dragos','Dumitru','Eduard','Elvis','Emil','Ervin','Eugen','Eusebiu','Fabian','Filip','Florian','Florin','Gabriel','George','Gheorghe','Giani','Giulio','Iaroslav','Ilie','Ioan','Ion','Ionel','Ionut','Iosif','Irinel','Iulian','Iustin','Laurentiu','Liviu','Lucian','Marian','Marius','Matei','Mihai','Mihail','Nicolae','Nicu','Nicusor','Octavian','Ovidiu','Paul','Petru','Petrut','Radu','Rares','Razvan','Richard','Robert','Roland','Rolland','Romanescu','Sabin','Samuel','Sebastian','Sergiu','Silviu','Stefan','Teodor','Teofil','Theodor','Tudor','Vadim','Valentin','Valeriu','Vasile','Victor','Vlad','Vladimir','Vladut');
  lista_materii_year_1 varr := varr('Logica', 'Matematica', 'Introducere In programare', 'Arhitectura calculatoarelor si sisteme de operare', 'Sisteme de operare', 'Programare orientata-obiect', 'Fundamente algebrice ale informaticii', 'Probabilitati si statistica');
  lista_materii_year_2 varr := varr('Retele de calculatoare', 'Baze de date', 'Limbaje formale, automate si compilatoare', 'Algoritmica grafurilor', 'Tehnologii WEB', 'Programare avansata', '	Ingineria Programarii', 'Practica SGBD');
  lista_materii_year_3 varr := varr('Invatare automata', 'Securitatea informatiei', 'Inteligenta artificiala', 'Practica - Programare In Python', 'Calcul lnameric', 'Grafica pe calculator', 'Managementul clasei de elevi', 'Retele Petri si aplicatii');
  lista_grade_diactice varr := varr('Colaborator','Assistant Lecturer','Lecturer','Associate Professor','Professor');
      
  v_lname VARCHAR2(255);
  v_fname VARCHAR2(255);
  v_fname1 VARCHAR2(255);
  v_fname2 VARCHAR2(255);
  v_matr VARCHAR2(6);
  v_matr_aux VARCHAR2(6);
  v_temp int;
  v_temp1 int;
  v_temp2 int;
  v_temp3 int;
  v_temp_date date;
  v_year int;
  v_groupno varchar2(2);
  v_scholarship int;
  v_dob date;  
  v_email varchar2(40);
BEGIN
  
   DBMS_OUTPUT.PUT_LINE('Adding 1025 students...');
   FOR v_i IN 1..1025 LOOP
      v_lname := lista_lname(TRUNC(DBMS_RANDOM.VALUE(0,lista_lname.count))+1);
      IF (DBMS_RANDOM.VALUE(0,100)<50) THEN      
         v_fname1 := lista_fname_fete(TRUNC(DBMS_RANDOM.VALUE(0,lista_fname_fete.count))+1);
         LOOP
            v_fname2 := lista_fname_fete(TRUNC(DBMS_RANDOM.VALUE(0,lista_fname_fete.count))+1);
            exit when v_fname1<>v_fname2;
         END LOOP;
       ELSE
         v_fname1 := lista_fname_baieti(TRUNC(DBMS_RANDOM.VALUE(0,lista_fname_baieti.count))+1);
         LOOP
            v_fname2 := lista_fname_baieti(TRUNC(DBMS_RANDOM.VALUE(0,lista_fname_baieti.count))+1);
            exit when v_fname1<>v_fname2;
         END LOOP;       
       END IF;
     
     IF (DBMS_RANDOM.VALUE(0,100)<60) THEN  
        IF LENGTH(v_fname1 || ' ' || v_fname2) <= 20 THEN
          v_fname := v_fname1 || ' ' || v_fname2;
        END IF;
        else 
           v_fname:=v_fname1;
      END IF;       
       
      LOOP
         v_matr := FLOOR(DBMS_RANDOM.VALUE(100,999)) || CHR(FLOOR(DBMS_RANDOM.VALUE(65,91))) || CHR(FLOOR(DBMS_RANDOM.VALUE(65,91))) || FLOOR(DBMS_RANDOM.VALUE(0,9));
         select count(*) into v_temp from students where registration_number = v_matr;
         exit when v_temp=0;
      END LOOP;
              
      LOOP      
        v_year := TRUNC(DBMS_RANDOM.VALUE(0,3))+1;
        v_groupno := chr(TRUNC(DBMS_RANDOM.VALUE(0,2))+65) || chr(TRUNC(DBMS_RANDOM.VALUE(0,6))+49);
        select count(*) into v_temp from students where year=v_year and groupno=v_groupno;
        exit when v_temp < 30;
      END LOOP;
      
      v_scholarship := '';
      IF (DBMS_RANDOM.VALUE(0,100)<10) THEN
         v_scholarship := TRUNC(DBMS_RANDOM.VALUE(0,10))*100 + 500;
      END IF;
      
      v_dob := TO_DATE('01-01-1974','MM-DD-YYYY')+TRUNC(DBMS_RANDOM.VALUE(0,365));
      
      v_temp:='';
      v_email := lower(v_lname ||'.'|| v_fname1);
      LOOP         
         select count(*) into v_temp from students where email = v_email||v_temp;
         exit when v_temp=0;
         v_temp :=  TRUNC(DBMS_RANDOM.VALUE(0,100));
      END LOOP;    
      
      if (TRUNC(DBMS_RANDOM.VALUE(0,2))=0) then v_email := v_email ||'@gmail.com';
         else v_email := v_email ||'@info.ro';
      end if;
                      
      --DBMS_OUTPUT.PUT_LINE (v_i||' '||v_matr||' '||v_lname||' '||v_fname ||' '|| v_year ||' '|| v_groupno||' '|| v_scholarship||' '|| to_char(v_dob, 'DD-MM-YYYY')||' '|| v_email);      
      insert into students values(v_i, v_matr, v_lname, v_fname, v_year, v_groupno, v_scholarship, v_dob, v_email, sysdate, sysdate);
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('done !');
   
  
   select count(*) into v_temp from students;
   FOR v_i IN 1..20000 LOOP   
       LOOP
          v_temp1 :=  TRUNC(DBMS_RANDOM.VALUE(0,v_temp-1))+1;
          v_temp2 :=  TRUNC(DBMS_RANDOM.VALUE(0,v_temp-1))+1;
          EXIT WHEN v_temp1<>v_temp2;
       END LOOP;
       DECLARE 
       BEGIN
          --DBMS_OUTPUT.PUT_LINE(v_temp1 || ' ' || v_temp2);
          v_dob := (sysdate-TRUNC(DBMS_RANDOM.VALUE(0,1000)));
          insert into friendships values(v_i, v_temp1, v_temp2, v_dob, v_dob); 
          exception 
             when OTHERS then null;
       END;
   END LOOP;   
      
   
   DBMS_OUTPUT.PUT_LINE('Adding Courses...');
   FOR v_i IN 1..8 LOOP
      IF (v_i<5) THEN v_temp := 1; ELSE v_temp := 2; END IF;
      IF (v_i IN (2,3,6,7)) THEN v_temp1 := 5; END IF; 
      IF (v_i IN (1,5)) THEN v_temp1 := 4; END IF; 
      IF (v_i IN (4,8)) THEN v_temp1 := 6; END IF; 
      insert into courses values (v_i, lista_materii_year_1(v_i), 1, v_temp, v_temp1, sysdate-1200, sysdate-1200);
   END LOOP;
   
   FOR v_i IN 1..8 LOOP
      IF (v_i<5) THEN v_temp := 1; ELSE v_temp := 2; END IF;
      IF (v_i IN (2,3,6,7)) THEN v_temp1 := 5; END IF; 
      IF (v_i IN (1,5)) THEN v_temp1 := 4; END IF; 
      IF (v_i IN (4,8)) THEN v_temp1 := 6; END IF; 
      insert into courses values (v_i+8, lista_materii_year_2(v_i), 2, v_temp, v_temp1, sysdate-1200, sysdate-1200);
   END LOOP;
   
   FOR v_i IN 1..8 LOOP
      IF (v_i<5) THEN v_temp := 1; ELSE v_temp := 2; END IF;
      IF (v_i IN (2,3,6,7)) THEN v_temp1 := 5; END IF; 
      IF (v_i IN (1,5)) THEN v_temp1 := 4; END IF; 
      IF (v_i IN (4,8)) THEN v_temp1 := 6; END IF; 
      insert into courses values (v_i+16, lista_materii_year_3(v_i), 3, v_temp, v_temp1, sysdate-1200, sysdate-1200);
   END LOOP;       
   DBMS_OUTPUT.PUT_LINE('Done !');  
   
   
   DBMS_OUTPUT.PUT_LINE('Adding grades...');
   
   v_temp3 := 1;   
   FOR v_i IN 1..1025 LOOP
       select year into v_temp from students where id = v_i;
       if (v_temp=1) then
          FOR v_temp1 IN 1..8 LOOP
            if (v_temp1 IN (1,2,3,4)) THEN v_temp_date := to_date(to_char(sysdate,'YYYY')||'-01-01','YYYY-MM-DD')+(40+TRUNC(DBMS_RANDOM.VALUE(0,14)))-365;
               ELSE v_temp_date := to_date(to_char(sysdate,'YYYY')||'-01-01','YYYY-MM-DD')+(180+TRUNC(DBMS_RANDOM.VALUE(0,14)))-365;
            END IF;
            insert into grades values (v_temp3, v_i, v_temp1, TRUNC(DBMS_RANDOM.VALUE(0,7)) + 4, v_temp_date, v_temp_date, v_temp_date);
            v_temp3 := v_temp3+1;
          END LOOP;  
       end if;
       if (v_temp=2) then
          FOR v_temp1 IN 1..16 LOOP
            if (v_temp1 IN (1,2,3,4)) THEN v_temp_date := to_date(to_char(sysdate,'YYYY')||'-01-01','YYYY-MM-DD')+(40+TRUNC(DBMS_RANDOM.VALUE(0,14)))-730; END IF;
            if (v_temp1 IN (5,6,7,8)) THEN v_temp_date := to_date(to_char(sysdate,'YYYY')||'-01-01','YYYY-MM-DD')+(180+TRUNC(DBMS_RANDOM.VALUE(0,14)))-730; END IF;          
            if (v_temp1 IN (9,10,11,12)) THEN v_temp_date := to_date(to_char(sysdate,'YYYY')||'-01-01','YYYY-MM-DD')+(40+TRUNC(DBMS_RANDOM.VALUE(0,14)))-365; END IF;
            if (v_temp1 IN (13,14,15,16)) THEN v_temp_date := to_date(to_char(sysdate,'YYYY')||'-01-01','YYYY-MM-DD')+(180+TRUNC(DBMS_RANDOM.VALUE(0,14)))-365; END IF;                                   
            insert into grades values (v_temp3, v_i, v_temp1, TRUNC(DBMS_RANDOM.VALUE(0,7)) + 4, v_temp_date, v_temp_date, v_temp_date);
            v_temp3 := v_temp3+1;
          END LOOP;  
       end if;  
       
       if (v_temp=3) then
          FOR v_temp1 IN 1..24 LOOP
            if (v_temp1 IN (1,2,3,4)) THEN v_temp_date := to_date(to_char(sysdate,'YYYY')||'-01-01','YYYY-MM-DD')+(40+TRUNC(DBMS_RANDOM.VALUE(0,14)))-1095; END IF;
            if (v_temp1 IN (5,6,7,8)) THEN v_temp_date := to_date(to_char(sysdate,'YYYY')||'-01-01','YYYY-MM-DD')+(180+TRUNC(DBMS_RANDOM.VALUE(0,14)))-1095; END IF;          
            if (v_temp1 IN (9,10,11,12)) THEN v_temp_date := to_date(to_char(sysdate,'YYYY')||'-01-01','YYYY-MM-DD')+(40+TRUNC(DBMS_RANDOM.VALUE(0,14)))-730; END IF;
            if (v_temp1 IN (13,14,15,16)) THEN v_temp_date := to_date(to_char(sysdate,'YYYY')||'-01-01','YYYY-MM-DD')+(180+TRUNC(DBMS_RANDOM.VALUE(0,14)))-730; END IF;                                   
            if (v_temp1 IN (17,18,19,20)) THEN v_temp_date := to_date(to_char(sysdate,'YYYY')||'-01-01','YYYY-MM-DD')+(40+TRUNC(DBMS_RANDOM.VALUE(0,14)))-365; END IF;
            if (v_temp1 IN (21,22,23,24)) THEN v_temp_date := to_date(to_char(sysdate,'YYYY')||'-01-01','YYYY-MM-DD')+(180+TRUNC(DBMS_RANDOM.VALUE(0,14)))-365; END IF;                                   
            
            insert into grades values (v_temp3, v_i, v_temp1, TRUNC(DBMS_RANDOM.VALUE(0,7)) + 4, v_temp_date, v_temp_date, v_temp_date);
            v_temp3 := v_temp3+1;
          END LOOP;  
       end if;                
   END LOOP;
   
   DBMS_OUTPUT.PUT_LINE('Done !');
   
   
   DBMS_OUTPUT.PUT_LINE('Adding instructors...');
   
   FOR v_i IN 1..30 LOOP
      v_lname := lista_lname(TRUNC(DBMS_RANDOM.VALUE(0,lista_lname.count))+1);
      IF (DBMS_RANDOM.VALUE(0,100)<50) THEN      
         v_fname1 := lista_fname_fete(TRUNC(DBMS_RANDOM.VALUE(0,lista_fname_fete.count))+1);
         LOOP
            v_fname2 := lista_fname_fete(TRUNC(DBMS_RANDOM.VALUE(0,lista_fname_fete.count))+1);
            exit when v_fname1<>v_fname2;
         END LOOP;
       ELSE
         v_fname1 := lista_fname_baieti(TRUNC(DBMS_RANDOM.VALUE(0,lista_fname_baieti.count))+1);
         LOOP
            v_fname2 := lista_fname_baieti(TRUNC(DBMS_RANDOM.VALUE(0,lista_fname_baieti.count))+1);
            exit when v_fname1<>v_fname2;
         END LOOP;       
       END IF;
       
       IF (DBMS_RANDOM.VALUE(0,100)<60) THEN  
          IF LENGTH(v_fname1 || ' ' || v_fname2) <= 20 THEN
            v_fname := v_fname1 || ' ' || v_fname2;
          END IF;
          else 
             v_fname:=v_fname1;
        END IF;           
        INSERT INTO instructors values (v_i, v_lname, v_fname, lista_grade_diactice(TRUNC(DBMS_RANDOM.VALUE(0,5))+1), sysdate-1000, sysdate-1000);       
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Done !');  
    
    
    DBMS_OUTPUT.PUT_LINE('Adding links between instructors and courses...');
    v_temp3:=1;
    FOR v_i IN 1..24 LOOP
       INSERT INTO didactic values(v_temp3,v_i, v_i, sysdate-1000, sysdate-1000);
       v_temp3:=v_temp3+1;
    END LOOP;
    
    FOR v_i IN 1..50 LOOP
       INSERT INTO didactic values(v_temp3,(TRUNC(DBMS_RANDOM.VALUE(0,30))+1), (TRUNC(DBMS_RANDOM.VALUE(0,24))+1), sysdate-1000, sysdate-1000);
       v_temp3:=v_temp3+1;
    END LOOP;
    
    
    DBMS_OUTPUT.PUT_LINE('Done !');      
    
END;
/


select count(*)|| ' students' from students;
select count(*)|| ' instructors' from instructors;
select count(*)|| ' courses' from courses;
select count(*)|| ' grades' from grades;
select count(*)|| ' friendships' from friendships;
