
  CREATE OR REPLACE EDITIONABLE PACKAGE "PTW_PRO"."PTW_UI_PKG" AS

    FUNCTION get_workflow_steps_html(
        p_permit_id    IN ptw_pro.ptw_lv_permits.permit_id%TYPE    DEFAULT NULL,
        p_ptw_type     IN ptw_pro.ptw_lv_permits.ptw_type%TYPE     DEFAULT NULL,
        p_current_step IN ptw_pro.ptw_lv_permits.current_step%TYPE DEFAULT NULL
    ) RETURN CLOB;

    FUNCTION get_permit_type_badge_html(
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE DEFAULT NULL,
        p_ptw_type  IN ptw_pro.ptw_lv_permits.ptw_type%TYPE  DEFAULT NULL
    ) RETURN CLOB;

END ptw_ui_pkg;
/
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "PTW_PRO"."PTW_UI_PKG" AS

    FUNCTION get_workflow_steps_html(
        p_permit_id    IN ptw_pro.ptw_lv_permits.permit_id%TYPE    DEFAULT NULL,
        p_ptw_type     IN ptw_pro.ptw_lv_permits.ptw_type%TYPE     DEFAULT NULL,
        p_current_step IN ptw_pro.ptw_lv_permits.current_step%TYPE DEFAULT NULL
    ) RETURN CLOB IS

        TYPE t_step_rec IS RECORD (
            step_code  VARCHAR2(30),
            step_label VARCHAR2(50)
        );
        TYPE t_step_tab IS TABLE OF t_step_rec INDEX BY PLS_INTEGER;

        l_steps        t_step_tab;
        l_ptw_type     ptw_pro.ptw_lv_permits.ptw_type%TYPE     := p_ptw_type;
        l_current_step ptw_pro.ptw_lv_permits.current_step%TYPE := p_current_step;
        l_current_idx  PLS_INTEGER := 0;
        l_html         CLOB := '<div class="ptw-workflow-progress">';
        l_class        VARCHAR2(30);
        l_icon         VARCHAR2(20);

    BEGIN
        -- Existing permit: DB values win. New/unsaved permit (permit_id
        -- NULL, or not yet inserted): fall back to what was passed in.
        IF p_permit_id IS NOT NULL THEN
            BEGIN
                SELECT ptw_type, current_step
                INTO   l_ptw_type, l_current_step
                FROM   ptw_pro.ptw_lv_permits
                WHERE  permit_id = p_permit_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_ptw_type     := p_ptw_type;
                    l_current_step := p_current_step;
            END;
        END IF;

        -- New permit, first ever load: no current_step yet, always step 1.
        l_current_step := NVL(l_current_step, 'SITE_WORK_DETAILS');

        IF l_ptw_type IS NULL THEN
            RETURN NULL;   -- genuinely nothing to render (no type chosen at all)
        END IF;

        IF l_ptw_type = 'LV ISOLATION' THEN
            l_steps(1).step_code := 'SITE_WORK_DETAILS'; l_steps(1).step_label := 'Site & Work Details';
            l_steps(2).step_code := 'CONTROL_MEASURES';  l_steps(2).step_label := 'Control Measures';
            l_steps(3).step_code := 'EQUIP_ISOLATION';   l_steps(3).step_label := 'Equipment Isolation';
            l_steps(4).step_code := 'AUTHORISATION';     l_steps(4).step_label := 'Authorisation';
            l_steps(5).step_code := 'CLEARANCE';         l_steps(5).step_label := 'Clearance';
        ELSE
            l_steps(1).step_code := 'SITE_WORK_DETAILS'; l_steps(1).step_label := 'Site & Work Details';
            l_steps(2).step_code := 'CONTROL_MEASURES';  l_steps(2).step_label := 'Control Measures';
            l_steps(3).step_code := 'AUTHORISATION';     l_steps(3).step_label := 'Authorisation';
            l_steps(4).step_code := 'CLEARANCE';         l_steps(4).step_label := 'Clearance';
        END IF;

        FOR i IN 1 .. l_steps.COUNT LOOP
            IF l_steps(i).step_code = l_current_step THEN
                l_current_idx := i;
            END IF;
        END LOOP;

        FOR i IN 1 .. l_steps.COUNT LOOP
            IF l_current_idx = 0 THEN
                l_class := NULL;
                l_icon  := TO_CHAR(i);
            ELSIF i < l_current_idx THEN
                l_class := 'completed';
                l_icon  := '&#10003;';
            ELSIF i = l_current_idx THEN
                l_class := 'active';
                l_icon  := TO_CHAR(i);
            ELSE
                l_class := NULL;
                l_icon  := TO_CHAR(i);
            END IF;

            l_html := l_html
                || '<div class="workflow-step' || CASE WHEN l_class IS NOT NULL THEN ' ' || l_class END
                || '" data-step="' || i || '">'
                || '<span class="step-icon">' || l_icon || '</span>'
                || '<span class="step-text">' || APEX_ESCAPE.HTML(l_steps(i).step_label) || '</span>'
                || '</div>';
        END LOOP;

        RETURN l_html || '</div>';
    END get_workflow_steps_html;


    FUNCTION get_permit_type_badge_html(
        p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE DEFAULT NULL,
        p_ptw_type  IN ptw_pro.ptw_lv_permits.ptw_type%TYPE  DEFAULT NULL
    ) RETURN CLOB IS
        l_ptw_type  ptw_pro.ptw_lv_permits.ptw_type%TYPE := p_ptw_type;
        l_type_desc ptw_pro.ptw_types.type_desc%TYPE;
    BEGIN
        IF p_permit_id IS NOT NULL THEN
            BEGIN
                SELECT ptw_type INTO l_ptw_type
                FROM   ptw_pro.ptw_lv_permits
                WHERE  permit_id = p_permit_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    l_ptw_type := p_ptw_type;
            END;
        END IF;

        IF l_ptw_type IS NULL THEN
            RETURN NULL;
        END IF;

        SELECT type_desc INTO l_type_desc
        FROM   ptw_pro.ptw_types
        WHERE  ptw_type = l_ptw_type;

        RETURN '<div class="ptw-permit-type-badge" style="margin-bottom:12px;">'
            || '<span class="apex-badge" style="background-color:#5a6b7a;color:white;'
            || 'padding:4px 14px;border-radius:14px;font-weight:600;font-size:0.85rem;">'
            || APEX_ESCAPE.HTML(l_type_desc)
            || '</span></div>';

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END get_permit_type_badge_html;

END ptw_ui_pkg;
/
