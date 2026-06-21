-- =====================================================
-- PTW LV-ELECTRICAL - PAGE 21: COMPANIES
-- + PAGE 24: EDIT COMPANY (Modal Dialog)
-- Oracle APEX 24.2 | App ID: 105
-- =====================================================
-- Part of Multi-Tenant rollout (Stage 6, Step 6.1)
-- DB OBJECT: ptw_pro.ptw_lv_companies
-- DB COLUMNS: company_id, company_name, company_code,
--             is_active, created_date, created_by,
--             modified_date, modified_by
-- =====================================================
-- PREREQUISITE: ptw_lv_companies table must already exist
--               (Stage 1, 01_ddl_multitenancy.sql).
--               NOT under VPD - super user sees all rows.
-- PATTERN: Page 21 = list (IR) only. Add/Edit happens in
--          Page 24, a Modal Dialog. This mirrors the
--          existing Page 17 (Cancel Permit) pattern: after
--          Save/Delete/Cancel, Page 24 redirects to Page 21
--          (clear cache), which APEX's dialog framework
--          interprets as "close dialog, reload parent".
-- =====================================================

-- =====================================================
-- AUTHORIZATION SCHEME (create once, shared by Pages
-- 21, 22, 24)
-- Shared Components > Authorization Schemes > Create
-- =====================================================
-- Name:          Super User Rights
-- Scheme Type:   PL/SQL Function Body Returning Boolean
-- Error Message: Access denied - Super User rights required.

DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO   v_count
    FROM   ptw_pro.ptw_lv_users
    WHERE  UPPER(username) = UPPER(:APP_USER)
    AND    is_super_user   = 'Y'
    AND    is_active       = 'Y';
    RETURN v_count > 0;
EXCEPTION
    WHEN OTHERS THEN RETURN FALSE;
END;


-- =====================================================
-- =====================================================
-- PAGE 21: COMPANIES (list only)
-- =====================================================
-- =====================================================

-- =====================================================
-- PAGE SETUP
-- =====================================================
-- App Builder > Application 105 > Create Page
-- Type:         Blank Page
-- Page Number:  21
-- Page Name:    Companies
-- Page Alias:   COMPANIES
-- Page Mode:    Normal
-- Title:        Companies
-- Warn on unsaved changes: Yes
-- Autocomplete: Off

-- =====================================================
-- PAGE PROPERTIES > Security
-- =====================================================
-- Authentication:         Page Requires Authentication
-- Authorization Scheme:   Super User Rights
-- Page Access Protection: Arguments Must Have Checksum

-- =====================================================
-- REGION 1: Page Header
-- Sequence: 10
-- Type: Dynamic Content (PL/SQL function body returning CLOB)
-- =====================================================

DECLARE
    l_html CLOB;
BEGIN
    l_html := '<div class="admin-page-header">'
           || '  <h1><span class="fa fa-building" style="margin-right:10px;"></span>Companies</h1>'
           || '  <p>Manage companies using this application. Each user belongs to '
           || '     one company, or is a Super User with access to all companies.</p>'
           || '</div>';
    RETURN l_html;
END;

-- =====================================================
-- REGION 2: Companies
-- Sequence: 20
-- Type: Interactive Report
-- Title: Companies
-- Icon: fa-building
-- Template Options: t-Region--accent15 t-Region--scrollBody
--                   t-Region--showIcon
-- Render Components: Above Content
-- Pagination: Row Ranges X to Y, Bottom Right
-- =====================================================
-- Region Source (SQL Query):

SELECT c.company_id,
       c.company_name,
       c.company_code,
       CASE c.is_active WHEN 'Y' THEN 'Active' ELSE 'Inactive' END AS status,
       c.is_active,
       TO_CHAR(c.created_date, 'DD-MON-YYYY') AS created_date,
       (SELECT COUNT(*) FROM ptw_pro.ptw_lv_users u
         WHERE u.company_id = c.company_id)   AS user_count,
       (SELECT COUNT(*) FROM ptw_pro.ptw_lv_permits p
         WHERE p.company_id = c.company_id)   AS permit_count
FROM   ptw_pro.ptw_lv_companies c
ORDER  BY c.company_name

-- Column: COMPANY_ID
--   Type: Link
--   Heading: (blank / icon column)
--   Link Text: <span class="fa fa-edit" title="Edit"></span>
--   Target: Page 24 (Modal Dialog)
--   Set Items: P24_COMPANY_ID = #COMPANY_ID#
--   Clear Cache: 24

-- Column: IS_ACTIVE
--   Hidden (raw Y/N value, STATUS column shown instead)

-- Column: COMPANY_NAME, COMPANY_CODE, STATUS, CREATED_DATE,
--         USER_COUNT, PERMIT_COUNT
--   Standard Plain Text columns, sortable/filterable (default)

