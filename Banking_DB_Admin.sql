PURGE RECYCLEBIN;
SET SERVEROUTPUT ON;
-- *************** DROPING ANY TABLES IF EXISTS *****************/
BEGIN
EXECUTE IMMEDIATE 'DROP TABLE TRANSACTION CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS
   THEN NULL;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE ACCOUNT CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS
   THEN NULL;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE CUSTOMER CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS
   THEN NULL;
END;
/

BEGIN
EXECUTE IMMEDIATE 'DROP TABLE EMPLOYEE CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS
   THEN NULL;
END;
/


BEGIN
EXECUTE IMMEDIATE 'DROP TABLE BRANCH CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS
   THEN NULL;
END;
/

-- *************** CREATING TABLES *****************/
CREATE TABLE BRANCH(
BRANCH_ID INT NOT NULL PRIMARY KEY,
NAME VARCHAR2(50),
STREET VARCHAR2(50),
CITY VARCHAR2(50),
STATE VARCHAR2(50),
ZIPCODE INT
);


CREATE TABLE EMPLOYEE(
EMP_ID INT NOT NULL PRIMARY KEY,
BRANCH_ID INT REFERENCES BRANCH(BRANCH_ID) ON DELETE CASCADE,
FNAME VARCHAR2(50),
LNAME VARCHAR2(50),
STREET VARCHAR2(50),
CITY VARCHAR2(50),
STATE VARCHAR2(50),
ZIPCODE INT,
POSITION VARCHAR2(50) NOT NULL,
MOB_NO INT UNIQUE CONSTRAINT CHECK_EMP_MOB CHECK (MOB_NO BETWEEN 0 AND 9999999999),
EMAIL VARCHAR2(50) UNIQUE CONSTRAINT CHECK_EMP_EM CHECK (EMAIL LIKE '%@%.%'),
GENDER VARCHAR2(50) CONSTRAINT CHECK_EMP_G CHECK (GENDER IN ('MALE', 'FEMALE', 'OTHER')),
SSN INT NOT NULL UNIQUE,
DATE_OF_BIRTH DATE NOT NULL,
JOINING_DATE DATE NOT NULL
);


CREATE TABLE CUSTOMER(
CUST_ID INT NOT NULL PRIMARY KEY,
EMP_ID INT REFERENCES EMPLOYEE(EMP_ID)  ON DELETE CASCADE,
FNAME VARCHAR2(50),
LNAME VARCHAR2(50),
STREET VARCHAR2(50),
CITY VARCHAR2(50),
STATE VARCHAR2(50),
ZIPCODE INT,
MOB_NO INT UNIQUE CONSTRAINT CHECK_CUST_MOB CHECK (MOB_NO BETWEEN 0 AND 9999999999),
EMAIL VARCHAR2(50) UNIQUE CONSTRAINT CHECK_CUST_EM CHECK (EMAIL LIKE '%@%.%'),
GENDER VARCHAR2(50) CONSTRAINT CHECK_CUST_G CHECK (GENDER IN ('MALE', 'FEMALE', 'OTHER')),
SSN INT NOT NULL UNIQUE,
DATE_OF_BIRTH DATE,
NATIONALITY VARCHAR2(50),
USERNAME VARCHAR2(50) NOT NULL UNIQUE,
PASSWORD VARCHAR2(50) NOT NULL
);


CREATE TABLE ACCOUNT(
ACC_NO INT NOT NULL PRIMARY KEY,
CUST_ID INT REFERENCES CUSTOMER(CUST_ID)  ON DELETE CASCADE,
ACC_TYPE VARCHAR2(50) CONSTRAINT CHECK_ACC_TYPE CHECK (ACC_TYPE IN ('SAVINGS', 'CHECKIN')),
STATUS VARCHAR2(50) CONSTRAINT CHECK_ACC_STATUS CHECK (STATUS IN ('ACTIVE', 'INACTIVE')),
BALANCE FLOAT NOT NULL
);


CREATE TABLE TRANSACTION(
TRANS_ID INT NOT NULL PRIMARY KEY,
PRI_ACC_NO INT REFERENCES ACCOUNT(ACC_NO) ON DELETE CASCADE,
SEC_ACC_NO INT REFERENCES ACCOUNT(ACC_NO),
TRANS_TYPE VARCHAR2(50) NOT NULL CONSTRAINT CHECK_TRANS_TYPE CHECK (TRANS_TYPE IN ('DD', 'CHEQUE', 'ZELLE')),
TRANS_DATE DATE DEFAULT SYSDATE,
AMOUNT FLOAT NOT NULL,
DEBIT_CREDIT_FLAG VARCHAR(10) NOT NULL CONSTRAINT CHECK_TRANS_FLAG CHECK (DEBIT_CREDIT_FLAG IN ('DEBIT', 'CREDIT'))
);


