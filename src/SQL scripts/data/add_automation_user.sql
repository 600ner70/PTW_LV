INSERT INTO ptw_pro.ptw_lv_users (
    username,
    first_name,
    last_name,
    is_active,
    is_super_user,
    company_id,
    created_by
) VALUES (
    'SYSTEM_AUTOMATION',
    'System',
    'Automation',
    'Y',
    'Y',
    NULL,           -- super user: no company scoping
    'SYSTEM'
);
COMMIT;
/