-- =====================================================
-- BUTTON: Add Company
-- Region: Companies (IR) - Region Buttons, position
--         "Create" (top right of IR, standard placement)
-- =====================================================
-- Label:  Add Company
-- Action: Redirect to Page 24 (Modal Dialog)
-- Target: f?p=&APP_ID.:24:&SESSION.::&DEBUG.:24:::
-- Clear Cache: 24
-- NOTE: Do NOT set P24_COMPANY_ID - leaving it unset means
--       Page 24 opens with an empty form (create mode).


-- =====================================================
-- =====================================================
-- PAGE 24: EDIT COMPANY (Modal Dialog)
-- =====================================================
-- =====================================================

-- =====================================================
-- PAGE SETUP
-- =====================================================
-- App Builder > Application 105 > Create Page
-- Type:         Blank Page
-- Page Number:  24
-- Page Name:    Edit Company
-- Page Alias:   EDIT-COMPANY
-- Page Mode:    Modal Dialog
-- Dialog:       Chained: Yes, Resizable: Yes,
--               Dialog Template: Theme Default
--               (matches Page 17 Cancel Permit settings)
-- Title:        Based on PL/SQL Expression:
--   CASE WHEN :P24_COMPANY_ID IS NULL
--        THEN 'Add Company' ELSE 'Edit Company' END
-- Warn on unsaved changes: Yes
-- Autocomplete: Off

-- =====================================================
-- PAGE PROPERTIES > Security
-- =====================================================
-- Authentication:         Page Requires Authentication
-- Authorization Scheme:   Super User Rights (reuse - created
--                         once, under Page 21 above)
-- Page Access Protection: Arguments Must Have Checksum

-- =====================================================
-- PAGE PROPERTIES > JavaScript > Execute when Page Loads
-- =====================================================

(function () {
    var BINARY_ITEMS = ['P24_IS_ACTIVE'];

    var BADGES = [
        { val: 'Y', cls: 'binary-badge-yes', label: '✓' },
        { val: 'N', cls: 'binary-badge-no',  label: '✗' }
    ];

    BINARY_ITEMS.forEach(function (itemName) {
        var $fc = $('#' + itemName).closest('.t-Form-fieldContainer');
        if ($fc.length === 0) return;

        $fc.find('.binary-badge-row').remove();

        var currentVal = $('input[name="' + itemName + '"]:checked').val() || '';

        var $row = $('<div class="binary-badge-row"></div>').attr('data-item', itemName);

        BADGES.forEach(function (b) {
            $('<span></span>')
                .addClass('binary-badge ' + b.cls)
                .toggleClass('cm-active', currentVal === b.val)
                .attr('data-value', b.val)
                .text(b.label)
                .appendTo($row);
        });

        $fc.find('.t-Form-inputContainer').append($row);
    });

    $('.cm-binary-item .apex-item-grid').hide();

    $(document).off('click.binarybadge24').on('click.binarybadge24', '.binary-badge:not(.binary-readonly)', function () {
        var $badge   = $(this);
        var $row     = $badge.closest('.binary-badge-row');
        var itemName = $row.attr('data-item');
        var val      = $badge.attr('data-value');

        $('input[name="' + itemName + '"][value="' + val + '"]')
            .prop('checked', true).trigger('change');

        $row.find('.binary-badge').removeClass('cm-active');
        $badge.addClass('cm-active');
    });
}());

-- =====================================================
-- HIDDEN ITEMS
-- =====================================================

-- Item: P24_COMPANY_ID
-- Type: Hidden
-- Value Protected: No
-- (Primary key - set by Page 21's IR link, or left empty
--  for "Add Company")

-- =====================================================
-- REGION 1: Company Details
-- Sequence: 10
-- Type: Static Content (Form region)
-- Template: Blank with Attributes (theme dialog content
--           default)
-- =====================================================

-- Item: P24_COMPANY_NAME
-- Type: Text Field
-- Label: Company Name
-- Sequence: 10
-- Width: 12 columns (dialogs are narrower - full width reads
--        better than splitting columns)
-- Max Length: 200
-- Template: Optional - Floating
-- Value Required: Yes (validation, see below)
-- DATABASE MAPPING: ptw_pro.ptw_lv_companies.company_name

-- Item: P24_COMPANY_CODE
-- Type: Text Field
-- Label: Company Code
-- Sequence: 20
-- Begin on New Row: Yes
-- Width: 6 columns
-- Max Length: 30
-- Template: Optional - Floating
-- NOTE: Recommend a Dynamic Action (Key Release or Change)
--       to uppercase this field as the user types, matching
--       house style for code-like fields elsewhere.
-- DATABASE MAPPING: ptw_pro.ptw_lv_companies.company_code