-- /*************** BRANCH PACKAGE *****************/
CREATE OR REPLACE PACKAGE BRANCH_PK
AS
	PROCEDURE INSERT_BRH(P_BRANCH_ID BRANCH.BRANCH_ID%TYPE, P_NAME BRANCH.NAME%TYPE  , P_STREET BRANCH.STREET%TYPE , P_CITY BRANCH.CITY%TYPE , P_STATE BRANCH.STATE%TYPE , P_ZIPCODE BRANCH.ZIPCODE%TYPE );
	PROCEDURE DELETE_BRH( P_BRANCH_ID BRANCH.BRANCH_ID%TYPE);
    PROCEDURE TRUN_BRH;
END;
/


CREATE OR REPLACE PACKAGE BODY BRANCH_PK AS

PROCEDURE INSERT_BRH(P_BRANCH_ID IN BRANCH.BRANCH_ID%TYPE, P_NAME IN BRANCH.NAME%TYPE, P_STREET IN BRANCH.STREET%TYPE, P_CITY IN BRANCH.CITY%TYPE, P_STATE IN BRANCH.STATE%TYPE, P_ZIPCODE IN BRANCH.ZIPCODE%TYPE) AS 
BEGIN 	
	INSERT INTO BRANCH (BRANCH_ID, NAME, STREET, CITY, STATE, ZIPCODE) VALUES (P_BRANCH_ID, P_NAME, P_STREET, P_CITY, P_STATE, P_ZIPCODE);
END;

PROCEDURE DELETE_BRH(P_BRANCH_ID IN BRANCH.BRANCH_ID%TYPE) AS
BEGIN 
	DELETE FROM BRANCH WHERE BRANCH_ID = P_BRANCH_ID;
END;

PROCEDURE TRUN_BRH AS
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE BRANCH';
END;

END BRANCH_PK;
/


-- /*************** EMPLOYEE PACKAGE *****************/
CREATE OR REPLACE PACKAGE EMP_PK AS
	PROCEDURE INSERT_EMP(E_BRANCH_ID EMPLOYEE.BRANCH_ID%TYPE, 
        E_FNAME EMPLOYEE.FNAME%TYPE, 
        E_LNAME EMPLOYEE.LNAME%TYPE, 
        E_STREET EMPLOYEE.STREET%TYPE, 
        E_CITY EMPLOYEE.CITY%TYPE, 
        E_STATE EMPLOYEE.STATE%TYPE, 
        E_ZIPCODE EMPLOYEE.ZIPCODE%TYPE, 
        E_POSITION EMPLOYEE.POSITION%TYPE, 
        E_MOB_NO INT, 
        E_EMAIL EMPLOYEE.EMAIL%TYPE, 
        E_GENDER EMPLOYEE.GENDER%TYPE, 
        E_SSN INT, 
        E_DATE_OF_BIRTH DATE, 
        E_JOINING_DATE DATE);
	PROCEDURE DELETE_EMP(E_EMP_ID EMPLOYEE.EMP_ID%TYPE);
    PROCEDURE TRUN_EMP;
END;
/

CREATE OR REPLACE PACKAGE BODY EMP_PK AS

PROCEDURE INSERT_EMP(E_BRANCH_ID IN EMPLOYEE.BRANCH_ID%TYPE, 
    E_FNAME IN EMPLOYEE.FNAME%TYPE, 
    E_LNAME IN EMPLOYEE.LNAME%TYPE, 
    E_STREET IN EMPLOYEE.STREET%TYPE, 
    E_CITY IN EMPLOYEE.CITY%TYPE, 
    E_STATE IN EMPLOYEE.STATE%TYPE, 
    E_ZIPCODE IN EMPLOYEE.ZIPCODE%TYPE, 
    E_POSITION IN EMPLOYEE.POSITION%TYPE, 
    E_MOB_NO IN INT, 
    E_EMAIL IN EMPLOYEE.EMAIL%TYPE, 
    E_GENDER IN EMPLOYEE.GENDER%TYPE, 
    E_SSN IN INT, 
    E_DATE_OF_BIRTH IN DATE, 
    E_JOINING_DATE IN DATE) AS
BEGIN 	
	INSERT INTO EMPLOYEE (EMP_ID, BRANCH_ID, FNAME, LNAME, STREET, CITY, STATE, ZIPCODE, POSITION, MOB_NO, EMAIL, GENDER, SSN, DATE_OF_BIRTH, JOINING_DATE) 
	VALUES (EMP_SEQ.NEXTVAL, E_BRANCH_ID, E_FNAME, E_LNAME, E_STREET, E_CITY, E_STATE, E_ZIPCODE, E_POSITION, E_MOB_NO, E_EMAIL, E_GENDER, E_SSN, E_DATE_OF_BIRTH, E_JOINING_DATE);
