/p Empleados
/display_answer on
/duplicates on

-- P. 61
SELECT SUM(SALARY)    AS SUM,
       AVG(SALARY)    AS AVG,
       MIN(SALARY)    AS MIN,
       MAX(SALARY)    AS MAX,
       COUNT(*)       AS TODOS,
       COUNT(MIDINIT) AS MIDINIT_NO_NULOS,
       COUNT(DISTINCT WORKDEPT) AS DEPT 
FROM EMPLOYEE;

-- P. 63
SELECT WORKDEPT, COUNT(*) AS EMPLEADOS
FROM EMPLOYEE
GROUP BY WORKDEPT
ORDER BY WORKDEPT;

-- P. 65
SELECT WORKDEPT, SALARY
FROM EMPLOYEE
WHERE WORKDEPT IN ('A00', 'B01', 'C01')
ORDER BY WORKDEPT;

SELECT WORKDEPT, SUM(SALARY) AS SUM
FROM EMPLOYEE
WHERE WORKDEPT IN ('A00', 'B01', 'C01')
GROUP BY WORKDEPT
ORDER BY WORKDEPT;

-- P. 67
SELECT WORKDEPT, COUNT(*) AS NUMB 
FROM EMPLOYEE
GROUP BY WORKDEPT
ORDER BY WORKDEPT;

SELECT WORKDEPT, COUNT(*) AS NUMB 
FROM EMPLOYEE
GROUP BY WORKDEPT
HAVING COUNT(*) > 1
ORDER BY WORKDEPT;

-- P. 68
SELECT WORKDEPT, SUM(SALARY) AS SUM
FROM EMPLOYEE
WHERE WORKDEPT IN ('A00', 'B01', 'C01')
GROUP BY WORKDEPT
ORDER BY WORKDEPT;

SELECT WORKDEPT, SUM(SALARY) AS SUM
FROM EMPLOYEE
WHERE WORKDEPT IN ('A00', 'B01', 'C01')
GROUP BY WORKDEPT
HAVING SUM(SALARY)>100000
ORDER BY WORKDEPT;

-- P. 69
SELECT WORKDEPT, JOB, AVG(SALARY) AS AVG
FROM EMPLOYEE
WHERE JOB NOT IN ('MANAGER', 'DESIGNER', 'FIELDREP')
GROUP BY WORKDEPT, JOB
HAVING AVG(SALARY) > 50000
ORDER BY WORKDEPT, JOB;

-- P. 70
SELECT WORKDEPT, AVG(EDLEVEL) AS ED, TRUNC(AVG(CURRENT_DATE-HIREDATE)/365.25) AS YEARS
FROM EMPLOYEE
GROUP BY WORKDEPT
ORDER BY AVG(EDLEVEL);

SELECT WORKDEPT, AVG(EDLEVEL) AS ED, TRUNC(AVG(CURRENT_DATE-HIREDATE)/365.25) AS YEARS
FROM EMPLOYEE
GROUP BY WORKDEPT
HAVING TRUNC(AVG(CURRENT_DATE-HIREDATE)/365.25) > 20
ORDER BY AVG(EDLEVEL);

-- P. 71
SELECT WORKDEPT, AVG(EDLEVEL) AS ED, TRUNC(AVG(CURRENT_DATE-HIREDATE)/365.25) AS YEARS
FROM EMPLOYEE
GROUP BY WORKDEPT
HAVING YEARS > 20
ORDER BY ED;

SELECT WORKDEPT, AVG(EDLEVEL) AS ED, TRUNC(AVG(CURRENT_DATE-HIREDATE)/365.25) AS YEARS
FROM EMPLOYEE
GROUP BY WORKDEPT
HAVING YEARS > 20
ORDER BY 2;

-- P. 72
SELECT
  WORKDEPT,
  TRUNC(AVG(EDLEVEL),1) AS ED,
  MIN(BONUS) AS MIN
FROM EMPLOYEE
GROUP BY WORKDEPT;

SELECT
  WORKDEPT,
  TRUNC(AVG(EDLEVEL),1) AS ED,
  MIN(BONUS) AS MIN
FROM EMPLOYEE
GROUP BY WORKDEPT
HAVING MIN(BONUS) >= 3000;

-- P. 75
SELECT EMPNO, LASTNAME, WORKDEPT, DEPTNAME 
FROM EMPLOYEE, DEPARTMENT
WHERE WORKDEPT = DEPTNO AND 
      LASTNAME LIKE 'HAAS%';

-- P. 76
SELECT EMPNO, LASTNAME, WORKDEPT, DEPTNO, DEPTNAME 
FROM EMPLOYEE, DEPARTMENT
WHERE LASTNAME LIKE 'HAAS%';

-- P. 78
CREATE TABLE t1(c1 STRING);

CREATE TABLE t2(c2 STRING);

INSERT INTO t1 VALUES ('a'),('b');

INSERT INTO t2 VALUES ('c'),('d');

SELECT * FROM t1, t2;

-- P. 79
SELECT EMPNO, LASTNAME, WORKDEPT, DEPTNAME 
FROM EMPLOYEE JOIN DEPARTMENT ON WORKDEPT = DEPTNO 
WHERE LASTNAME LIKE 'HAAS%';

