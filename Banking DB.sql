-- CREATING 3 DIFFERENT ROLES TO MANAGE OUR SYSTEM
CREATE USER DB_ADMIN IDENTIFIED BY "Dmdd99@dbadmin";
CREATE USER DB_OPERATOR IDENTIFIED BY "Dmdd99@operator";

-- GRANTING PERMISSION TO CREATE TABLES, PACKAGES, ETC.
GRANT CONNECT, RESOURCE TO DB_ADMIN;
GRANT CREATE SESSION TO DB_ADMIN;
GRANT UNLIMITED TABLESPACE TO DB_ADMIN;
GRANT CREATE VIEW TO DB_ADMIN;

-- GRANTING CONNECT AND ALOTTING TABEL SPACE
GRANT CONNECT TO DB_OPERATOR;
ALTER USER DB_OPERATOR QUOTA 10G ON DATA;




