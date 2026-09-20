
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "PTW_PRO"."PTW_PERMIT_LINK_PKG" AS

    FUNCTION get_link_count(p_permit_id IN ptw_pro.ptw_lv_permits.permit_id%TYPE) RETURN NUMBER IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM   ptw_pro.ptw_permit_links_v
        WHERE  permit_id = p_permit_id;
        RETURN v_count;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END get_link_count;


    PROCEDURE add_link(
        p_permit_id        IN  ptw_pro.ptw_lv_permits.permit_id%TYPE,
        p_linked_permit_id IN  ptw_pro.ptw_lv_permits.permit_id%TYPE,
        p_link_note        IN  ptw_pro.ptw_permit_links.link_note%TYPE DEFAULT NULL,
        p_added            OUT BOOLEAN,
        p_message          OUT VARCHAR2
    ) IS
        v_company_id       ptw_pro.ptw_lv_permits.company_id%TYPE;
        v_linked_company_id ptw_pro.ptw_lv_permits.company_id%TYPE;
        v_permit_number    ptw_pro.ptw_lv_permits.permit_number%TYPE;
        v_linked_number    ptw_pro.ptw_lv_permits.permit_number%TYPE;
        v_existing         NUMBER;
    BEGIN
        p_added := FALSE;

        IF p_permit_id IS NULL OR p_linked_permit_id IS NULL THEN
            p_message := 'Both permits are required.';
            RETURN;
        END IF;

        IF p_permit_id = p_linked_permit_id THEN
            p_message := 'A permit cannot be linked to itself.';
            RETURN;
        END IF;

        BEGIN
            SELECT company_id, permit_number INTO v_company_id, v_permit_number
            FROM   ptw_pro.ptw_lv_permits WHERE permit_id = p_permit_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_message := 'Permit not found.';
                RETURN;
        END;

        BEGIN
            SELECT company_id, permit_number INTO v_linked_company_id, v_linked_number
            FROM   ptw_pro.ptw_lv_permits WHERE permit_id = p_linked_permit_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_message := 'The permit you selected to link was not found.';
                RETURN;
        END;

        IF v_company_id != v_linked_company_id THEN
            p_message := 'Permits can only be linked within the same company.';
            RETURN;
        END IF;

        SELECT COUNT(*) INTO v_existing
        FROM   ptw_pro.ptw_permit_links
        WHERE  (permit_id = p_permit_id AND linked_permit_id = p_linked_permit_id)
        OR     (permit_id = p_linked_permit_id AND linked_permit_id = p_permit_id);

        IF v_existing > 0 THEN
            p_message := 'Permit ' || v_permit_number || ' is already linked to ' || v_linked_number || '.';
            RETURN;
        END IF;

        INSERT INTO ptw_pro.ptw_permit_links (
            permit_id, linked_permit_id, link_note, company_id, created_by, created_date
        ) VALUES (
            p_permit_id, p_linked_permit_id, p_link_note, v_company_id, NVL(V('APP_USER'), USER), SYSDATE
        );

        COMMIT;

        p_added   := TRUE;
        p_message := 'Linked to ' || v_linked_number || '.';

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_added   := FALSE;
            p_message := 'Error creating link: ' || SQLERRM;
    END add_link;


    PROCEDURE remove_link(
        p_link_id  IN  ptw_pro.ptw_permit_links.link_id%TYPE,
        p_removed  OUT BOOLEAN,
        p_message  OUT VARCHAR2
    ) IS
    BEGIN
        p_removed := FALSE;

        DELETE FROM ptw_pro.ptw_permit_links WHERE link_id = p_link_id;

        IF SQL%ROWCOUNT > 0 THEN
            COMMIT;
            p_removed := TRUE;
            p_message := 'Link removed.';
        ELSE
            p_message := 'Link not found.';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_removed := FALSE;
            p_message := 'Error removing link: ' || SQLERRM;
    END remove_link;

END ptw_permit_link_pkg;
/
