SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE CUST_TRANSACTION (
    CT_USERNAME IN CUSTOMER.USERNAME%TYPE, 
    CT_PASSWORD IN CUSTOMER.PASSWORD%TYPE, 
    CT_ACC_NO IN ACCOUNT.ACC_NO%TYPE, 
    CT_RECEIVER_ACC_NO IN ACCOUNT.ACC_NO%TYPE, 
    CT_AMOUNT IN TRANSACTION.AMOUNT%TYPE,
    CT_TRANS_TYPE IN TRANSACTION.TRANS_TYPE%TYPE
)
IS
UNAME VARCHAR(50);
PASS VARCHAR(50);
COUNT_SEND_ACC INT;
COUNT_REC_ACC INT;
S_ACC_NO INT;
R_ACC_NO INT;
SENDER_BAL FLOAT;
INV_USER EXCEPTION;
INV_TRANS EXCEPTION;
INV_ACC EXCEPTION;
INV_AMT EXCEPTION;
BEGIN

    SELECT C.USERNAME INTO UNAME FROM DB_ADMIN.CUSTOMER C 
    JOIN DB_ADMIN.ACCOUNT A ON A.CUST_ID = C.CUST_ID 
    WHERE A.ACC_NO = CT_ACC_NO;
    
    SELECT C.PASSWORD INTO PASS FROM DB_ADMIN.CUSTOMER C 
    JOIN DB_ADMIN.ACCOUNT A ON A.CUST_ID = C.CUST_ID 
    WHERE A.ACC_NO = CT_ACC_NO;
    
    SELECT COUNT(*) INTO COUNT_REC_ACC FROM DB_ADMIN.ACCOUNT 
    WHERE ACC_NO = CT_RECEIVER_ACC_NO AND STATUS = 'ACTIVE';
    
    SELECT COUNT(*) INTO COUNT_SEND_ACC FROM DB_ADMIN.ACCOUNT 
    WHERE ACC_NO = CT_ACC_NO AND STATUS = 'ACTIVE';
    
    SELECT BALANCE INTO SENDER_BAL FROM DB_ADMIN.ACCOUNT 
    WHERE ACC_NO = CT_ACC_NO;
    
    IF CT_USERNAME <> UNAME AND CT_PASSWORD <>PASS
        THEN RAISE INV_USER;
    ELSE 
        IF CT_ACC_NO = CT_RECEIVER_ACC_NO
            THEN RAISE INV_TRANS;
        ELSE 
            IF COUNT_REC_ACC < 1 
                THEN RAISE INV_ACC;
            ELSE 
                IF SENDER_BAL - CT_AMOUNT < 500
                    THEN RAISE INV_AMT;
                ELSE
                    UPDATE ACCOUNT
                    SET BALANCE = BALANCE - CT_AMOUNT
                    WHERE ACC_NO = CT_ACC_NO;
                    
                    UPDATE ACCOUNT
                    SET BALANCE = BALANCE + CT_AMOUNT
                    WHERE ACC_NO = CT_RECEIVER_ACC_NO;
                    
                    INSERT INTO TRANSACTION VALUES (TRANS_SEQ.NEXTVAL, CT_ACC_NO, CT_RECEIVER_ACC_NO, CT_TRANS_TYPE, SYSDATE, CT_AMOUNT, 'DEBIT');
                    INSERT INTO TRANSACTION VALUES (TRANS_SEQ.NEXTVAL, CT_RECEIVER_ACC_NO, CT_ACC_NO, CT_TRANS_TYPE, SYSDATE, CT_AMOUNT, 'CREDIT');
                    
                    
                END IF;
            END IF;
        END IF;
    END IF;
    
    EXCEPTION 
        WHEN INV_USER THEN DBMS_OUTPUT.PUT_LINE('INVALID USERNAME AND PASSWORD');
        WHEN INV_TRANS THEN DBMS_OUTPUT.PUT_LINE('SENDER AND RECEIVER ACCOUNTS CANNOT BE SAME');
        WHEN INV_ACC THEN DBMS_OUTPUT.PUT_LINE('RECEIVERS ACCOUNT DOES NOT EXIST');
        WHEN INV_AMT THEN DBMS_OUTPUT.PUT_LINE('BALANCE IS NOT SUFFICIENT TO MAKE A TRANSACTION');
        

END CUST_TRANSACTION;
/


--BEGIN
--    CUST_TRANSACTION('AK','PASSWORD123', 213421, 231872, 200, 'DD');
--END;
--
--BEGIN
--    CUST_TRANSACTION('AK','PASSWORD123', 213421, 231821, 300, 'ZELLE');
--END;
--
--COMMIT;
--
--SELECT * FROM DB_ADMIN.TRANSACTION;