END;

PROCEDURE DELETE_EMP(E_EMP_ID IN EMPLOYEE.EMP_ID%TYPE) AS
BEGIN 
	DELETE FROM EMPLOYEE WHERE EMP_ID = E_EMP_ID;
END;

PROCEDURE TRUN_EMP AS
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE EMPLOYEE';
END;

END EMP_PK;
/


-- /*************** CUSTOMER PACKAGE *****************/
CREATE OR REPLACE PACKAGE CUST_PK AS
	PROCEDURE INSERT_CUST (C_EMP_ID CUSTOMER.EMP_ID%TYPE, 
        C_FNAME CUSTOMER.FNAME%TYPE, 
        C_LNAME CUSTOMER.LNAME%TYPE, 
        C_STREET CUSTOMER.STREET%TYPE, 
        C_CITY CUSTOMER.CITY%TYPE, 
        C_STATE CUSTOMER.STATE%TYPE, 
        C_ZIPCODE CUSTOMER.ZIPCODE%TYPE, 
        C_MOB_NO INT, 
        C_EMAIL CUSTOMER.EMAIL%TYPE, 
        C_GENDER CUSTOMER.GENDER%TYPE, 
        C_SSN INT, 
        C_DATE_OF_BIRTH DATE, 
        C_NATIONALITY CUSTOMER.NATIONALITY%TYPE, 
        C_USERNAME CUSTOMER.USERNAME%TYPE, 
        C_PASSWORD CUSTOMER.PASSWORD%TYPE);
	PROCEDURE DELETE_CUST(C_CUST_ID CUSTOMER.CUST_ID%TYPE);
    PROCEDURE TRUN_CUST;
END;
/


CREATE OR REPLACE PACKAGE BODY CUST_PK AS

PROCEDURE INSERT_CUST(C_EMP_ID IN CUSTOMER.EMP_ID%TYPE, 
    C_FNAME IN CUSTOMER.FNAME%TYPE, 
    C_LNAME IN CUSTOMER.LNAME%TYPE, 
    C_STREET IN CUSTOMER.STREET%TYPE, 
    C_CITY IN CUSTOMER.CITY%TYPE, 
    C_STATE IN CUSTOMER.STATE%TYPE, 
    C_ZIPCODE IN CUSTOMER.ZIPCODE%TYPE, 
    C_MOB_NO IN INT, 
    C_EMAIL IN CUSTOMER.EMAIL%TYPE, 
    C_GENDER IN CUSTOMER.GENDER%TYPE, 
    C_SSN IN INT, 
    C_DATE_OF_BIRTH IN DATE, 
    C_NATIONALITY IN CUSTOMER.NATIONALITY%TYPE, 
    C_USERNAME IN CUSTOMER.USERNAME%TYPE, 
    C_PASSWORD IN CUSTOMER.PASSWORD%TYPE) AS
BEGIN 	
	INSERT INTO CUSTOMER (CUST_ID, EMP_ID, FNAME, LNAME, STREET, CITY, STATE, ZIPCODE, MOB_NO, EMAIL, GENDER, SSN, DATE_OF_BIRTH, NATIONALITY, USERNAME, PASSWORD) 
	VALUES (CUST_SEQ.NEXTVAL, C_EMP_ID, C_FNAME, C_LNAME, C_STREET, C_CITY, C_STATE, C_ZIPCODE, C_MOB_NO, C_EMAIL, C_GENDER, C_SSN, C_DATE_OF_BIRTH, C_NATIONALITY, C_USERNAME, C_PASSWORD);
END;

PROCEDURE DELETE_CUST(C_CUST_ID IN CUSTOMER.CUST_ID%TYPE) AS
BEGIN 
	DELETE FROM CUSTOMER WHERE CUST_ID = C_CUST_ID;
END;

PROCEDURE TRUN_CUST AS
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE CUSTOMER';
END;

END CUST_PK;
/


-- /*************** ACCOUNT PACKAGE *****************/
CREATE OR REPLACE PACKAGE ACC_PK AS
	PROCEDURE INSERT_ACC(A_ACC_NO ACCOUNT.ACC_NO%TYPE, 
        A_CUST_ID ACCOUNT.CUST_ID%TYPE, 
        A_ACC_TYPE ACCOUNT.ACC_TYPE%TYPE, 
        A_STATUS ACCOUNT.STATUS%TYPE, 
        A_BALANCE ACCOUNT.BALANCE%TYPE);
	PROCEDURE DELETE_ACC(A_ACC_NO ACCOUNT.ACC_NO%TYPE);
    PROCEDURE TRUN_ACC;
END;
/


CREATE OR REPLACE PACKAGE BODY ACC_PK AS

