
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "PTW_PRO"."PTW_PERMIT_SAVE_PKG" AS

    PROCEDURE save_permit_header(
        p_permit_id                   IN OUT ptw_pro.ptw_lv_permits.permit_id%TYPE,
        p_ptw_type                    IN     ptw_pro.ptw_lv_permits.ptw_type%TYPE,
        p_workflow_status             IN     ptw_pro.ptw_lv_permits.workflow_status%TYPE,
        p_safety_programme_ref_no     IN     ptw_pro.ptw_lv_permits.safety_programme_ref_no%TYPE,
        p_isolation_diagram_serial_no IN     ptw_pro.ptw_lv_permits.isolation_diagram_serial_no%TYPE,
        p_site_id                     IN     ptw_pro.ptw_lv_permits.site_id%TYPE,
        p_site_new_name               IN     ptw_pro.ptw_lv_sites.site_name%TYPE,
        p_area_of_works               IN     ptw_pro.ptw_lv_permits.area_of_works%TYPE,
        p_work_description            IN     ptw_pro.ptw_lv_permits.work_description%TYPE,
        p_person_in_charge_name       IN     ptw_pro.ptw_lv_permits.person_in_charge_name%TYPE,
        p_supervising_company         IN     ptw_pro.ptw_lv_permits.supervising_company%TYPE,
        p_other_persons_count         IN     ptw_pro.ptw_lv_permits.other_persons_count%TYPE,
        p_client_permission_granted   IN     ptw_pro.ptw_lv_permits.client_permission_granted%TYPE,
        p_affects_it_systems          IN     ptw_pro.ptw_lv_permits.affects_it_systems%TYPE,
        p_it_permission_granted       IN     ptw_pro.ptw_lv_permits.it_permission_granted%TYPE,
        p_specialist_equipment_details IN     ptw_pro.ptw_lv_permits.specialist_equipment_details%TYPE,
        p_latitude                    IN     ptw_pro.ptw_lv_permits.site_work_latitude%TYPE,
        p_longitude                   IN     ptw_pro.ptw_lv_permits.site_work_longitude%TYPE,
        p_resolved_site_id            OUT    ptw_pro.ptw_lv_sites.site_id%TYPE,
        p_permit_number               OUT    ptw_pro.ptw_lv_permits.permit_number%TYPE,
        p_saved                       OUT    BOOLEAN,
        p_message                     OUT    VARCHAR2
    ) IS
        v_site_id    ptw_pro.ptw_lv_sites.site_id%TYPE;
        v_company_id NUMBER;
    BEGIN
        p_saved := FALSE;

        -- GUARD (previously online-only - now enforced for both
        -- callers): don't touch header fields once the permit
        -- has moved past DRAFT.
        IF p_permit_id IS NOT NULL AND p_workflow_status != 'DRAFT' THEN
            p_message := 'Permit is no longer in draft - no changes saved.';
            RETURN;
        END IF;

        -- SITE RESOLUTION (same find-or-create logic for both
        -- callers, including the race-condition handler that
        -- was previously online-only).
        IF p_site_id IS NOT NULL THEN
            v_site_id := p_site_id;
        ELSIF p_site_new_name IS NOT NULL THEN
            v_company_id := ptw_pro.ptw_sec_pkg.get_effective_company_id;
            IF v_company_id IS NULL THEN
                p_message := 'Unable to determine company for this site.';
                RETURN;
            END IF;

            BEGIN
                SELECT site_id INTO v_site_id
                FROM   ptw_pro.ptw_lv_sites
                WHERE  UPPER(site_name) = UPPER(p_site_new_name)
                AND    company_id = v_company_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    BEGIN
                        INSERT INTO ptw_pro.ptw_lv_sites (company_id, site_name, created_by)
                        VALUES (v_company_id, p_site_new_name, NVL(V('APP_USER'), USER))
                        RETURNING site_id INTO v_site_id;
                    EXCEPTION
                        WHEN DUP_VAL_ON_INDEX THEN
                            -- Race: another session created the same site name for
                            -- this company between our SELECT and our INSERT.
                            -- Re-select rather than fail the whole save.
                            SELECT site_id INTO v_site_id
                            FROM   ptw_pro.ptw_lv_sites
                            WHERE  UPPER(site_name) = UPPER(p_site_new_name)
                            AND    company_id = v_company_id;
                    END;
            END;
        END IF;
        p_resolved_site_id := v_site_id;

        IF p_permit_id IS NULL THEN
            -- INSERT NEW PERMIT
            INSERT INTO ptw_pro.ptw_lv_permits (
                ptw_type,
                safety_programme_ref_no,
                isolation_diagram_serial_no,
                site_id,
                area_of_works,
                work_description,
                person_in_charge_name,
                supervising_company,
                other_persons_count,
                client_permission_granted,
                affects_it_systems,
                it_permission_granted,
                specialist_equipment_details,
                current_step,
                workflow_status,
                site_work_latitude,
                site_work_longitude,
                created_by,
                created_date
            ) VALUES (
                NVL(p_ptw_type, 'LV ISOLATION'),
                p_safety_programme_ref_no,
                p_isolation_diagram_serial_no,
                v_site_id,
                p_area_of_works,
                p_work_description,
                p_person_in_charge_name,
                p_supervising_company,
                p_other_persons_count,
                p_client_permission_granted,
                p_specialist_equipment_details,
                p_affects_it_systems,
                p_it_permission_granted,
                'SITE_WORK_DETAILS',
                'DRAFT',
                p_latitude,
                p_longitude,
                NVL(V('APP_USER'), USER),
                SYSDATE
            ) RETURNING permit_id, permit_number
              INTO p_permit_id, p_permit_number;

            p_saved   := TRUE;
            p_message := 'Permit ' || p_permit_number || ' created successfully.';

        ELSE
            -- UPDATE EXISTING PERMIT (only if something has changed)
            UPDATE ptw_pro.ptw_lv_permits
            SET ptw_type                    = NVL(p_ptw_type, ptw_type),
                safety_programme_ref_no     = p_safety_programme_ref_no,
                isolation_diagram_serial_no = p_isolation_diagram_serial_no,
                site_id                     = v_site_id,
                area_of_works               = p_area_of_works,
                work_description            = p_work_description,
                person_in_charge_name       = p_person_in_charge_name,
                supervising_company         = p_supervising_company,
                other_persons_count         = p_other_persons_count,
                client_permission_granted   = p_client_permission_granted,
                affects_it_systems          = p_affects_it_systems,
                it_permission_granted       = p_it_permission_granted,
                specialist_equipment_details = p_specialist_equipment_details,
                site_work_latitude          = p_latitude,
                site_work_longitude         = p_longitude,
                modified_by                 = NVL(V('APP_USER'), USER),
                modified_date               = CURRENT_TIMESTAMP
            WHERE permit_id = p_permit_id
            AND (
                NVL(ptw_type,                     'x') != NVL(p_ptw_type,                     ptw_type)         OR
                NVL(safety_programme_ref_no,      'x') != NVL(p_safety_programme_ref_no,       'x')             OR
                NVL(isolation_diagram_serial_no,  'x') != NVL(p_isolation_diagram_serial_no,   'x')             OR
                NVL(site_id,                       -1) != NVL(v_site_id,                        -1)            OR
                NVL(area_of_works,                'x') != NVL(p_area_of_works,                 'x')             OR
                NVL(work_description,             'x') != NVL(p_work_description,              'x')             OR
                NVL(person_in_charge_name,        'x') != NVL(p_person_in_charge_name,          'x')            OR
                NVL(supervising_company,          'x') != NVL(p_supervising_company,            'x')            OR
                NVL(TO_CHAR(other_persons_count), 'x') != NVL(TO_CHAR(p_other_persons_count),   'x')            OR
                NVL(client_permission_granted,    'x') != NVL(p_client_permission_granted,      'x')            OR
                NVL(affects_it_systems,           'x') != NVL(p_affects_it_systems,             'x')            OR
                NVL(it_permission_granted,        'x') != NVL(p_it_permission_granted,          'x')            OR
                NVL(specialist_equipment_details, 'x') != NVL(p_specialist_equipment_details,   'x')
            )
            RETURNING permit_number INTO p_permit_number;

            IF SQL%ROWCOUNT > 0 THEN
                p_saved   := TRUE;
                p_message := 'Permit ' || p_permit_number || ' updated successfully.';
            ELSE
                -- Nothing changed - not an error, just nothing to do.
                SELECT permit_number INTO p_permit_number
                FROM   ptw_pro.ptw_lv_permits WHERE permit_id = p_permit_id;
                p_saved   := TRUE;
                p_message := 'No changes to save.';
            END IF;
        END IF;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_saved   := FALSE;
            p_message := 'Error saving permit: ' || SQLERRM;
    END save_permit_header;

END ptw_permit_save_pkg;
/
