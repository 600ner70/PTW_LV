CREATE OR REPLACE EDITIONABLE PACKAGE "PTW_PRO"."PTW_SEC_PKG" AS

    -- Called once per APEX session (Post-Authentication process)
    PROCEDURE set_session_context(p_username IN VARCHAR2);

    -- VPD policy function — returns the predicate appended to all
    -- SELECT/UPDATE/DELETE on protected tables
    FUNCTION company_policy(
        p_schema  IN VARCHAR2,
        p_object  IN VARCHAR2
    ) RETURN VARCHAR2;

    -- Page 8 (User Management) guard: raises an error if the target user
    -- is not in the caller's company (unless caller is a super user /
    -- workspace admin). Call this at the top of every Page 8 DML process
    -- before acting on a user_id passed via page item.
    PROCEDURE check_user_in_company(p_username IN VARCHAR2);

    FUNCTION get_effective_company_id RETURN NUMBER;

END ptw_sec_pkg;
/
