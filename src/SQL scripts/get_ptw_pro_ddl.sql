-- ============================================================
-- Extract full DDL for all PTW_PRO-owned objects
-- Run as PTW_PRO, or as a user with SELECT on DBA_OBJECTS /
-- EXECUTE on DBMS_METADATA and access to PTW_PRO objects.
-- ============================================================

SET LONG 1000000
SET LONGCHUNKSIZE 1000000
SET PAGESIZE 0
SET LINESIZE 1000
SET FEEDBACK OFF
SET ECHO OFF
SET VERIFY OFF
SET TRIMSPOOL ON

-- Make output cleaner
BEGIN
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', TRUE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'PRETTY', TRUE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES', FALSE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', FALSE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE', FALSE);
END;
/

SPOOL ptw_pro_ddl.sql

-- ===== TABLES (includes columns, constraints if not separated) =====
SELECT DBMS_METADATA.GET_DDL('TABLE', table_name, 'PTW_PRO') || CHR(10)
FROM   dba_tables
WHERE  owner = 'PTW_PRO'
ORDER  BY table_name;

-- ===== TABLE CONSTRAINTS (FKs, PKs, checks - separate, in case excluded above) =====
SET SERVEROUTPUT ON
DECLARE
    v_ddl CLOB;
BEGIN
    FOR t IN (SELECT table_name FROM dba_tables WHERE owner = 'PTW_PRO' ORDER BY table_name) LOOP
        BEGIN
            v_ddl := DBMS_METADATA.GET_DEPENDENT_DDL('CONSTRAINT', t.table_name, 'PTW_PRO');
            DBMS_OUTPUT.PUT_LINE(v_ddl);
            DBMS_OUTPUT.PUT_LINE(CHR(10));
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE IN (-31603, -31608) THEN
                    NULL; -- no constraints for this table, skip
                ELSE
                    RAISE;
                END IF;
        END;
    END LOOP;
END;
/

-- ===== INDEXES (non-constraint-backed) =====
SELECT DBMS_METADATA.GET_DDL('INDEX', index_name, 'PTW_PRO') || CHR(10)
FROM   dba_indexes
WHERE  owner = 'PTW_PRO'
AND    index_name NOT IN (
         SELECT index_name FROM dba_constraints
         WHERE owner = 'PTW_PRO' AND index_name IS NOT NULL
       )
ORDER  BY index_name;

-- ===== SEQUENCES =====
SELECT DBMS_METADATA.GET_DDL('SEQUENCE', sequence_name, 'PTW_PRO') || CHR(10)
FROM   dba_sequences
WHERE  sequence_owner = 'PTW_PRO'
AND    sequence_name NOT LIKE 'ISEQ$$%'
ORDER  BY sequence_name;

-- ===== VIEWS =====
SELECT DBMS_METADATA.GET_DDL('VIEW', view_name, 'PTW_PRO') || CHR(10)
FROM   dba_views
WHERE  owner = 'PTW_PRO'
ORDER  BY view_name;

-- ===== TRIGGERS =====
SELECT DBMS_METADATA.GET_DDL('TRIGGER', trigger_name, 'PTW_PRO') || CHR(10)
FROM   dba_triggers
WHERE  owner = 'PTW_PRO'
ORDER  BY trigger_name;

-- ===== PROCEDURES =====
SELECT DBMS_METADATA.GET_DDL('PROCEDURE', object_name, 'PTW_PRO') || CHR(10)
FROM   dba_procedures
WHERE  owner = 'PTW_PRO'
AND    object_type = 'PROCEDURE'
ORDER  BY object_name;

-- ===== FUNCTIONS =====
SELECT DBMS_METADATA.GET_DDL('FUNCTION', object_name, 'PTW_PRO') || CHR(10)
FROM   dba_procedures
WHERE  owner = 'PTW_PRO'
AND    object_type = 'FUNCTION'
ORDER  BY object_name;

-- ===== PACKAGES (spec) =====
SELECT DBMS_METADATA.GET_DDL('PACKAGE', object_name, 'PTW_PRO') || CHR(10)
FROM   dba_objects
WHERE  owner = 'PTW_PRO'
AND    object_type = 'PACKAGE'
ORDER  BY object_name;

-- ===== PACKAGE BODIES =====
SELECT DBMS_METADATA.GET_DDL('PACKAGE_BODY', object_name, 'PTW_PRO') || CHR(10)
FROM   dba_objects
WHERE  owner = 'PTW_PRO'
AND    object_type = 'PACKAGE BODY'
ORDER  BY object_name;

-- ===== SYNONYMS (if any) =====
SELECT DBMS_METADATA.GET_DDL('SYNONYM', synonym_name, 'PTW_PRO') || CHR(10)
FROM   dba_synonyms
WHERE  owner = 'PTW_PRO'
ORDER  BY synonym_name;

-- ===== VPD / RLS POLICIES (if already applied) =====
DECLARE
    v_ddl CLOB;
BEGIN
    FOR t IN (SELECT DISTINCT object_name AS table_name
              FROM dba_policies WHERE object_owner = 'PTW_PRO') LOOP
        BEGIN
            v_ddl := DBMS_METADATA.GET_DEPENDENT_DDL('RLS_POLICY', t.table_name, 'PTW_PRO');
            DBMS_OUTPUT.PUT_LINE(v_ddl);
            DBMS_OUTPUT.PUT_LINE(CHR(10));
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE IN (-31603, -31608) THEN
                    NULL;
                ELSE
                    RAISE;
                END IF;
        END;
    END LOOP;
END;
/

-- ===== CONTEXTS owned/used by PTW_PRO (run as a DBA-privileged user) =====
-- SELECT DBMS_METADATA.GET_DDL('CONTEXT', namespace) || CHR(10)
-- FROM   dba_context
-- WHERE  schema = 'PTW_PRO';

SPOOL OFF

-- ============================================================
-- Notes:
-- - If you don't have DBA_* view access, swap to the ALL_*
--   equivalents (ALL_TABLES, ALL_SEQUENCES, ALL_VIEWS, etc.)
--   and the queries still work as long as PTW_PRO objects are
--   visible to your user.
-- - GET_DEPENDENT_DDL for CONSTRAINT can occasionally raise
--   "ORA-31603: object ... not found" if a table has zero
--   constraints - if that happens, comment out that block and
--   run table-by-table, or wrap in a PL/SQL loop with exception
--   handling (see below for a safer looped version).
-- ============================================================