-- Item: P24_IS_ACTIVE
-- Type: Radio Group
-- Label: Active
-- Sequence: 30
-- Begin on New Row: No
-- Width: 6 columns
-- List of Values: Static
--   Display: Yes, Return: Y
--   Display: No,  Return: N
-- Template: Optional - Above
-- CSS Classes: cm-binary-item
-- Default Value: Y (for new rows)
-- DATABASE MAPPING: ptw_pro.ptw_lv_companies.is_active

-- Item: P24_CREATED_DATE
-- Type: Display Only
-- Label: Created
-- Sequence: 40
-- Begin on New Row: Yes
-- Width: 6 columns
-- Template: Optional - Floating
-- Format Mask: DD-MON-YYYY HH24:MI (column is TIMESTAMP(6))
-- Server-side Condition: P24_COMPANY_ID IS NOT NULL
--                (hidden entirely for "Add Company")

-- Item: P24_USER_COUNT
-- Type: Display Only
-- Label: Users in this Company
-- Sequence: 50
-- Begin on New Row: No
-- Width: 6 columns
-- Template: Optional - Floating
-- Source (PL/SQL Expression, On Load):
--   (SELECT COUNT(*) FROM ptw_pro.ptw_lv_users
--    WHERE company_id = :P24_COMPANY_ID)
-- Server-side Condition: P24_COMPANY_ID IS NOT NULL
--                (hidden entirely for "Add Company")
-- NOTE: Informational only - helps super user judge whether
--       a company can safely be deleted (see Validation 3).

-- =====================================================
-- REGION 2: Buttons
-- Sequence: 20
-- Type: Buttons Container (theme dialog button-region
--       default)
-- =====================================================

-- Button 1: SAVE
-- Label:         Save Changes
-- Position:      Next (right)
-- Hot:           Yes
-- Action:        Submit Page
-- Static ID:     BTN_SAVE_P24

-- Button 2: DELETE
-- Label:         Delete Company
-- Position:      Previous (left), styled as danger
--                (t-Button--danger or similar)
-- Action:        Submit Page
-- Server-side Condition: P24_COMPANY_ID IS NOT NULL
--                (only show Delete when editing an existing
--                company - never for "Add Company")
-- Static ID:     BTN_DELETE_P24
-- Confirmation:  "Are you sure you want to delete this
--                 company? This cannot be undone."

-- Button 3: CANCEL
-- Label:         Cancel
-- Position:      Previous (left)
-- Action:        Redirect to Page 21, Clear Cache 21
-- NOTE: No processing/validation runs - this is a plain
--       redirect, which closes the modal dialog (per Page 17
--       convention) without saving anything.

-- =====================================================
-- PROCESSES
-- =====================================================

-- Process 1: Fetch Company
-- Sequence: 10
-- Point:    On Load - Before Header
-- Type:     Automatic Row Fetch
-- Table:    ptw_pro.ptw_lv_companies
-- Primary Key: company_id = P24_COMPANY_ID
-- Items:    P24_COMPANY_NAME, P24_COMPANY_CODE,
--           P24_IS_ACTIVE, P24_CREATED_DATE
-- Server-side Condition: P24_COMPANY_ID IS NOT NULL

-- Process 2: Save Company
-- Sequence: 20
-- Point:    Processing
-- Type:     Automatic Row Processing (DML)
-- Table:    ptw_pro.ptw_lv_companies
-- Primary Key: company_id = P24_COMPANY_ID
-- Items:    P24_COMPANY_NAME, P24_COMPANY_CODE, P24_IS_ACTIVE
-- When Button: SAVE, DELETE
-- NOTE: created_date/created_by/modified_date/modified_by
--       are auto-populated by the audit trigger below - do
--       not add them to this process's item list.

-- =====================================================
-- BRANCH (After Processing)
-- =====================================================

-- Branch: Return to Companies List
-- Sequence: 10
-- Point: After Processing
-- Behavior: Page or URL (Redirect)
-- Target: Page 21, Clear Cache 21
-- NOTE: Fires after Process 2 completes (Save or Delete).
--       Redirecting to a non-dialog page closes this modal
--       and reloads Page 21 with refreshed data - same
--       pattern as Page 17's "Navigate back to Dashboard"
--       branch.

-- =====================================================
-- VALIDATIONS
-- =====================================================

-- Validation 1: Company Name Required
-- Sequence:      10
-- Type:          Item is NOT NULL
-- Item:          P24_COMPANY_NAME
-- When Button:   SAVE
-- Error Message: Company Name is required.
-- Display:       Inline with Field and in Notification

-- Validation 1b: Company Code Must Be Unique
-- Sequence:      15
-- Type:          PL/SQL Function Body Returning Boolean
-- When Button:   SAVE
-- Error Message: This Company Code is already in use by
--                another company. Please choose a different
--                code, or leave it blank.
-- Display:       Inline with Field
-- Associated Item: P24_COMPANY_CODE
-- PL/SQL:

