--############################################################################
--  Domain 정보 테이블 생성 스크립트
--############################################################################
--/**************************************************************************************
-- Drop Table
--**************************************************************************************/
SET SCHEMA = 'KSIGN';

DROP TABLE DOMAIN_AUDIT;
DROP TABLE DOMAIN_SESSION;
DROP TABLE DOMAIN_SQL;
DROP TABLE DOMAIN_CONF;
DROP TABLE DOMAIN_ENCJOB;
DROP TABLE DOMAIN_OBJ;
DROP TABLE DOMAIN_ENCOBJ;
DROP TABLE DOMAIN_IDX;
DROP TABLE DOMAIN_DENIED_SQL;
DROP TABLE DOMAIN_ENC_COLS;
--/**************************************************************************************
-- Drop Sequence
--**************************************************************************************/
DROP SEQUENCE DAUDIT_SEQ;
DROP SEQUENCE AGENT_SEQ;
DROP SEQUENCE JOB_SEQ;
DROP SEQUENCE SQL_SEQ;
--/**************************************************************************************
--  감사기록(이벤트) 테이블 : select, insert, update, delete
--**************************************************************************************/
CREATE TABLE DOMAIN_AUDIT
(
        DAUDIT_SEQ              INTEGER         NOT NULL,
        AUDIT_DATE              VARCHAR(10)     NOT NULL,
        AUDIT_HMS               VARCHAR(15)     NOT NULL,
        OBJ_TYPE                VARCHAR(20),
        OBJ_NAME                VARCHAR(50),
        OPERATION               VARCHAR(15),
        RESULT                  CHAR(1)                 NOT NULL,
        REASON                  VARCHAR(200),
        SESSION_NO              VARCHAR(35),
        SQL_NO                  VARCHAR(12),
        MACINF                  VARCHAR(50)
);
ALTER TABLE DOMAIN_AUDIT ADD CONSTRAINT PKDOMAUDIT PRIMARY KEY (DAUDIT_SEQ);
CREATE INDEX IXDOMDAUDIT01 ON DOMAIN_AUDIT(OBJ_TYPE);
CREATE INDEX IXDOMDAUDIT02 ON DOMAIN_AUDIT(OPERATION);
CREATE INDEX IXDOMDAUDIT03 ON DOMAIN_AUDIT(AUDIT_DATE);
--/**************************************************************************************
--  감사기록(세션정보) 테이블
--**************************************************************************************/
CREATE TABLE DOMAIN_SESSION
(
        SESSION_NO              VARCHAR(35)     NOT NULL,
        USERID                  VARCHAR(30)     NOT NULL,
        ACCESSIP                VARCHAR(15),
        APPID                   VARCHAR(30),
        TERMINAL                        VARCHAR(30),
        MACHINE                 VARCHAR(64),
        OSUSER                  VARCHAR(30),
        PROGRAM         VARCHAR(64),
        LOGON_TIME              VARCHAR(25),
        LOGOFF_TIME             VARCHAR(25),
        MACINF                  VARCHAR(50)
);
ALTER TABLE DOMAIN_SESSION ADD CONSTRAINT PKDOMSESSION PRIMARY KEY (SESSION_NO);
CREATE INDEX IXDOMSESSION01 ON DOMAIN_SESSION(USERID);
CREATE INDEX IXDOMSESSION02 ON DOMAIN_SESSION(ACCESSIP);
--/**************************************************************************************
--  감사기록 (SQL문) 테이블
--**************************************************************************************/
CREATE TABLE DOMAIN_SQL
(
        SQL_NO                  VARCHAR(12)     NOT NULL,
        SQL_TEXT                CLOB,
        MACINF                  VARCHAR(50),
        REF_IP                  VARCHAR(50),
        REF_ID                  VARCHAR(20),
        REF_NAME                VARCHAR(20)
);
ALTER TABLE DOMAIN_SQL ADD CONSTRAINT PKDOMSQL PRIMARY KEY (SQL_NO);
--/**************************************************************************************
--  감사기록 (SQL문) 테이블
--**************************************************************************************/
CREATE TABLE DOMAIN_CONF (
        SERVER_IP                               VARCHAR(20),
        SERVER_PORT                             INTEGER,
        SERVER_IP2                              VARCHAR(20),
        SERVER_PORT2                    INTEGER,
        SERVER_CONN_TIMEOUT             INTEGER,
        AUDIT_OP                                CHAR(16),
        POLICY_INITTIME                 DATE,
        POLICY_READ_TIME                        INTEGER,
        LOG_LEVEL                               INTEGER,
        AGENT_SEQ                               INTEGER,
        AGENT_HOMEDIR                   VARCHAR(100),
        AGENT_MODE                              CHAR(1),
        AGENT_PORT                              VARCHAR(5),
        AGENT_KEY                               VARCHAR(100),
        ADTB_PATH                               VARCHAR(200),
        ADTB_TYPE                               VARCHAR(1),
        ADTB_METHOD                     VARCHAR(13),
        ADTB_LASTDATE                   VARCHAR(10),
        ADTB_STORAGE                    CHAR(1),
        ADT_THRESHOLD_ENABLED           VARCHAR(1)              DEFAULT 'F',
        ADT_THRESHOLD                   INTEGER                 DEFAULT 80,
        ADT_KEEP_FILE                   VARCHAR(1)              DEFAULT 'T',
        ALARM_ADT_THRESHOLD             VARCHAR(1)              DEFAULT 'F',
        ALARM_VERI_POLICY               VARCHAR(1)              DEFAULT 'F',
        ALARM_SMTP_SERVER               VARCHAR(50),
        ALARM_SENDER_MAIL               VARCHAR(50),
        ALARM_SENDER_PASSWORD   VARCHAR(50),
        ALARM_RECEIVER_LIST             VARCHAR(250),
        ACCESS_PRIORITY                 CHAR(1)                 DEFAULT 'T',
        MACINF                                  VARCHAR(50),
        MASK_VALUE                              VARCHAR(200)
);
--/**************************************************************************************
--  5. 암호화 진행률 정보 테이블
--**************************************************************************************/
CREATE TABLE DOMAIN_ENCJOB
(
        JOB_SEQ                                 INTEGER         NOT NULL,
        ADMIN_ID                                        VARCHAR(30)     NOT NULL,
        TABLE_OWNER                             VARCHAR(50)     NOT NULL,
        TABLE_NAME                              VARCHAR(50)     NOT NULL,
        ENC_TYPE                                VARCHAR(10)     NOT NULL,
        ENC_STATUS                              VARCHAR(10)     NOT NULL,
        ENC_PROGRESS                    INTEGER,
        ENC_STARTTIME                   TIMESTAMP                       NOT NULL,
        ENC_ENDTIME                             TIMESTAMP,
        ERR_MESSAGE                     VARCHAR(500)
);
ALTER TABLE DOMAIN_ENCJOB ADD CONSTRAINT PKDOMENCJOB PRIMARY KEY (JOB_SEQ);
--/**************************************************************************************
--   Object 정보 테이블
--**************************************************************************************/
CREATE TABLE DOMAIN_OBJ
(
        OBJ_INFO                                VARCHAR(1000)   NOT NULL,
        OBJ_TYPE                                VARCHAR(2)              NOT NULL,
        MACINF                                  VARCHAR(50)
);
ALTER TABLE DOMAIN_OBJ ADD UNIQUE (OBJ_INFO, OBJ_TYPE);
CREATE INDEX IXDOMOBJ01 ON DOMAIN_OBJ(OBJ_TYPE);
--/**************************************************************************************
--  7. 암호화 테이블 관련 OBJECT NAME 테이블
--**************************************************************************************/
CREATE TABLE DOMAIN_ENCOBJ
(
  TAB_OWNER                                     VARCHAR(30)     NOT NULL,
  TAB_NAME                                      VARCHAR(30)     NOT NULL,
  ENC_TAB_NAME                          VARCHAR(30),
  ENC_TRG_NAME                          VARCHAR(30),
  ACC_TRG_NAME                          VARCHAR(30),
  POL_FUNC_NAME                         VARCHAR(30),
  BACK_TAB_NAME                         VARCHAR(30)
);
ALTER TABLE DOMAIN_ENCOBJ ADD CONSTRAINT PKDOMENCOBJ PRIMARY KEY (TAB_OWNER, TAB_NAME);
--/**************************************************************************************
--  8. 도메인 인덱스 생성시 필요한 정보를 담고 있는 테이블
--**************************************************************************************/
CREATE TABLE DOMAIN_IDX
(
  TAB_OWNER                                     VARCHAR(30)     NOT NULL,
  TAB_NAME                                      VARCHAR(30)     NOT NULL,
  COL_NAME                                      VARCHAR(30)     NOT NULL,
  SEGMENTS                                      VARCHAR(400)
);
ALTER TABLE DOMAIN_IDX ADD CONSTRAINT PKDOMIDX PRIMARY KEY (TAB_OWNER, TAB_NAME, COL_NAME);
--/**************************************************************************************
--  9. 차단 SQL 정보를 담고 있는 테이블
--**************************************************************************************/
CREATE TABLE DOMAIN_DENIED_SQL
(
        SQL_SEQ                                 INTEGER,
        TABLE_NAME                              VARCHAR(61)             NOT NULL ,
        SQLSTMT                                 VARCHAR(900)    NOT NULL ,
        MACINF                                  VARCHAR(50)
);
ALTER TABLE DOMAIN_DENIED_SQL ADD UNIQUE (TABLE_NAME, SQLSTMT);
--/**************************************************************************************
--  10. 접근제어를 위한 암호화 컬럼 정보를 담고 있는 테이블
--**************************************************************************************/
CREATE TABLE DOMAIN_ENC_COLS
(
  OWNER                                         VARCHAR(30)             NOT NULL,
  TABLE_NAME                            VARCHAR(30)             NOT NULL,
  COLUMN_NAME                           VARCHAR(30)             NOT NULL,
  DATA_TYPE                                     VARCHAR(106)    NOT NULL,
  DATA_LENGTH                           INTEGER                 NOT NULL,
  DATA_PRECISION                        INTEGER,
  DATA_SCALE                            INTEGER,
  NULLABLE                                      VARCHAR(1),
  COLUMN_ID                                     INTEGER,
  DEFAULT_LENGTH                        INTEGER,
  DATA_DEFAULT                          VARCHAR(1000),
  COMMENTS                                      VARCHAR(1000)
);
ALTER TABLE DOMAIN_ENC_COLS ADD UNIQUE (OWNER, TABLE_NAME, COLUMN_NAME);

--/**************************************************************************************
-- Create Sequence
--**************************************************************************************/
--DOMAIN_AUDIT
CREATE SEQUENCE DAUDIT_SEQ AS INTEGER    START WITH 1    INCREMENT BY 1
    MAXVALUE 2147483647    MINVALUE 1    NO CYCLE    CACHE 20    NO ORDER;
--DOMAIN_CONF
CREATE SEQUENCE AGENT_SEQ AS INTEGER    START WITH 1    INCREMENT BY 1
    MAXVALUE 2147483647    MINVALUE 1    NO CYCLE    CACHE 20    NO ORDER;
--DOMAIN_ENCJOB
CREATE SEQUENCE JOB_SEQ AS INTEGER    START WITH 1    INCREMENT BY 1
    MAXVALUE 2147483647    MINVALUE 1    NO CYCLE    CACHE 20    NO ORDER;
--DOMAIN_DENIED_SQL
CREATE SEQUENCE SQL_SEQ AS INTEGER    START WITH 1    INCREMENT BY 1
    MAXVALUE 2147483647    MINVALUE 1    NO CYCLE    CACHE 20    NO ORDER;

COMMIT;
--EXIT;
