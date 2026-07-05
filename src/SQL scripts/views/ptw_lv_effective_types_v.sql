
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PTW_PRO"."PTW_LV_EFFECTIVE_TYPES_V" ("USER_ID", "USERNAME", "COMPANY_ID", "TEAM_ID", "TYPE_ID", "IS_ACTIVE") AS
  SELECT
    u.user_id,
    u.username,
    u.company_id,
    u.team_id,
    ct.type_id,
    CASE
        WHEN ut.is_active IS NOT NULL THEN ut.is_active   -- engineer override wins
        WHEN tt.is_active IS NOT NULL THEN tt.is_active   -- else team override
        ELSE 'Y'                                          -- else company grant (ct pre-filtered active)
    END AS is_active
FROM ptw_pro.ptw_lv_users         u
JOIN ptw_pro.ptw_lv_company_types ct
     ON ct.company_id = u.company_id AND ct.is_active = 'Y'
LEFT JOIN ptw_pro.ptw_lv_team_types tt
     ON tt.team_id = u.team_id AND tt.type_id = ct.type_id
LEFT JOIN ptw_pro.ptw_lv_user_types ut
     ON ut.user_id = u.user_id AND ut.type_id = ct.type_id;
