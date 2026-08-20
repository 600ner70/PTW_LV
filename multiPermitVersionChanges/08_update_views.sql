--------------------------------------------------------------------------------
-- 08_update_views.sql
-- Updates the two views that read auth_/accept_/clear_/cancel_ fields
-- directly off PTW_LV_PERMITS, so they keep working once new permits save
-- through ptw_signature_pkg instead of writing those columns.
--
-- No mirror columns needed — since nothing is built yet, a clean join is
-- just as cheap as maintaining duplicate columns forever, and there is
-- exactly one place each of these fields comes from, going forward.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- PTW_LV_ANALYTICS_V — same shape/column list as before, auth_person_name/
-- auth_datetime/clear_datetime/cancel_datetime now sourced from
-- PTW_SIGNATURES via three single-row-per-permit LEFT JOINs (one per stage).
--------------------------------------------------------------------------------
CREATE OR REPLACE FORCE EDITIONABLE VIEW "PTW_PRO"."PTW_LV_ANALYTICS_V" (
    "PERMIT_ID", "PERMIT_NUMBER", "WORKFLOW_STATUS", "STATUS_DISPLAY", "STATUS_COLOUR",
    "COMPANY", "PERSON_IN_CHARGE", "SITE_DETAILS", "AREA_OF_WORKS", "WORK_DESCRIPTION",
    "CREATED_BY", "AUTH_PERSON_NAME", "CREATED_DATE_ONLY", "CREATED_DATE",
    "STARTED_DATETIME", "ENDED_DATETIME", "AUTH_DATETIME", "CLEAR_DATETIME",
    "CANCEL_DATETIME", "HAS_CLEARANCE", "HAS_CANCELLATION", "HAS_PHOTOS",
    "PTW_TYPE", "GROUP_DAILY", "GROUP_WEEKLY", "GROUP_MONTHLY"
) AS
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
    NVL(COALESCE(s.site_name, p.site_details), 'Unknown') AS site_details,
    p.area_of_works,
    p.work_description,
    p.created_by,
    auth_sig.person_name AS auth_person_name,
    TRUNC(p.created_date) AS created_date_only,
    p.created_date,
    p.started_datetime,
    p.ended_datetime,
    auth_sig.event_datetime  AS auth_datetime,
    clear_sig.event_datetime AS clear_datetime,
    cancel_sig.event_datetime AS cancel_datetime,
    CASE WHEN clear_sig.event_datetime  IS NOT NULL THEN 'Y' ELSE 'N' END AS has_clearance,
    CASE WHEN cancel_sig.event_datetime IS NOT NULL THEN 'Y' ELSE 'N' END AS has_cancellation,
    CASE WHEN p.cancel_work_complete = 'N' THEN 'Y' ELSE 'N' END AS has_photos,
    p.ptw_type,
    TRUNC(p.created_date, 'DD') AS group_daily,
    TRUNC(p.created_date, 'IW') AS group_weekly,
    TRUNC(p.created_date, 'MM') AS group_monthly
FROM ptw_pro.ptw_lv_permits p
LEFT JOIN ptw_pro.ptw_lv_sites s      ON s.site_id = p.site_id
LEFT JOIN ptw_pro.ptw_signatures auth_sig
       ON auth_sig.permit_id = p.permit_id AND auth_sig.stage = 'AUTH'
LEFT JOIN ptw_pro.ptw_signatures clear_sig
       ON clear_sig.permit_id = p.permit_id AND clear_sig.stage = 'CLEAR'
LEFT JOIN ptw_pro.ptw_signatures cancel_sig
       ON cancel_sig.permit_id = p.permit_id AND cancel_sig.stage = 'CANCEL';

--------------------------------------------------------------------------------
-- PTW_LV_CANCELLATION_REASON_V — cancel_person_name/cancel_datetime/
-- cancel_person_signature now from PTW_SIGNATURES (stage = 'CANCEL')
-- instead of PTW_LV_PERMITS directly. Concerns join unchanged.
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW ptw_pro.ptw_lv_cancellation_reason_v AS
SELECT
    p.permit_id,
    p.cancel_work_complete,
    cancel_sig.person_name      AS cancel_person_name,
    cancel_sig.event_datetime   AS cancel_datetime,
    cancel_sig.signature_blob   AS cancel_person_signature,
    mc.concern_id,
    mc.check_number,
    CASE mc.check_number
        WHEN 1 THEN 'Method Statement Check 1'
        WHEN 2 THEN 'Method Statement Check 2'
        WHEN 3 THEN 'Method Statement Check 3'
    END                                            AS check_label,
    mc.concern_description,
    mc.actions_taken,
    mc.concern_person_name,
    mc.concern_datetime,
    mc.concern_signature,
    CASE WHEN mc.concern_id IS NOT NULL THEN 'Y' ELSE 'N' END AS is_concern_cancellation
FROM   ptw_pro.ptw_lv_permits p
LEFT JOIN ptw_pro.ptw_signatures cancel_sig
       ON cancel_sig.permit_id = p.permit_id AND cancel_sig.stage = 'CANCEL'
LEFT JOIN ptw_pro.ptw_lv_monitoring_concerns mc
       ON mc.happy_to_continue = 'N'
       AND mc.monitoring_id IN (
             SELECT m.monitoring_id
             FROM   ptw_pro.ptw_lv_monitoring m
             WHERE  m.permit_id = p.permit_id
           )
WHERE  p.workflow_status = 'CANCELLED';
