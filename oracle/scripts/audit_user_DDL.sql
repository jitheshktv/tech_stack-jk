CREATE PROFILE "SECURITY_PROFILE_FUNCTIONAL" LIMIT CPU_PER_SESSION DEFAULT
CPU_PER_CALL DEFAULT
CONNECT_TIME DEFAULT
IDLE_TIME DEFAULT
SESSIONS_PER_USER DEFAULT
LOGICAL_READS_PER_SESSION DEFAULT
LOGICAL_READS_PER_CALL DEFAULT
PRIVATE_SGA DEFAULT
COMPOSITE_LIMIT DEFAULT
PASSWORD_LIFE_TIME UNLIMITED
PASSWORD_GRACE_TIME 0
PASSWORD_REUSE_MAX 6
PASSWORD_REUSE_TIME UNLIMITED
PASSWORD_LOCK_TIME UNLIMITED
FAILED_LOGIN_ATTEMPTS UNLIMITED
PASSWORD_VERIFY_FUNCTION VERIFY_FUNCTION;

CREATE ROLE "CITI_CONNECT" NOT IDENTIFIED;
GRANT ALTER SESSION TO "CITI_CONNECT";
GRANT CREATE SESSION TO "CITI_CONNECT";

CREATE ROLE "CITI_SCHEMA" NOT IDENTIFIED;
GRANT ALTER SESSION TO "CITI_SCHEMA";
GRANT CREATE CLUSTER TO "CITI_SCHEMA";
GRANT CREATE DATABASE LINK TO "CITI_SCHEMA";
GRANT CREATE INDEXTYPE TO "CITI_SCHEMA";
GRANT CREATE OPERATOR TO "CITI_SCHEMA";
GRANT CREATE PROCEDURE TO "CITI_SCHEMA";
GRANT CREATE SEQUENCE TO "CITI_SCHEMA";
GRANT CREATE SESSION TO "CITI_SCHEMA";
GRANT CREATE SYNONYM TO "CITI_SCHEMA";
GRANT CREATE TABLE TO "CITI_SCHEMA";
GRANT CREATE TRIGGER TO "CITI_SCHEMA";
GRANT CREATE TYPE TO "CITI_SCHEMA";
GRANT CREATE VIEW TO "CITI_SCHEMA";

create tablespace DBASPACE datafile size 2G;

CREATE USER AUDIT_USER PROFILE SECURITY_PROFILE_FUNCTIONAL
IDENTIFIED BY "Welcome1!"
DEFAULT TABLESPACE DBASPACE
QUOTA UNLIMITED ON DBASPACE
TEMPORARY TABLESPACE TEMP
ACCOUNT UNLOCK;

-- grant permission to Audit_user

--GRANT ALTER SYSTEM TO AUDIT_USER; --NOT ALLOWED ON RDS
GRANT "CITI_SCHEMA" TO AUDIT_USER ;
GRANT "CITI_CONNECT" TO AUDIT_USER ;
ALTER USER AUDIT_USER DEFAULT ROLE "CITI_SCHEMA","CITI_CONNECT";

create role IT_CHANGEMAN_UPDATE not identified ;

