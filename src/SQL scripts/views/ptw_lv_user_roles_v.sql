
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PTW_PRO"."PTW_LV_USER_ROLES_V" ("ROLE_ID", "USERNAME", "ROLE_NAME", "IS_ACTIVE", "USER_ACTIVE", "ROLE_ACTIVE", "FIRST_NAME", "LAST_NAME", "EMAIL_ADDRESS", "MOBILE_NO", "JOB_TITLE", "GRANTED_BY", "GRANTED_DATE", "MODIFIED_DATE", "USER_ID", "ROLE_REF_ID", "IS_ADMIN_ROLE", "ROLE_DESCRIPTION", "DISPLAY_ORDER", "COMPANY_ID", "COMPANY_NAME", "IS_SUPER_USER") AS
  SELECT
    ur.user_role_id                                         AS role_id,
    u.username,
    r.role_name,
    CASE
        WHEN u.is_active = 'Y' AND ur.is_active = 'Y' THEN 'Y'
        ELSE 'N'
    END                                                     AS is_active,
    u.is_active                                             AS user_active,
    ur.is_active                                            AS role_active,
    u.first_name,
    u.last_name,
    u.email_address,
    u.mobile_no,
    u.job_title,
    ur.granted_by,
    ur.granted_date,
    ur.modified_date,
    u.user_id,
    r.role_id                                               AS role_ref_id,
    r.is_admin_role,
    r.role_description,
    r.display_order,
    u.company_id,
    c.company_name,
    u.is_super_user
FROM   ptw_pro.ptw_lv_user_role_assignments  ur
JOIN   ptw_pro.ptw_lv_users                  u   ON u.user_id = ur.user_id
JOIN   ptw_pro.ptw_lv_roles                  r   ON r.role_id = ur.role_id
LEFT JOIN ptw_pro.ptw_lv_companies           c   ON c.company_id = u.company_id;