PROCEDURE INSERT_ACC(A_ACC_NO IN ACCOUNT.ACC_NO%TYPE, 
    A_CUST_ID IN ACCOUNT.CUST_ID%TYPE, 
    A_ACC_TYPE IN ACCOUNT.ACC_TYPE%TYPE, 
    A_STATUS IN ACCOUNT.STATUS%TYPE, 
    A_BALANCE IN ACCOUNT.BALANCE%TYPE) AS
BEGIN 	
	INSERT INTO ACCOUNT (ACC_NO, CUST_ID, ACC_TYPE, STATUS, BALANCE) 
	VALUES (A_ACC_NO, A_CUST_ID, A_ACC_TYPE, A_STATUS, A_BALANCE);
END;

PROCEDURE DELETE_ACC(A_ACC_NO IN ACCOUNT.ACC_NO%TYPE) AS
BEGIN 
	DELETE FROM ACCOUNT WHERE ACC_NO = A_ACC_NO;
END;

PROCEDURE TRUN_ACC AS
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE ACCOUNT';
END;

END ACC_PK;
/


-- /*************** TRANSACTION PACKAGE *****************/
CREATE OR REPLACE PACKAGE TRANS_PK
AS

	PROCEDURE INSERT_TRANS(T_TRANS_ID TRANSACTION.TRANS_ID%TYPE, 
    T_PRI_ACC_NO INT, 
    T_SEC_ACC_NO INT,
    T_TRANS_TYPE  TRANSACTION.TRANS_TYPE%TYPE, 
    T_TRANS_DATE DATE, 
    T_AMOUNT  TRANSACTION.AMOUNT%TYPE,
    T_DEBIT_CREDIT_FLAG TRANSACTION.DEBIT_CREDIT_FLAG%TYPE);
	PROCEDURE DELETE_TRANS(T_TRANS_ID TRANSACTION.TRANS_ID%TYPE);
    PROCEDURE TRUN_TRANS;
END;
/


CREATE OR REPLACE PACKAGE BODY TRANS_PK AS

PROCEDURE INSERT_TRANS(T_TRANS_ID IN TRANSACTION.TRANS_ID%TYPE, 
    T_PRI_ACC_NO IN INT, 
    T_SEC_ACC_NO INT,
    T_TRANS_TYPE  IN TRANSACTION.TRANS_TYPE%TYPE, 
    T_TRANS_DATE IN DATE, 
    T_AMOUNT IN TRANSACTION.AMOUNT%TYPE,
    T_DEBIT_CREDIT_FLAG IN TRANSACTION.DEBIT_CREDIT_FLAG%TYPE) AS
BEGIN 	
	INSERT INTO TRANSACTION (TRANS_ID, PRI_ACC_NO, SEC_ACC_NO, TRANS_TYPE, TRANS_DATE, AMOUNT, DEBIT_CREDIT_FLAG) 
	VALUES (T_TRANS_ID, T_PRI_ACC_NO, T_SEC_ACC_NO, T_TRANS_TYPE, T_TRANS_DATE, T_AMOUNT, T_DEBIT_CREDIT_FLAG);
END;

PROCEDURE DELETE_TRANS(T_TRANS_ID TRANSACTION.TRANS_ID%TYPE) AS
BEGIN 
	DELETE FROM TRANSACTION WHERE TRANS_ID = T_TRANS_ID;
END;

PROCEDURE TRUN_TRANS AS
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE TRANSACTION';
END;

END TRANS_PK;
/


-- GRANTING EXECUTE PERMISSION ON THE OBJECTS CREATED BY DB_ADMIN
GRANT EXECUTE ON DB_ADMIN.BRANCH_PK TO DB_OPERATOR;
GRANT EXECUTE ON DB_ADMIN.EMP_PK TO DB_OPERATOR;
GRANT EXECUTE ON DB_ADMIN.CUST_PK TO DB_OPERATOR;
GRANT EXECUTE ON DB_ADMIN.ACC_PK TO DB_OPERATOR;
GRANT EXECUTE ON DB_ADMIN.TRANS_PK TO DB_OPERATOR;

-- GRANTING READ ONLY ACCESS
GRANT SELECT ON BRANCH TO DB_ANALYST;
GRANT SELECT ON EMPLOYEE TO DB_ANALYST;
GRANT SELECT ON CUSTOMER TO DB_ANALYST;
GRANT SELECT ON ACCOUNT TO DB_ANALYST;
GRANT SELECT ON TRANSACTION TO DB_ANALYST;


--SELECT * FROM ACCOUNT;

--DELETE FROM ACCOUNT WHERE ACC_NO = 231872;

--SELECT * FROM DB_ADMIN.TRANSACTION WHERE PRI_ACC_NO = 238524 ORDER BY TRANS_DATE DESC FETCH FIRST 2 ROWS ONLY;