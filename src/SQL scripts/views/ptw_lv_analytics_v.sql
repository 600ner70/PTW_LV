
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PTW_PRO"."PTW_LV_ANALYTICS_V" ("PERMIT_ID", "PERMIT_NUMBER", "WORKFLOW_STATUS", "STATUS_DISPLAY", "STATUS_COLOUR", "COMPANY", "PERSON_IN_CHARGE", "SITE_DETAILS", "AREA_OF_WORKS", "WORK_DESCRIPTION", "CREATED_BY", "AUTH_PERSON_NAME", "CREATED_DATE_ONLY", "CREATED_DATE", "STARTED_DATETIME", "ENDED_DATETIME", "AUTH_DATETIME", "CLEAR_DATETIME", "CANCEL_DATETIME", "HAS_CLEARANCE", "HAS_CANCELLATION", "HAS_PHOTOS", "PTW_TYPE", "GROUP_DAILY", "GROUP_WEEKLY", "GROUP_MONTHLY") AS
  SELECT
    p.permit_id,
    p.permit_number,
    p.workflow_status,
    CASE p.workflow_status
        WHEN 'STARTED'     THEN 'Live'
        WHEN 'DRAFT'       THEN 'Draft'
        WHEN 'AUTHORISED'  THEN 'Authorised'
        WHEN 'COMPLETED'   THEN 'Completed'
        WHEN 'LAPSED'      THEN 'Lapsed'
        WHEN 'SUSPENDED'   THEN 'Suspended'
        WHEN 'CANCELLED'   THEN 'Cancelled'
        ELSE p.workflow_status
    END AS status_display,
    CASE p.workflow_status
        WHEN 'STARTED'     THEN '#28a745'
        WHEN 'DRAFT'       THEN '#17a2b8'
        WHEN 'AUTHORISED'  THEN '#6c757d'
        WHEN 'COMPLETED'   THEN '#6f42c1'
        WHEN 'LAPSED'      THEN '#6c757d'
        WHEN 'SUSPENDED'   THEN '#fd7e14'
        WHEN 'CANCELLED'   THEN '#dc3545'
        ELSE '#6c757d'
    END AS status_colour,
    NVL(p.supervising_company,   'Unknown') AS company,
    NVL(p.person_in_charge_name, 'Unknown') AS person_in_charge,
    NVL(COALESCE(s.site_name, p.site_details),          'Unknown') AS site_details,
    p.area_of_works,
    p.work_description,
    p.created_by,
    p.auth_person_name,
    TRUNC(p.created_date)                   AS created_date_only,
    p.created_date,
    p.started_datetime,
    p.ended_datetime,
    p.auth_datetime,
    p.clear_datetime,
    p.cancel_datetime,
    -- Has additional data flags (used in IR columns)
    CASE WHEN p.clear_datetime  IS NOT NULL THEN 'Y' ELSE 'N' END AS has_clearance,
    CASE WHEN p.cancel_datetime IS NOT NULL THEN 'Y' ELSE 'N' END AS has_cancellation,
    CASE WHEN p.cancel_work_complete = 'N'  THEN 'Y' ELSE 'N' END AS has_photos,
    p.ptw_type,
    -- Pre-calculated grouping columns for line chart
    TRUNC(p.created_date, 'DD') AS group_daily,
    TRUNC(p.created_date, 'IW') AS group_weekly,
    TRUNC(p.created_date, 'MM') AS group_monthly
FROM ptw_pro.ptw_lv_permits p
LEFT JOIN ptw_pro.ptw_lv_sites s ON s.site_id = p.site_id;