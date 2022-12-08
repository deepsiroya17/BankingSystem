DROP SEQUENCE BRANCH_SEQ;
DROP SEQUENCE EMP_SEQ;
DROP SEQUENCE CUST_SEQ;
DROP SEQUENCE TRANS_SEQ;

BEGIN 
    DECLARE
    MAX_ID INT;
    BEGIN
        SELECT MAX(BRANCH_ID)+1 INTO MAX_ID FROM DB_ADMIN.BRANCH;
        EXECUTE IMMEDIATE('CREATE SEQUENCE BRANCH_SEQ MINVALUE '||MAX_ID||' START WITH '||MAX_ID||' INCREMENT BY 1 NOCACHE NOCYCLE');
    END;
END;
/

BEGIN 
    DECLARE
    MAX_ID INT;
    BEGIN
        SELECT MAX(EMP_ID)+1 INTO MAX_ID FROM DB_ADMIN.EMPLOYEE;
        EXECUTE IMMEDIATE('CREATE SEQUENCE EMP_SEQ MINVALUE '||MAX_ID||' START WITH '||MAX_ID||' INCREMENT BY 1 NOCACHE NOCYCLE');
    END;
END;
/

BEGIN 
    DECLARE
    MAX_ID INT;
    BEGIN
        SELECT MAX(CUST_ID)+1 INTO MAX_ID FROM DB_ADMIN.CUSTOMER;
        EXECUTE IMMEDIATE('CREATE SEQUENCE CUST_SEQ MINVALUE '||MAX_ID||' START WITH '||MAX_ID||' INCREMENT BY 1 NOCACHE NOCYCLE');
    END;
END;
/


BEGIN 
    DECLARE
    MAX_ID INT;
    BEGIN
        SELECT MAX(TRANS_ID)+1 INTO MAX_ID FROM DB_ADMIN.TRANSACTION;
        EXECUTE IMMEDIATE('CREATE SEQUENCE TRANS_SEQ MINVALUE '||MAX_ID||' START WITH '||MAX_ID||' INCREMENT BY 1 NOCACHE NOCYCLE');
    END;
END;
/