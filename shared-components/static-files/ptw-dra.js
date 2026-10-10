var PTW = window.PTW || {};
 
PTW.dra = (function () {
    'use strict';
 
    // Yes/No badges - same visual language/classes as the existing
    // cm-badge-row Tristate renderer in ptw-checklist.js, just without
    // the N/A badge (Stage 1 questions are strictly Yes/No).
    var YESNO_BADGES = [
        { val: 'YES', cls: 'cm-badge-yes', label: '✓' }, // check
        { val: 'NO',  cls: 'cm-badge-no',  label: '✗' }  // cross
    ];
 
    var items = [];       // last-loaded metadata + current responses
    var boundOnce = false;
 
    function findItem(itemId) {
        for (var i = 0; i < items.length; i++) {
            if (items[i].dra_item_id === itemId) { return items[i]; }
        }
        return null;
    }
 
    function renderYesNoRow($inputContainer, item, isReadOnly) {
        var $row = $('<div class="cm-badge-row"></div>').attr('data-item-id', item.dra_item_id);
 
        YESNO_BADGES.forEach(function (b) {
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
 
    function renderTickRow($inputContainer, item, isReadOnly) {
        var isChecked = item.response === 'Y';
 
        var $badge = $('<span></span>')
            .addClass('ppe-badge')
            .toggleClass('ppe-active', isChecked)
            .toggleClass('ppe-readonly', isReadOnly)
            .attr('data-item-id', item.dra_item_id)
            .text('✓');
 
        $inputContainer.append($('<div class="ppe-badge-row"></div>').append($badge));
    }
 
    // Renders Stage 1 (section = 'STAGE1') into a placeholder region,
    // grouped under each category_label heading (1. Competence, 2.
    // Communication, etc.) - the one thing ptw-checklist.js's renderer
    // doesn't need to do for Control Measures/PPE.
    function renderStage1(regionStaticId, isReadOnly) {
        var $region = $('#' + regionStaticId + ' .t-Region-body');
        if ($region.length === 0) { return; }
        $region.empty();
 
        var lastCategory = null;
 
        items
            .filter(function (i) { return i.section === 'STAGE1'; })
            .forEach(function (item) {
                if (item.category_no !== lastCategory) {
                    lastCategory = item.category_no;
                    $('<div class="ptw-dra-category"></div>')
                        .text(item.category_label)
                        .appendTo($region);
                }
 
                var $field = $('<div class="ptw-cl-item"></div>');
 
                $('<div class="ptw-cl-question"></div>')
                    .text(item.question)
                    .appendTo($field);
 
                var $inputContainer = $('<div class="ptw-cl-badges"></div>').appendTo($field);
                renderYesNoRow($inputContainer, item, isReadOnly);
 
                $region.append($field);
            });
    }
 
    // Renders Stage 2A (HAZARDS) or Stage 2B (CONTROLS) into a
    // placeholder region as a flat list of tick items - identical
    // markup to ptw-checklist.js's PPE renderer.
    function renderTickSection(regionStaticId, sectionCode, isReadOnly) {
        var $region = $('#' + regionStaticId + ' .t-Region-body');
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
                renderTickRow($inputContainer, item, isReadOnly);
 
                $region.append($field);
            });
    }
 
    function bindHandlersOnce() {
        if (boundOnce) { return; }
        boundOnce = true;
 
        // Generic handler for any .cm-badge-row on a DRA page (Stage 1
        // Yes/No), scoped by data-item-id lookup against PTW.dra's own
        // items array rather than a CSS ancestor, so it doesn't need
        // its own wrapper class to avoid colliding with ptw-checklist.js's
        // identical selector on Page 3/4 - both handlers run on the same
        // click, but only the one whose findItem() returns a match
        // updates anything, so the two static files never interfere
        // with each other even though they both listen for the same
        // click event.
        $(document).on('click.ptwDraCmBadge', '.cm-badge:not(.cm-badge-readonly)', function () {
            var $badge = $(this);
            var $row = $badge.closest('.cm-badge-row');
            var itemId = Number($row.attr('data-item-id'));
            var item = findItem(itemId);
            if (!item) { return; } // not a DRA item - ptw-checklist.js's own handler owns this click
            var val = $badge.attr('data-value');
            item.response = val;
            $row.find('.cm-badge').removeClass('cm-active');
            $badge.addClass('cm-active');
        });
 
        $(document).on('click.ptwDraTick', '.ppe-badge:not(.ppe-readonly)', function () {
            var $badge = $(this);
            var itemId = Number($badge.attr('data-item-id'));
            var item = findItem(itemId);
            if (!item) { return; } // not a DRA item
            var isNowActive = !$badge.hasClass('ppe-active');
            item.response = isNowActive ? 'Y' : null;
            $badge.toggleClass('ppe-active', isNowActive);
        });
    }
 
    /**
     * Loads the full DRA question/response set (all three sections)
     * and renders whichever placeholder regions are passed in - Page
     * 12 passes only stage1, Page 13 passes only hazards/controls.
     *
     * @param {number|string} draId
     * @param {{stage1: string, hazards: string, controls: string}} regions
     *        Static IDs of placeholder regions already on the page.
     *        Omit whichever the calling page doesn't have.
     * @param {boolean} isReadOnly
     * @param {function} [onLoaded]  optional callback once render completes
     */
    function load(draId, regions, isReadOnly, onLoaded) {
        apex.server.process('GET_DRA_JSON', { x01: draId }, {
            success: function (data) {
                items = data.items || [];
                bindHandlersOnce();
                if (regions.stage1)   { renderStage1(regions.stage1, isReadOnly); }
                if (regions.hazards)  { renderTickSection(regions.hazards, 'HAZARDS', isReadOnly); }
                if (regions.controls) { renderTickSection(regions.controls, 'CONTROLS', isReadOnly); }
                if (typeof onLoaded === 'function') { onLoaded(items); }
            },
            error: function () {
                apex.message.showErrors([{ type: 'error', message: 'Could not load the DRA question set.' }]);
            },
            dataType: 'json'
        });
    }
 
    /**
     * Returns the current answers as a plain array, ready to
     * JSON.stringify into the hidden item the save process reads.
     * YESNO items are always included (even null - unanswered).
     * TICK items are included ONLY when ticked - an unticked
     * hazard/control is left out entirely, per PTW_DRA_PKG.
     * save_dra_responses' documented contract (leaving a TICK item
     * out of the payload is what un-ticks it server-side).
     */
    function collect() {
        return items
            .filter(function (i) { return i.response_type === 'YESNO' || i.response === 'Y'; })
            .map(function (i) {
                return { dra_item_id: i.dra_item_id, response: i.response || null };
            });
    }
 
    // Count of STAGE1 items still unanswered - used by Page 12's
    // NEXT_STEP validation message (server-side check is the real
    // gate; this is only ever read for a friendlier client message
    // if you choose to add one).
    function unansweredStage1Count() {
        return items.filter(function (i) {
            return i.section === 'STAGE1' && !i.response;
        }).length;
    }
 
    return {
        load: load,
        collect: collect,
        unansweredStage1Count: unansweredStage1Count
    };
}());
