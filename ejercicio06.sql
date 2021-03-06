-- Ejercicio 06

-- DELETE

SELECT COUNT(*) FROM EMPLOYEE;
-- 27 empleados

COMMIT;
DELETE FROM EMPLOYEE; 
-- 28 filas
ROLLBACK;

SELECT * FROM EMPLOYEE;

DELETE FROM EMPLOYEE WHERE EMPNO='000010'; 

DELETE FROM EMPLOYEE WHERE MIDINIT IS NULL; 

DELETE FROM EMPLOYEE WHERE WORKDEPT =
	(SELECT DEPTNO
     FROM DEPARTMENT
     WHERE DEPTNAME='PLANNING'); 


-- INSERT

CREATE TABLE CLIENTES(DNI STRING PRIMARY KEY, NOMBRE STRING, DIR STRING);

INSERT INTO CLIENTES VALUES ('1111','Mario','C/. Mayor, 3');

DELETE FROM CLIENTES;

INSERT INTO CLIENTES (NOMBRE,DIR,DNI)  VALUES ('Mario','C/. Mayor, 3','1111');

DELETE FROM CLIENTES;

INSERT INTO CLIENTES (DNI,DIR,NOMBRE) VALUES ('1111','C/. Mayor, 3','Mario');

INSERT INTO CLIENTES (DNI,NOMBRE) VALUES ('2222','Jes�s');

SELECT * FROM CLIENTES WHERE DNI='2222';

INSERT INTO EMPLOYEE
  VALUES ('111111', 'JOHN', NULL, 'SMITH', 'C01', NULL, 
          '2019-06-25', NULL, 19, 
          NULL, NULL, 45000, NULL, NULL);

DELETE FROM EMPLOYEE WHERE EMPNO='111111';

INSERT INTO EMPLOYEE(EMPNO, FIRSTNAME, LASTNAME, WORKDEPT, HIREDATE, EDLEVEL, SALARY) VALUES ('111111', 'JOHN', 'SMITH', 'C01','2019-06-25', 19, 45000);

SELECT * FROM EMPLOYEE WHERE EMPNO='111111';

ALTER TABLE CLIENTES ALTER 
    DIR STRING DEFAULT 'Falta la direcci�n';

INSERT INTO CLIENTES(DNI,NOMBRE) VALUES ('3333','Carlos');

DELETE FROM CLIENTES;

INSERT INTO CLIENTES(NOMBRE, DIR, DNI) VALUES
  ('Mario', 'C/. Mayor, 3', '1111'),
  ('Jes�s', NULL, '2222');

CREATE TABLE TESTEMP(EMPNO CHAR(6) PRIMARY KEY, LASTNAME VARCHAR(15), WORKDEPT CHAR(3), HIREDATE DATE, SALARY FLOAT, BONUS FLOAT);

INSERT INTO TESTEMP
  SELECT EMPNO, LASTNAME, WORKDEPT, HIREDATE, SALARY,BONUS
  FROM EMPLOYEE
  WHERE EMPNO <= '000050';

-- UPDATE

UPDATE TESTEMP SET SALARY = ROUND(SALARY * 1.05);

UPDATE TESTEMP SET BONUS = ROUND(BONUS * 1.01, 2) WHERE SALARY < 100000;

UPDATE TESTEMP SET
  EMPNO = '000040', 
  SALARY = 99000 
WHERE EMPNO = '000030';

UPDATE TESTEMP SET SALARY = ROUND(SALARY * 1.03)
WHERE WORKDEPT = 
     (SELECT DEPTNO 
      FROM DEPARTMENT
      WHERE DEPTNAME = 'INFORMATION CENTER');


CREATE TABLE GRUPOS(
  NOMBRE  STRING PRIMARY KEY, 
  ALBUMES INT);

CREATE TABLE LP(
  TIT      STRING, 
  GRUPO    STRING REFERENCES GRUPOS(NOMBRE),
  A�O      INT, 
  NUM_CANC INT, 
  PRIMARY KEY (TIT, GRUPO));

INSERT INTO GRUPOS VALUES 
  ('Mecano', 0), 
  ('Queen', 0);

INSERT INTO LP(TIT, GRUPO, A�O, NUM_CANC) VALUES 
  ('Mecano',          'Mecano', 1982, 12),
  ('Ya viene el Sol', 'Mecano', 1984, 10),
  ('The Game',         'Queen', 1980, 10);

UPDATE GRUPOS G
   SET ALBUMES = (SELECT COUNT(DISTINCT  TIT) 
                  FROM LP
                  WHERE G.NOMBRE = GRUPO
                  GROUP BY GRUPO);

