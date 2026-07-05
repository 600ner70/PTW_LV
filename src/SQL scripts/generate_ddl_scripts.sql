-- ============================================================
-- Generate per-object DDL extraction scripts for PTW_PRO
--
-- HOW THIS WORKS
-- SQL*Plus/SQLcl can't change a SPOOL target dynamically inside
-- a single SELECT - so this script doesn't extract DDL directly.
-- Instead, it exitGENERATES a second script ("run_ddl_export.sql")
-- containing one SPOOL <file> / SELECT ... / SPOOL OFF block per
-- database object. You then run that generated script, and it
-- produces one .sql file per object, named to match this repo's
-- existing src/ folder structure.
--
-- USAGE
--   1. cd into src/  (so relative paths below land in the right
--      subfolders - create them first if they don't exist:
--      mkdir -p tables views functions procedures packages
--                triggers sequences indexes policies synonyms)
--   2. sqlplus ptw_pro/*** @generate_ddl_scripts.sql
--        (or the sqlcl equivalent - same syntax works)
--   3. @run_ddl_export.sql
--   4. git add src/tables src/views src/functions ... etc.
-- ============================================================

SET LONG 1000000
SET LONGCHUNKSIZE 1000000
SET PAGESIZE 0
SET LINESIZE 32767
SET FEEDBACK OFF
SET ECHO OFF
SET VERIFY OFF
SET TRIMSPOOL ON
SET TERMOUT OFF

BEGIN
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', TRUE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'PRETTY', TRUE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES', FALSE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', FALSE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE', FALSE);
END;
/

SPOOL run_ddl_export.sql

PROMPT SET LONG 1000000
PROMPT SET LONGCHUNKSIZE 1000000
PROMPT SET PAGESIZE 0
PROMPT SET LINESIZE 32767
PROMPT SET FEEDBACK OFF
PROMPT SET ECHO OFF
PROMPT SET VERIFY OFF
PROMPT SET TRIMSPOOL ON
PROMPT SET TERMOUT OFF
PROMPT

-- ===== TABLES =====
SELECT 'PROMPT Exporting table ' || table_name || CHR(10) ||
       'SPOOL tables/' || LOWER(table_name) || '.sql' || CHR(10) ||
       'SELECT DBMS_METADATA.GET_DDL(''TABLE'', ''' || table_name || ''', ''PTW_PRO'') FROM DUAL;' || CHR(10) ||
       'SPOOL OFF' || CHR(10)
FROM   dba_tables
WHERE  owner = 'PTW_PRO'
ORDER  BY table_name;

-- ===== TABLE CONSTRAINTS (appended to same table file, not a separate object) =====
SELECT 'PROMPT Exporting constraints for ' || table_name || CHR(10) ||
       'SPOOL tables/' || LOWER(table_name) || '.sql APPEND' || CHR(10) ||
       'BEGIN' || CHR(10) ||
       '    DBMS_OUTPUT.PUT_LINE(NVL(DBMS_METADATA.GET_DEPENDENT_DDL(''CONSTRAINT'', ''' || table_name || ''', ''PTW_PRO''), ''''));' || CHR(10) ||
       'EXCEPTION WHEN OTHERS THEN' || CHR(10) ||
       '    IF SQLCODE NOT IN (-31603, -31608) THEN RAISE; END IF;' || CHR(10) ||
       'END;' || CHR(10) ||
       '/' || CHR(10) ||
       'SPOOL OFF' || CHR(10)
FROM   dba_tables
WHERE  owner = 'PTW_PRO'
ORDER  BY table_name;

PROMPT SET SERVEROUTPUT ON

-- ===== INDEXES (non-constraint-backed only) =====
SELECT 'PROMPT Exporting index ' || index_name || CHR(10) ||
       'SPOOL indexes/' || LOWER(index_name) || '.sql' || CHR(10) ||
       'SELECT DBMS_METADATA.GET_DDL(''INDEX'', ''' || index_name || ''', ''PTW_PRO'') FROM DUAL;' || CHR(10) ||
       'SPOOL OFF' || CHR(10)
FROM   dba_indexes
WHERE  owner = 'PTW_PRO'
AND    index_name NOT IN (
         SELECT index_name FROM dba_constraints
         WHERE owner = 'PTW_PRO' AND index_name IS NOT NULL
       )
ORDER  BY index_name;

-- ===== SEQUENCES =====
SELECT 'PROMPT Exporting sequence ' || sequence_name || CHR(10) ||
       'SPOOL sequences/' || LOWER(sequence_name) || '.sql' || CHR(10) ||
       'SELECT DBMS_METADATA.GET_DDL(''SEQUENCE'', ''' || sequence_name || ''', ''PTW_PRO'') FROM DUAL;' || CHR(10) ||
       'SPOOL OFF' || CHR(10)
FROM   dba_sequences
WHERE  sequence_owner = 'PTW_PRO'
AND    sequence_name NOT LIKE 'ISEQ$$%'
ORDER  BY sequence_name;

-- ===== VIEWS =====
SELECT 'PROMPT Exporting view ' || view_name || CHR(10) ||
       'SPOOL views/' || LOWER(view_name) || '.sql' || CHR(10) ||
       'SELECT DBMS_METADATA.GET_DDL(''VIEW'', ''' || view_name || ''', ''PTW_PRO'') FROM DUAL;' || CHR(10) ||
       'SPOOL OFF' || CHR(10)
FROM   dba_views
WHERE  owner = 'PTW_PRO'
ORDER  BY view_name;

-- ===== TRIGGERS =====
SELECT 'PROMPT Exporting trigger ' || trigger_name || CHR(10) ||
       'SPOOL triggers/' || LOWER(trigger_name) || '.sql' || CHR(10) ||
       'SELECT DBMS_METADATA.GET_DDL(''TRIGGER'', ''' || trigger_name || ''', ''PTW_PRO'') FROM DUAL;' || CHR(10) ||
       'SPOOL OFF' || CHR(10)
FROM   dba_triggers
WHERE  owner = 'PTW_PRO'
ORDER  BY trigger_name;

-- ===== PROCEDURES (standalone only - not package members) =====
SELECT 'PROMPT Exporting procedure ' || object_name || CHR(10) ||
       'SPOOL procedures/' || LOWER(object_name) || '.sql' || CHR(10) ||
       'SELECT DBMS_METADATA.GET_DDL(''PROCEDURE'', ''' || object_name || ''', ''PTW_PRO'') FROM DUAL;' || CHR(10) ||
       'SPOOL OFF' || CHR(10)
FROM   dba_procedures
WHERE  owner = 'PTW_PRO'
AND    object_type = 'PROCEDURE'
ORDER  BY object_name;

-- ===== FUNCTIONS (standalone only - not package members) =====
-- Note: this repo already keeps these under src/functions/ individually
-- (e.g. generate_ptw_lv_pdf.sql) - this will just regenerate matching files.
SELECT 'PROMPT Exporting function ' || object_name || CHR(10) ||
       'SPOOL functions/' || LOWER(object_name) || '.sql' || CHR(10) ||
       'SELECT DBMS_METADATA.GET_DDL(''FUNCTION'', ''' || object_name || ''', ''PTW_PRO'') FROM DUAL;' || CHR(10) ||
       'SPOOL OFF' || CHR(10)
FROM   dba_procedures
WHERE  owner = 'PTW_PRO'
AND    object_type = 'FUNCTION'
ORDER  BY object_name;

-- ===== PACKAGES - spec and body as separate files (standard convention) =====
SELECT 'PROMPT Exporting package spec ' || object_name || CHR(10) ||
       'SPOOL packages/' || LOWER(object_name) || '.pks.sql' || CHR(10) ||
       'SELECT DBMS_METADATA.GET_DDL(''PACKAGE'', ''' || object_name || ''', ''PTW_PRO'') FROM DUAL;' || CHR(10) ||
       'SPOOL OFF' || CHR(10)
FROM   dba_objects
WHERE  owner = 'PTW_PRO'
AND    object_type = 'PACKAGE'
ORDER  BY object_name;

SELECT 'PROMPT Exporting package body ' || object_name || CHR(10) ||
       'SPOOL packages/' || LOWER(object_name) || '.pkb.sql' || CHR(10) ||
       'SELECT DBMS_METADATA.GET_DDL(''PACKAGE_BODY'', ''' || object_name || ''', ''PTW_PRO'') FROM DUAL;' || CHR(10) ||
       'SPOOL OFF' || CHR(10)
FROM   dba_objects
WHERE  owner = 'PTW_PRO'
AND    object_type = 'PACKAGE BODY'
ORDER  BY object_name;

-- ===== SYNONYMS =====
SELECT 'PROMPT Exporting synonym ' || synonym_name || CHR(10) ||
       'SPOOL synonyms/' || LOWER(synonym_name) || '.sql' || CHR(10) ||
       'SELECT DBMS_METADATA.GET_DDL(''SYNONYM'', ''' || synonym_name || ''', ''PTW_PRO'') FROM DUAL;' || CHR(10) ||
       'SPOOL OFF' || CHR(10)
FROM   dba_synonyms
WHERE  owner = 'PTW_PRO'
ORDER  BY synonym_name;

-- ===== VPD / RLS POLICIES =====
-- GET_DEPENDENT_DDL requires PL/SQL, so this block is emitted as a single
-- PL/SQL block per table rather than a plain SELECT.
SELECT 'PROMPT Exporting RLS policies for ' || table_name || CHR(10) ||
       'SPOOL policies/' || LOWER(table_name) || '_policies.sql' || CHR(10) ||
       'SET SERVEROUTPUT ON' || CHR(10) ||
       'BEGIN' || CHR(10) ||
       '    DBMS_OUTPUT.PUT_LINE(DBMS_METADATA.GET_DEPENDENT_DDL(''RLS_POLICY'', ''' || table_name || ''', ''PTW_PRO''));' || CHR(10) ||
       'EXCEPTION WHEN OTHERS THEN' || CHR(10) ||
       '    IF SQLCODE NOT IN (-31603, -31608) THEN RAISE; END IF;' || CHR(10) ||
       'END;' || CHR(10) ||
       '/' || CHR(10) ||
       'SPOOL OFF' || CHR(10)
FROM   (SELECT DISTINCT object_name AS table_name
        FROM dba_policies WHERE object_owner = 'PTW_PRO');

PROMPT PROMPT DDL export complete.

SPOOL OFF
SET TERMOUT ON

PROMPT ============================================================
PROMPT Generated run_ddl_export.sql
PROMPT
PROMPT Next steps:
PROMPT   1. Create subfolders if they don''t exist:
PROMPT      mkdir -p tables views functions procedures packages ^
PROMPT               triggers sequences indexes policies synonyms
PROMPT   2. Run: @run_ddl_export.sql
PROMPT   3. git add tables/ views/ functions/ procedures/ packages/ ^
PROMPT             triggers/ sequences/ indexes/ policies/ synonyms/
PROMPT ============================================================
