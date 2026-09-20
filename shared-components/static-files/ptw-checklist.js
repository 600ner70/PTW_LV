/* ptw-checklist.js
 * Reusable, permit-type-driven checklist renderer.
 * Same badge markup and CSS classes as the existing page 3 tristate/tick
 * badges (cm-badge-row, cm-badge, cm-active, ppe-badge-row, ppe-badge,
 * ppe-active) — nothing in ptw-global.css needs to change.
 *
 * Static Application File — reference on Page 0 via File URLs, per
 * DEVELOPER_NOTES.md section 4 ("Reusable JavaScript Functions — USE
 * STATIC APPLICATION FILES").
 *
 * CHANGE (Fire Systems Isolation): added response_type 'TICK_NA' — a
 * two-badge Tick/N-A row (no "No" badge), for checklist sections whose
 * source form has a Tick/N-A layout rather than a Yes/No/N-A layout.
 * Reuses the exact same cm-badge / cm-badge-row markup and the same
 * click handler as TRISTATE, just with the 'N' badge left out — no CSS
 * changes needed.
 */
var PTW = window.PTW || {};

PTW.checklist = (function () {
    'use strict';

    var BADGES = [
        { val: 'Y',  cls: 'cm-badge-yes', label: '✓' }, // check
        { val: 'N',  cls: 'cm-badge-no',  label: '✗' }, // cross
        { val: 'NA', cls: 'cm-badge-na',  label: 'N/A' }
    ];

    var items = [];       // last-loaded metadata + current responses
    var boundOnce = false;

    function findItem(itemId) {
        for (var i = 0; i < items.length; i++) {
            if (items[i].checklist_item_id === itemId) { return items[i]; }
        }
        return null;
    }

    // Shared by TRISTATE (all 3 badges) and TICK_NA (Y/NA only, no N).
    function renderBadgeRow($inputContainer, item, isReadOnly, badgeList) {
        var $row = $('<div class="cm-badge-row"></div>').attr('data-item-id', item.checklist_item_id);

        badgeList.forEach(function (b) {
            $('<span></span>')
                .addClass('cm-badge ' + b.cls)
                .toggleClass('cm-active', item.response === b.val)
                .toggleClass('cm-badge-readonly', isReadOnly)
                .attr('data-value', b.val)
                .text(b.label)
                .appendTo($row);
        });

        $inputContainer.append($row);
    }

    function renderTristateRow($inputContainer, item, isReadOnly) {
        renderBadgeRow($inputContainer, item, isReadOnly, BADGES);
    }

    // Tick/N-A only — same badges/handler as tristate, 'No' left out.
    function renderTickNaRow($inputContainer, item, isReadOnly) {
        var tickNaBadges = BADGES.filter(function (b) { return b.val !== 'N'; });
        renderBadgeRow($inputContainer, item, isReadOnly, tickNaBadges);
    }

    function renderTickRow($inputContainer, item, isReadOnly) {
        var isChecked = item.response === 'Y';

        var $badge = $('<span></span>')
            .addClass('ppe-badge')
            .toggleClass('ppe-active', isChecked)
            .toggleClass('ppe-readonly', isReadOnly)
            .attr('data-item-id', item.checklist_item_id)
            .text('✓');

        $inputContainer.append($('<div class="ppe-badge-row"></div>').append($badge));
    }

    // Renders one section (CONTROL_MEASURES or PPE) into a placeholder
    // region (a Static Content / HTML region with the given Static ID).
    // Uses fully custom markup/classes (ptw-cl-*) instead of Universal
    // Theme's t-Form-* wrapper classes - those come with their own
    // internal grid/layout rules that fight custom CSS in ways that are
    // hard to predict, so this renderer owns its layout completely.
    function renderSection(regionStaticId, sectionCode, isReadOnly) {
        var $region = $('#' + regionStaticId);
        if ($region.length === 0) { return; }
        $region.empty();

        items
            .filter(function (i) { return i.section === sectionCode; })
            .forEach(function (item) {
                var $field = $('<div class="ptw-cl-item"></div>');

                $('<div class="ptw-cl-question"></div>')
                    .text(item.question)
                    .appendTo($field);

                var $inputContainer = $('<div class="ptw-cl-badges"></div>').appendTo($field);

                if (item.response_type === 'TICK') {
                    renderTickRow($inputContainer, item, isReadOnly);
                } else if (item.response_type === 'TICK_NA') {
                    renderTickNaRow($inputContainer, item, isReadOnly);
                } else {
                    renderTristateRow($inputContainer, item, isReadOnly);
                }

                $region.append($field);
            });
    }

    function bindHandlersOnce() {
        if (boundOnce) { return; }
        boundOnce = true;

        // Badge-row items (TRISTATE and TICK_NA both use .cm-badge inside
        // a .cm-badge-row — this handler works for either, since it just
        // toggles active state within whichever badges are present).
        $(document).on('click.ptwCmTristate', '.cm-badge:not(.cm-badge-readonly)', function () {
            var $badge = $(this);
            var $row = $badge.closest('.cm-badge-row');
            var itemId = Number($row.attr('data-item-id'));
            var val = $badge.attr('data-value');

            var item = findItem(itemId);
            if (item) { item.response = val; }

            $row.find('.cm-badge').removeClass('cm-active');
            $badge.addClass('cm-active');
        });

        // Tick badges (PPE)
        $(document).on('click.ptwPpeTick', '.ppe-badge:not(.ppe-readonly)', function () {
            var $badge = $(this);
            var itemId = Number($badge.attr('data-item-id'));
            var isNowActive = !$badge.hasClass('ppe-active');

            var item = findItem(itemId);
            if (item) { item.response = isNowActive ? 'Y' : null; }

            $badge.toggleClass('ppe-active', isNowActive);
        });
    }

    /**
     * Loads the checklist for a permit and renders it into two placeholder
     * regions. Call once on page load (e.g. from Execute When Page Loads).
     *
     * @param {number|string} permitId
     * @param {{controlMeasures: string, ppe: string}} regions  Static IDs of
     *        the two placeholder regions already on the page.
     * @param {boolean} isReadOnly
     */
    function load(permitId, regions, isReadOnly) {
        apex.server.process('GET_CHECKLIST', { x01: permitId }, {
            success: function (data) {
                items = data.items || [];
                bindHandlersOnce();
                renderSection(regions.controlMeasures, 'CONTROL_MEASURES', isReadOnly);
                renderSection(regions.ppe, 'PPE', isReadOnly);
            },
            error: function () {
                apex.message.showErrors([{ type: 'error', message: 'Could not load checklist.' }]);
            },
            dataType: 'json'
        });
    }

    /**
     * Returns the current answers as a plain array, ready to JSON.stringify
     * into the hidden item the save process reads.
     */
    function collect() {
        return items.map(function (i) {
            return { checklist_item_id: i.checklist_item_id, response: i.response || null };
        });
    }

    return {
        load: load,
        collect: collect
    };
}());