-- Transacciones

-- Ejemplo I
-- Transferencia de 500�

CREATE TABLE CUENTAS(
  N�MERO STRING PRIMARY KEY, 
  TIPO   STRING, 
  SALDO  FLOAT);

INSERT INTO CUENTAS VALUES
  ('3207', 'Corriente', 1500),
  ('3208', 'Ahorro', 2500);

DELETE FROM CUENTAS WHERE N�MERO='3208';

-- Otros ejemplos de transacciones
-- Ejemplo II

CREATE TABLE EMPLEADO
 (NIF       VARCHAR(9) NOT NULL PRIMARY KEY,
  NOMBRE    VARCHAR(20),
  SALARIO   NUMBER(6,2),
  APELLIDOS VARCHAR(40));

COMMIT;
 
INSERT INTO EMPLEADO VALUES('10000000A','Jorge',3000.11,'P�rez Sala');

ROLLBACK;

INSERT INTO EMPLEADO VALUES('30000000C','Javier',2000.22,'Sala Rodr�guez');

INSERT INTO EMPLEADO VALUES('30000000C','Soledad',2000.33,'L�pez J.'); -- Esta instrucci�n debe dar error por clave repetida

INSERT INTO EMPLEADO VALUES('40000000D','Sonia',1800.44,'Moldes R.');

INSERT INTO EMPLEADO VALUES('50000000E','Antonio',1800.44,'L�pez A.');

COMMIT;


-- Ejemplo III

UPDATE EMPLEADO SET SALARIO = 7000  
WHERE NIF = '30000000C';

SAVEPOINT after_salario; 

UPDATE EMPLEADO SET SALARIO = 12000 
WHERE NIF = '40000000D'; 

ROLLBACK TO SAVEPOINT after_salario;

UPDATE EMPLEADO SET SALARIO = 11000 
WHERE NIF = '40000000D';

COMMIT;

INSERT INTO EMPLEADO VALUES ('70000000C','Soledad',2000.33,'Lopez J.');


-- Vistas

CREATE VIEW JEFES(Apellido,Nombre) AS 
SELECT LASTNAME, FIRSTNAME 
FROM EMPLOYEE JOIN DEPARTMENT 
  ON WORKDEPT = DEPTNO AND EMPNO = MGRNO;

SELECT * FROM JEFES WHERE Apellido LIKE 'S%';

DROP VIEW JEFES;

CREATE VIEW JEFES AS 
SELECT LASTNAME, FIRSTNAME 
FROM EMPLOYEE JOIN DEPARTMENT 
  ON WORKDEPT = DEPTNO AND EMPNO = MGRNO;

-- Vistas locales
-- Ejemplo I

WITH SALMEANS(DEPTNO,MEAN) AS (
  SELECT WORKDEPT, AVG(SALARY) MEAN
  FROM EMPLOYEE 
  GROUP BY WORKDEPT)
SELECT DISTINCT EMPNO, LASTNAME
FROM EMPLOYEE NATURAL JOIN SALMEANS
WHERE SALARY > MEAN;

SELECT * FROM SALMEANS; -- Debe dar Error

-- Ejemplo II

CREATE TABLE STORES(
  NAME    STRING PRIMARY KEY, 
  ADDRESS STRING, 
  MANAGER STRING);

CREATE TABLE SALES(
  NAME  STRING, 
  ITEM  STRING, 
  QTY   INTEGER,
  PRIMARY KEY (NAME, ITEM));

INSERT INTO STORES VALUES
 ('STORE1', 'ADDRESS1', 'MANAGER1'),
 ('STORE2', 'ADDRESS2', 'MANAGER2'),
 ('STORE3', 'ADDRESS3', 'MANAGER3');

INSERT INTO SALES VALUES
 ('STORE1','PROD1',20),
 ('STORE1','PROD2',40),
 ('STORE2','PROD1',15),
 ('STORE2','PROD2',30),
 ('STORE2','PROD3',70),
 ('STORE3','PROD1',10);

WITH
   SUM_SALES(ALL_SALES) AS 
      ( SELECT SUM(QTY) FROM SALES ),
   NUMBER_STORES(NBR_STORES) AS 
      ( SELECT COUNT(*) FROM STORES ),
   SALES_BY_STORE(NAME, STORE_SALES ) AS
      ( SELECT NAME, SUM(QTY) 
        FROM STORES NATURAL JOIN SALES 
        GROUP BY NAME )
SELECT
   NAME
FROM
   STORES NATURAL JOIN SALES_BY_STORE, SUM_SALES, NUMBER_STORES
WHERE
   STORE_SALES > (ALL_SALES / NBR_STORES);