DECLARE
    v_count NUMBER;
BEGIN
    -- company_code has a UNIQUE constraint but is nullable;
    -- NULLs don't violate uniqueness, so only check when a
    -- value is actually entered.
    IF :P24_COMPANY_CODE IS NULL THEN
        RETURN TRUE;
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM   ptw_pro.ptw_lv_companies
    WHERE  UPPER(company_code) = UPPER(:P24_COMPANY_CODE)
    AND    (company_id != :P24_COMPANY_ID OR :P24_COMPANY_ID IS NULL);
    RETURN v_count = 0;
END;

-- Validation 2: Cannot Delete Company with Users
-- Sequence:      20
-- Type:          PL/SQL Function Body Returning Boolean
-- When Button:   DELETE
-- Error Message: Cannot delete this company - it still has
--                users assigned. Reassign or remove them
--                first.
-- Display:       Inline in Notification
-- PL/SQL:

DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM   ptw_pro.ptw_lv_users
    WHERE  company_id = :P24_COMPANY_ID;
    RETURN v_count = 0;
END;

-- Validation 3: Cannot Delete Company with Permits
-- Sequence:      30
-- Type:          PL/SQL Function Body Returning Boolean
-- When Button:   DELETE
-- Error Message: Cannot delete this company - it has permit
--                records. Companies with historical data
--                cannot be removed; set it to Inactive
--                instead.
-- Display:       Inline in Notification
-- PL/SQL:

DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM   ptw_pro.ptw_lv_permits
    WHERE  company_id = :P24_COMPANY_ID;
    RETURN v_count = 0;
END;


-- =====================================================
-- NAVIGATION MENU ENTRY (Page 21 only - Page 24 is a
-- dialog, never appears in navigation)
-- Shared Components > Navigation Menu
-- =====================================================
-- Label:           Companies
-- Icon:            fa-building
-- Parent Entry:    Admin
-- Sequence:        75
-- Target:          Page 21, Clear Cache 21
-- Authorization Scheme: Super User Rights


-- =====================================================
-- AUDIT TRIGGER: Auto-populate created/modified columns
-- Run once as part of this page's build (PTW_PRO schema)
-- =====================================================
-- created_date/created_by/modified_date/modified_by are
-- NOT in the Automatic Row Processing item list (Process 2)
-- - APEX leaves those columns alone on INSERT/UPDATE, and
-- this trigger fills them in automatically every time.

CREATE OR REPLACE TRIGGER ptw_pro.trg_ptw_lv_companies_audit
BEFORE INSERT OR UPDATE ON ptw_pro.ptw_lv_companies
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.created_date := SYSTIMESTAMP;
        :NEW.created_by   := NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER);
    END IF;
    :NEW.modified_date := SYSTIMESTAMP;
    :NEW.modified_by   := NVL(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER);
END;
/

-- =====================================================
-- VERIFICATION TESTS
-- =====================================================
-- 1. Log in as a normal (non-super) user - "Companies" should
--    not appear in the Admin menu, and direct navigation to
--    f?p=105:21 (or :24) should raise "Access denied - Super
--    User rights required."
-- 2. Log in as super user - Companies appears under Admin menu.
-- 3. IR shows all companies (including "Test Company 2" from
--    earlier VPD testing), with correct user_count/
--    permit_count.
-- 4. Click the edit icon on a company row - Page 24 opens as
--    a modal dialog, title "Edit Company", fields populated,
--    Created and Users count visible, Delete button visible.
-- 5. Change company_name, click Save Changes - modal closes,
--    Page 21 reloads showing the updated name in the IR.
-- 6. Click Cancel on Page 24 (no changes) - modal closes,
--    Page 21 reloads unchanged.
-- 7. Click "Add Company" - Page 24 opens as a modal, title
--    "Add Company", fields empty, Active defaults to Yes,
--    Created/Users count NOT shown, Delete button NOT shown.
-- 8. Enter a new company name/code, Save - modal closes,
--    new row appears in the IR with company_id auto-generated
--    and created_date/created_by populated by the trigger.
-- 9. Try to Delete a company with users (e.g. the default
--    company) - Validation 2 blocks with correct message,
--    modal stays open.
-- 9b. Try to Save a company using a Company Code that already
--     exists on another company - Validation 1b blocks
--     inline on the field, no raw ORA-00001 shown.
-- 10. Create a throwaway company with no users/permits via
--     Add Company, then re-open it and Delete it - succeeds,
--     modal closes, row removed from IR.
-- 11. Toggle Active/Inactive radio (Yes/No badges render and
--     are clickable, matching Page 2/3 style) - Save, confirm
--     ptw_lv_companies.is_active updated correctly.
