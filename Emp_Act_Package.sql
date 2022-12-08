CREATE OR REPLACE PACKAGE EMP_ACT_PK AS
	
	PROCEDURE INACTIVE_AN_ACCOUNT(A_ACC_NO ACCOUNT.ACC_NO%TYPE);
    PROCEDURE INSERT_ACC(A_ACC_NO ACCOUNT.ACC_NO%TYPE, 
        A_CUST_ID ACCOUNT.CUST_ID%TYPE, 
        A_ACC_TYPE ACCOUNT.ACC_TYPE%TYPE, 
        A_BALANCE ACCOUNT.BALANCE%TYPE);
    PROCEDURE INSERT_CUST (C_CUST_ID CUSTOMER.CUST_ID%TYPE, 
        C_EMP_ID CUSTOMER.EMP_ID%TYPE, 
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
    PROCEDURE UPDATE_EMP_DETAILS(E_EMP_ID EMPLOYEE.EMP_ID%TYPE, 
        E_EMAIL EMPLOYEE.EMAIL%TYPE, 
        E_MOB_NO EMPLOYEE.MOB_NO%TYPE);
END;
/


CREATE OR REPLACE PACKAGE BODY EMP_ACT_PK AS

PROCEDURE INACTIVE_AN_ACCOUNT(A_ACC_NO IN ACCOUNT.ACC_NO%TYPE) 
AS
BEGIN 	
	UPDATE ACCOUNT
    SET STATUS = 'INACTIVE'
    WHERE ACC_NO = A_ACC_NO;
END INACTIVE_AN_ACCOUNT;
    
---------------------------------------------------
PROCEDURE INSERT_ACC (A_ACC_NO IN ACCOUNT.ACC_NO%TYPE, 
    A_CUST_ID IN ACCOUNT.CUST_ID%TYPE, 
    A_ACC_TYPE IN ACCOUNT.ACC_TYPE%TYPE, 
    A_BALANCE IN ACCOUNT.BALANCE%TYPE) 
IS
COUNT_SAV_ACC NUMBER;
COUNT_CHK_ACC NUMBER;
BEGIN 
    
    SELECT COUNT(*) INTO COUNT_SAV_ACC FROM DB_ADMIN.ACCOUNT WHERE CUST_ID = A_CUST_ID AND A_ACC_TYPE = 'SAVING';
    SELECT COUNT(*) INTO COUNT_CHK_ACC FROM DB_ADMIN.ACCOUNT WHERE CUST_ID = A_CUST_ID AND A_ACC_TYPE = 'CHECKIN';
    
	IF (A_ACC_NO IS NULL OR A_CUST_ID IS NULL OR A_ACC_TYPE IS NULL OR A_STATUS IS NULL OR A_BALANCE IS NULL)
        THEN RAISE NULL_VALUE;
    ELSIF (A_BALANCE <= 1000)
        THEN RAISE MIN_BALANCE;
    ELSIF (COUNT_SAV_ACC = 1)
        THEN RAISE SAV_ACC_EXIST;
    ELSIF (COUNT_CHK_ACC = 1)
        THEN RAISE SAV_CHK_EXIST;
    ELSE
        INSERT INTO ACCOUNT (ACC_NO, CUST_ID, ACC_TYPE, STATUS, BALANCE) 
        VALUES (A_ACC_NO, A_CUST_ID, A_ACC_TYPE, 'ACTIVE', A_BALANCE);
    END IF;
EXCEPTION
    WHEN NULL_VALUE THEN DBMS_OUTPUT.PUT_LINE('PLEASE ENTER ALL FIELDS TO CREATE AN ACCOUNT');
    WHEN MIN_BALANCE THEN DBMS_OUTPUT.PUT_LINE('MINIMUM OF 1000$ SHOULD BE DEPOSITED TO CREATE AN ACCOUNT');
    WHEN SAV_ACC_EXIST THEN DBMS_OUTPUT.PUT_LINE('A SAVING ACCOUNT ALREADY EXIST. CANNOT OPEN TWO SAVING ACCOUNT');
    WHEN SAV_CHK_EXIST THEN DBMS_OUTPUT.PUT_LINE('A CHECKIN ACCOUNT ALREADY EXIST. CANNOT OPEN TWO CHECKIN ACCOUNT');
END INSERT_ACC;

--------------------------------------------------
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
    C_PASSWORD IN CUSTOMER.PASSWORD%TYPE) 
AS
CUST_COUNT NUMBER;
BEGIN 

    SELECT COUNT(*) INTO  FROM CUSTOMER WHERE SSN = C_SSN;
    
    IF (EMP_ID IS NULL OR FNAME IS NULL OR LNAME IS NULL OR STREET IS NULL OR CITY IS NULL OR STATE IS NULL OR ZIPCODE IS NULL OR MOB_NO IS NULL OR EMAIL IS NULL OR GENDER IS NULL OR DATE_OF_BIRTH IS NULL OR NATIONALITY)
        THEN RAISE NULL_VALUE;
    ELSIF (CUST_COUNT = 1)
        THEN RAISE CUST_EXIST;
    ELSE
        INSERT INTO CUSTOMER (CUST_ID, EMP_ID, FNAME, LNAME, STREET, CITY, STATE, ZIPCODE, MOB_NO, EMAIL, GENDER, SSN, DATE_OF_BIRTH, NATIONALITY, USERNAME, PASSWORD) 
	VALUES (CUST_SEQ.NEXTVAL, C_EMP_ID, C_FNAME, C_LNAME, C_STREET, C_CITY, C_STATE, C_ZIPCODE, C_MOB_NO, C_EMAIL, C_GENDER, C_SSN, C_DATE_OF_BIRTH, C_NATIONALITY, C_USERNAME, C_PASSWORD);
    END IF;
	
EXCEPTION
    WHEN CUST_EXIST THEN DBMS_OUTPUT.PUT_LINE('CUSTOMER ALREADY EXISTS');
    WHEN NULL_VALUE THEN DBMS_OUTPUT.PUT_LINE('PLEASE ENTER ALL FIELDS TO CREATE AN CUSTOMER');
    WHEN SAV_ACC_EXIST THEN DBMS_OUTPUT.PUT_LINE('A SAVING ACCOUNT ALREADY EXIST. CANNOT OPEN TWO SAVING ACCOUNT');
    WHEN SAV_CHK_EXIST THEN DBMS_OUTPUT.PUT_LINE('A CHECKIN ACCOUNT ALREADY EXIST. CANNOT OPEN TWO CHECKIN ACCOUNT');
END;

---------------------------------------------
PROCEDURE UPDATE_EMP_DETAILS(E_EMP_ID EMPLOYEE.EMP_ID%TYPE, 
        E_EMAIL EMPLOYEE.EMAIL%TYPE, 
        E_MOB_NO EMPLOYEE.MOB_NO%TYPE) AS
BEGIN
    UPDATE EMPLOYEE
    SET EMAIL = E_EMAIL, MOB_NO = E_MOB_NO
    WHERE EMP_ID = C_EMP_ID;
END UPDATE_EMP_DETAILS;

END EMP_ACT_PK;
/