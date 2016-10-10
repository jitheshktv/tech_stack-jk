--drop objects and ignore exceptions
@@drops.sql

--create objects
WHENEVER SQLERROR EXIT SQL.SQLCODE
@@scripts/audit_user_DDL.sql