----Tables creation

 CREATE TABLE "AUDIT_USER"."CITI_BACKUPLOG"
   (    "HOSTNAME" VARCHAR2(15),
        "DBNAME" VARCHAR2(15),
        "BACKUP_DATE" DATE,
        "BACKUP_LEVEL" NUMBER,
        "BACKUP_SUCCESS" VARCHAR2(1) DEFAULT 'N',
        "OFFSITE" VARCHAR2(1) DEFAULT 'N'
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 8388608 NEXT 52428800 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DBASPACE";

---

CREATE TABLE "AUDIT_USER"."CITI_CUSTOM_EVENT_STATUS"
   (    "EVENT_NAME" VARCHAR2(60) NOT NULL ENABLE,
        "EVENT_STATUS" VARCHAR2(25),
        "EVENT_MESSAGE" VARCHAR2(4000),
         CONSTRAINT "CITI_CUSTOM_EVENT_STATUS_PK" PRIMARY KEY ("EVENT_NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 52428800 NEXT 52428800 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DBASPACE"  ENABLE   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 8388608 NEXT 52428800 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DBASPACE";

CREATE TABLE "AUDIT_USER"."CITI_LOGHISTORY"
   (    "RECID" NUMBER,
        "STAMP" NUMBER,
        "THREAD#" NUMBER,
        "SEQUENCE#" NUMBER,
        "FIRST_CHANGE#" NUMBER,
        "FIRST_TIME" DATE,
        "NEXT_CHANGE#" NUMBER,
        "RESETLOGS_CHANGE#" NUMBER,
        "RESET_LOGS_TIME" DATE
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 8388608 NEXT 52428800 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DBASPACE";

CREATE INDEX AUDIT_USER.CITI_LOGHISTORY_IDX ON AUDIT_USER.CITI_LOGHISTORY
(FIRST_TIME)
LOGGING
TABLESPACE DBASPACE
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;
---

CREATE TABLE "AUDIT_USER"."IT_CHANGEMAN"
   (    "OBJECT_OWNER" VARCHAR2(30) NOT NULL ENABLE,
        "CHANGE_NBR" VARCHAR2(30) NOT NULL ENABLE,
        "CR_TR" VARCHAR2(20),
        "SCRIPT_NO" NUMBER(4,0),
        "CHANGE_DATE" DATE,
        "CHANGE_BY" VARCHAR2(30),
         CONSTRAINT "IT_CHANGEMAN_PK" PRIMARY KEY ("OBJECT_OWNER", "CHANGE_NBR", "SCRIPT_NO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DBASPACE"  ENABLE
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DBASPACE";

GRANT DELETE, INSERT, SELECT, UPDATE ON AUDIT_USER.IT_CHANGEMAN TO IT_CHANGEMAN_UPDATE;
-----

CREATE TABLE "AUDIT_USER"."IT_CHANGEMAN_EVENT"
   (    "OBJECT_OWNER" VARCHAR2(30) NOT NULL ENABLE,
        "OBJECT_TYPE" VARCHAR2(30) NOT NULL ENABLE,
        "TARGET_TYPE" VARCHAR2(30) NOT NULL ENABLE,
        "TARGET_OWNER" VARCHAR2(30) NOT NULL ENABLE,
        "TARGET_PRIVILEGE" VARCHAR2(100)
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 8388608 NEXT 52428800 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DBASPACE";

CREATE UNIQUE INDEX AUDIT_USER.IT_CHANGEMAN_EVENT_UDX1 ON AUDIT_USER.IT_CHANGEMAN_EVENT
(OBJECT_OWNER, OBJECT_TYPE, TARGET_TYPE, TARGET_OWNER, TARGET_PRIVILEGE)
LOGGING
TABLESPACE DBASPACE
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;
--

CREATE TABLE "AUDIT_USER"."IT_CHANGEMAN_OBJHIST"
   (    "CHANGE_DATE" DATE,
        "OBJECT_OWNER" VARCHAR2(30),
        "OBJECT_NAME" VARCHAR2(80),
        "OBJECT_TYPE" VARCHAR2(30),
        "OBJECT_ACTION" VARCHAR2(15),
        "EVENT_DATE" DATE,
        "CHANGE_NBR" VARCHAR2(30),
        "SCRIPT_NO" NUMBER(4,0)
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 8388608 NEXT 52428800 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DBASPACE";

CREATE INDEX AUDIT_USER.IT_CHANGEMAN_OBJHIST_IDX1 ON AUDIT_USER.IT_CHANGEMAN_OBJHIST
(CHANGE_DATE, OBJECT_OWNER, OBJECT_NAME)
LOGGING
TABLESPACE DBASPACE
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

CREATE INDEX AUDIT_USER.IT_CHANGEMAN_OBJHIST_IDX2 ON AUDIT_USER.IT_CHANGEMAN_OBJHIST
(EVENT_DATE)
LOGGING
TABLESPACE DBASPACE
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          5M
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


GRANT DELETE, INSERT, SELECT, UPDATE ON AUDIT_USER.IT_CHANGEMAN_OBJHIST TO IT_CHANGEMAN_UPDATE;
---

  CREATE TABLE "AUDIT_USER"."IT_CHANGEMAN_SOURCEHIST"
   (    "CHANGE_DATE" DATE,
        "OBJECT_OWNER" VARCHAR2(30),
        "OBJECT_NAME" VARCHAR2(30),
        "OBJECT_TYPE" VARCHAR2(12),
        "LINENBR" NUMBER,
        "TEXT" VARCHAR2(4000),
        "CHANGE_NBR" VARCHAR2(30),
        "SCRIPT_NO" NUMBER(4,0)
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DBASPACE";

CREATE INDEX "AUDIT_USER"."IT_CHANGEMAN_SOURCEHIST_IDX1" ON "AUDIT_USER"."IT_CHANGEMAN_SOURCEHIST" ("CHANGE_DATE", "OBJECT_OWNER", "OBJECT_NAME")
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DBASPACE";

GRANT DELETE, INSERT, SELECT, UPDATE ON AUDIT_USER.IT_CHANGEMAN_SOURCEHIST TO IT_CHANGEMAN_UPDATE;
----

CREATE TABLE "AUDIT_USER"."PWORD_COMMON"
   (    "COMMON_WORD" VARCHAR2(30)
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 8388608 NEXT 52428800 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DBASPACE";

--- Procedure creation

CREATE OR REPLACE PROCEDURE AUDIT_USER.citi_ddl_proc
AS
   v_sql            VARCHAR2 (4000);
   v_object_owner   VARCHAR2 (30);
   v_object_type    VARCHAR2 (30);
   v_objcnt         NUMBER;

   CURSOR cur_obj
   IS
      SELECT change_date, object_owner, object_name, object_type, object_action
        FROM it_changeman_objhist
       WHERE event_date IS NULL;

   CURSOR cur_event
   IS
      SELECT target_type, target_owner, target_privilege
        FROM audit_user.it_changeman_event
       WHERE object_owner = v_object_owner AND object_type = v_object_type;
BEGIN
   FOR rec_obj IN cur_obj
   LOOP
      v_object_owner := rec_obj.object_owner;
      v_object_type := rec_obj.object_type;

      IF rec_obj.object_action = 'CREATE'
      THEN
         FOR rec_event IN cur_event
         LOOP
            IF rec_event.target_type = 'GRANT'
            THEN
               DBMS_OUTPUT.put_line (   'Grant '
                                     || rec_event.target_privilege
                                     || ' on '
                                     || rec_obj.object_owner
                                     || '.'
                                     || rec_obj.object_name
                                     || ' to '
                                     || rec_event.target_owner
                                    );
               v_sql :=
                     'grant '
                  || rec_event.target_privilege
                  || ' on '
                  || rec_obj.object_owner
                  || '.'
                  || rec_obj.object_name
                  || ' to '
                  || rec_event.target_owner;

               EXECUTE IMMEDIATE v_sql;
            END IF;

            IF rec_event.target_type = 'SYNONYM'
            THEN
               SELECT COUNT (1)
                 INTO v_objcnt
                 FROM dba_synonyms
                WHERE owner = rec_event.target_owner
                  AND synonym_name = rec_obj.object_name;

               IF v_objcnt = 0
               THEN
                  IF rec_event.target_owner = 'PUBLIC'
                  THEN
                     DBMS_OUTPUT.put_line (   'Creating Pulic Synonym for '
                                           || rec_obj.object_owner
                                           || '.'
                                           || rec_obj.object_name
                                          );
                     v_sql :=
                           'create public synonym '
                        || rec_obj.object_name
                        || ' for '
                        || rec_obj.object_owner
                        || '.'
                        || rec_obj.object_name;
                  ELSE
                     DBMS_OUTPUT.put_line (   'Creating Synonym under '
                                           || rec_event.target_owner
                                           || ' for '
                                           || rec_obj.object_owner
                                           || '.'
                                           || rec_obj.object_name
                                          );
                     v_sql :=
                           'create synonym '
                        || rec_event.target_owner
                        || '.'
                        || rec_obj.object_name
                        || ' for '
                        || rec_obj.object_owner
                        || '.'
                        || rec_obj.object_name;
                  END IF;

                  EXECUTE IMMEDIATE v_sql;
               ELSE
                  DBMS_OUTPUT.put_line (   'ERROR:  Cannot create '
                                        || rec_event.target_owner
                                        || ' synonym for '
                                        || rec_obj.object_owner
                                        || '.'
                                        || rec_obj.object_name
                                       );
               END IF;
            END IF;
         END LOOP;
      END IF;
      update audit_user.it_changeman_objhist set event_date=sysdate
      where object_owner=rec_obj.object_owner
            and object_name=rec_obj.object_name
            and object_type=rec_obj.object_type
            and object_action=rec_obj.object_action
            and change_date=rec_obj.change_date
            and event_date is null;
      commit;
    END LOOP;
END;
/
CREATE OR REPLACE PROCEDURE AUDIT_USER.it_changeman_sourcehist_proc
   ( p_object_owner IN varchar2,
     p_object_name in varchar2,
     p_object_type in varchar2)
   IS
--
-- Purpose: Briefly explain the functionality of the procedure
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  -------------------------------------------
   sql_text         ora_name_list_t;
   stmt             VARCHAR2 (2000);
   n                NUMBER;
   changedt         DATE;

BEGIN
    changedt := sysdate;
   --
   -- Version Control
   --
   IF UPPER (p_object_owner) NOT IN ('SYS', 'SYSTEM', 'PERFSTAT')
      and UPPER(sys.dictionary_obj_name) not like 'IT_CHANGEMAN%'
   THEN
   		IF p_object_type IN
            ('TRIGGER',
             'PROCEDURE',
             'FUNCTION',
             'PACKAGE',
             'PACKAGE BODY',
             'TYPE'
            )
      THEN
         -- Stores old code in SOURCE_HIST table
         INSERT INTO audit_user.it_changeman_sourcehist
                     (change_date, object_name, object_type, linenbr, text)
            (SELECT SYSDATE, NAME, TYPE, line, text
               FROM dba_source
              WHERE OWNER = p_object_owner AND TYPE = p_object_type AND NAME = p_object_name);
      END IF;

      IF p_object_type IN ('TABLE', 'INDEX', 'SEQUENCE')
      THEN
         n := ora_sql_txt (sql_text);

         FOR i IN 1 .. n
         LOOP
            INSERT INTO audit_user.it_changeman_sourcehist
                        (change_date, object_name, object_type, linenbr,
                         text
                        )
                 VALUES (changedt, p_object_name, p_object_type, i,
                         sql_text (i)
                        );
         END LOOP;
      END IF;

      insert into audit_user.it_changeman_objhist(change_date,object_owner,object_name,object_type,object_action)
      values (changedt,p_object_owner,p_object_name,p_object_type,'CREATE');
   END IF;
END;
/
