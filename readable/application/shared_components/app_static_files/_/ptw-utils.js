/**
 * ptw-utils.js
 * PTW LV-Electrical — Shared Utility Functions
 * Upload to: Shared Components > Static Application Files
 * Reference: User Interface Attributes > JavaScript > File URLs
 *   #APP_FILES#ptw-utils#MIN#.js
 *
 * CHANGE LOG:
 *   v2 (Apr 2026) — Signature pad functions moved here from Page 5
 *                   inline JS so they are available on all pages
 *                   (Page 10 LV Monitoring requires them).
 *                   Functions added: initPad(), SignaturePad,
 *                   loadSignature(), saveSignatures().
 *                   Page 5 inline JS must have these removed after
 *                   uploading this file — see note at bottom.
 */

// =============================================================
// GEOLOCATION
// =============================================================

/**
 * initGeolocation()
 * Call on Page 1 load to trigger browser permission prompt early
 * and persist coordinates to session state via AJAX callback.
 */
function initGeolocation() {
    if (!navigator.geolocation) {
        console.warn('Geolocation not supported.');
        return;
    }
    navigator.geolocation.getCurrentPosition(
        function(position) {
            var lat = position.coords.latitude;
            var lng = position.coords.longitude;
            apex.server.process('SET_LOCATION', {
                x01: lat,
                x02: lng
            }, {
                dataType: 'text',
                success: function() {
                    console.log('Location saved to session: ' + lat + ', ' + lng);
                },
                error: function() {
                    console.warn('Failed to save location to session state.');
                }
            });
        },
        function(error) {
            console.warn('Initial geolocation error (' + error.code + '): ' + error.message);
        },
        {
            enableHighAccuracy: false,
            timeout: 10000,
            maximumAge: 0
        }
    );
}

/**
 * captureLocationThenSubmit(request, callback)
 * Call on button click (Pages 2-5, 10).
 * Captures fresh GPS coordinates, saves to session via AJAX
 * SET_LOCATION callback, then submits the page.
 * Always submits even if geolocation fails — never blocks save.
 */
function captureLocationThenSubmit(request, callback) {

    function doSubmit() {
        if (typeof callback === 'function') {
            callback(request);
        } else {
            apex.page.submit(request);
        }
    }

    function saveLocationAndSubmit(lat, lng) {
        apex.server.process('SET_LOCATION', {
            x01: lat,
            x02: lng
        }, {
            dataType: 'text',
            success: function() {
                console.log('Location saved: ' + lat + ', ' + lng);
                doSubmit();
            },
            error: function() {
                console.warn('SET_LOCATION failed — submitting anyway.');
                doSubmit();
            }
        });
    }

    if (!navigator.geolocation) {
        console.warn('Geolocation not supported — submitting without coordinates.');
        doSubmit();
        return;
    }

    navigator.geolocation.getCurrentPosition(
        function(position) {
            saveLocationAndSubmit(
                position.coords.latitude,
                position.coords.longitude
            );
        },
        function(error) {
            console.warn('Geolocation error (' + error.code + '): ' + error.message + ' — submitting without coordinates.');
            doSubmit();
        },
        {
            enableHighAccuracy: true,
            timeout: 8000,
            maximumAge: 0
        }
    );
}


// =============================================================
// SIGNATURE PAD
// Moved from Page 5 inline JS (v2, Apr 2026).
// Used by: Page 5 (authSignaturePad, acceptSignaturePad)
//          Page 10 (monitorSignaturePad)
// =============================================================

/**
 * SignaturePad(canvas, ctx)
 * Lightweight canvas-based signature capture class.
 * Handles mouse and touch events. No external library required.
 */
function SignaturePad(canvas, ctx) {
    this.canvas  = canvas;
    this.ctx     = ctx;
    this.drawing = false;
    this.isEmpty = true;

    this.ctx.strokeStyle = '#000000';
    this.ctx.lineWidth   = 2;
    this.ctx.lineCap     = 'round';
    this.ctx.lineJoin    = 'round';

    this.canvas.addEventListener('mousedown',  (e) => this.startDrawing(e));
    this.canvas.addEventListener('mousemove',  (e) => this.draw(e));
    this.canvas.addEventListener('mouseup',    ()  => this.stopDrawing());
    this.canvas.addEventListener('mouseout',   ()  => this.stopDrawing());

    this.canvas.addEventListener('touchstart', (e) => { e.preventDefault(); this.startDrawing(e.touches[0]); }, { passive: false });
    this.canvas.addEventListener('touchmove',  (e) => { e.preventDefault(); this.draw(e.touches[0]); },        { passive: false });
    this.canvas.addEventListener('touchend',   ()  => this.stopDrawing());

    this.startDrawing = function(e) {
        this.drawing = true;
        this.isEmpty = false;
        const rect = this.canvas.getBoundingClientRect();
        this.ctx.beginPath();
        this.ctx.moveTo(e.clientX - rect.left, e.clientY - rect.top);
    };

    this.draw = function(e) {
        if (!this.drawing) return;
        const rect = this.canvas.getBoundingClientRect();
        this.ctx.lineTo(e.clientX - rect.left, e.clientY - rect.top);
        this.ctx.stroke();
    };

    this.stopDrawing = function() {
        this.drawing = false;
    };

    this.clear = function() {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
        this.isEmpty = true;
    };

    this.toDataURL = function(type) {
        return this.canvas.toDataURL(type || 'image/png');
    };

    // Legacy alias used by some existing DA code
    this.getDataURL = function() {
        return this.isEmpty ? '' : this.toDataURL('image/png');
    };
}

/**
 * initPad(canvasId, itemName, callback)
 * Initialise a SignaturePad on the given canvas element.
 * Sizes canvas to fit its container (responsive).
 * If the APEX hidden item already has a value, loads the
 * saved signature back into the canvas via loadSignature().
 *
 * @param {string}   canvasId  - DOM id of the canvas element
 * @param {string}   itemName  - APEX page item name holding base64 data URL
 * @param {function} callback  - receives the SignaturePad instance
 */
function initPad(canvasId, itemName, callback) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) return;

    const regionBody   = canvas.closest('.t-Region-body') ||
                         canvas.closest('.t-ContentBody') ||
                         canvas.parentElement;
    const displayWidth = regionBody ? regionBody.offsetWidth - 24 : 300;

    const screenWidth   = window.innerWidth;
    const displayHeight = screenWidth < 768 ? 100 : 150;

    // 1:1 pixel ratio — no DPR scaling
    canvas.width  = displayWidth;
    canvas.height = displayHeight;

    canvas.setAttribute('style',
        'width:'  + displayWidth  + 'px !important;' +
        'height:' + displayHeight + 'px !important;' +
        'border: 1px dashed var(--ut-component-border-color, #ccc);' +
        'border-radius: 4px;' +
        'touch-action: none;' +
        'cursor: crosshair;' +
        'display: block;'
    );

    const ctx = canvas.getContext('2d');
    ctx.strokeStyle = '#000000';
    ctx.lineWidth   = 2;
    ctx.lineCap     = 'round';
    ctx.lineJoin    = 'round';

    const pad = new SignaturePad(canvas, ctx);
    callback(pad);

    // Re-display existing signature if item has a value
    const existingSig = $v(itemName);
    if (existingSig) {
        loadSignature(pad, canvas, existingSig);
    }
}

/**
 * loadSignature(pad, canvas, dataUrl)
 * Draw a saved signature (base64 data URL) back onto the canvas.
 * Marks the pad as non-empty so saveSignatures() will capture it.
 *
 * @param {SignaturePad} pad     - the SignaturePad instance
 * @param {HTMLElement}  canvas  - the canvas element
 * @param {string}       dataUrl - full data URL: 'data:image/png;base64,...'
 */
function loadSignature(pad, canvas, dataUrl) {
    if (!dataUrl || !canvas) return;
    const img = new Image();
    img.onload = function() {
        const ctx = canvas.getContext('2d');
        ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
        if (pad) pad.isEmpty = false;
    };
    img.src = dataUrl;
}

/**
 * saveSignatures()
 * Capture all active signature pads on the current page into
 * their corresponding APEX hidden items before page submit.
 *
 * Called by DA Action 10 (before captureLocationThenSubmit).
 *
 * Each page defines its own pad variables and item names —
 * this function checks which ones exist and saves them.
 * Add new pads to the checks below as new pages are built.
 */
function saveSignatures() {
    // Page 5 — Authorisation signature
    if (typeof authSignaturePad !== 'undefined' &&
        authSignaturePad && !authSignaturePad.isEmpty) {
        apex.item('P5_AUTH_SIGNATURE_DATA').setValue(
            authSignaturePad.toDataURL('image/png')
        );
    }
    // Page 5 — Acceptance signature
    if (typeof acceptSignaturePad !== 'undefined' &&
        acceptSignaturePad && !acceptSignaturePad.isEmpty) {
        apex.item('P5_ACCEPT_SIGNATURE_DATA').setValue(
            acceptSignaturePad.toDataURL('image/png')
        );
    }
    // Page 10 — Monitoring signature
    if (typeof monitorSignaturePad !== 'undefined' &&
        monitorSignaturePad && !monitorSignaturePad.isEmpty) {
        apex.item('P10_MONITOR_SIGNATURE_HIDDEN').setValue(
            monitorSignaturePad.toDataURL('image/png')
        );
    }
}

/**
 * ptwShowAuthoriseDeclaration()
 * Shows a site-presence declaration modal before the Authorise submit.
 * Called from Page 5 DA on BTN_AUTHORISE_P5 click.
 */
function ptwShowAuthoriseDeclaration() {

    var modalId = 'ptw-auth-declaration-modal';

    // Remove any stale instance
    $('#' + modalId).remove();

    var modalHtml =
        '<div id="' + modalId + '" role="dialog" aria-modal="true" aria-labelledby="ptw-decl-title" ' +
        '     style="position:fixed;top:0;left:0;width:100%;height:100%;z-index:9999;' +
        '            background:rgba(0,0,0,0.55);display:flex;align-items:center;justify-content:center;">' +
        '  <div style="background:#fff;border-radius:6px;max-width:540px;width:90%;' +
        '              box-shadow:0 8px 32px rgba(0,0,0,0.28);overflow:hidden;">' +

        '    <!-- Header -->' +
        '    <div style="background:#c0392b;padding:16px 20px;display:flex;align-items:center;gap:10px;">' +
        '      <span class="fa fa-clipboard-check" style="color:#fff;font-size:20px;"></span>' +
        '      <span id="ptw-decl-title" style="color:#fff;font-weight:700;font-size:16px;">' +
        '        Authorisation Declaration' +
        '      </span>' +
        '    </div>' +

        '    <!-- Body -->' +
        '    <div style="padding:20px 24px;">' +
        '      <p style="margin:0 0 14px;font-size:14px;line-height:1.6;color:#333;">' +
        '        Before authorising this Permit to Work, you must confirm the following:' +
        '      </p>' +
        '      <div style="background:#fdf3f2;border-left:4px solid #c0392b;padding:14px 16px;' +
        '                  border-radius:0 4px 4px 0;margin-bottom:18px;">' +
        '        <p style="margin:0 0 8px;font-size:13px;line-height:1.6;color:#2c2c2c;">' +
        '          <strong>Site Presence Declaration</strong>' +
        '        </p>' +
        '        <p style="margin:0;font-size:13px;line-height:1.7;color:#2c2c2c;">' +
        '          I confirm that I am physically present at the site identified on this permit, ' +
        '          that I have inspected the work area, that I am satisfied the work described can ' +
        '          be carried out safely, and that the personnel employed on this task are properly ' +
        '          equipped, competent, and understand the relevant safety and emergency procedures.' +
        '        </p>' +
        '      </div>' +
        '      <label style="display:flex;align-items:flex-start;gap:10px;cursor:pointer;' +
        '                    font-size:13px;color:#333;line-height:1.5;">' +
        '        <input type="checkbox" id="ptw-decl-checkbox" ' +
        '               style="margin-top:3px;width:16px;height:16px;flex-shrink:0;cursor:pointer;" />' +
        '        <span>I have read and understood this declaration and confirm that all statements ' +
        '              above are true and accurate at the time of authorisation.</span>' +
        '      </label>' +
        '    </div>' +

        '    <!-- Footer -->' +
        '    <div style="padding:14px 24px 20px;display:flex;justify-content:flex-end;gap:10px;' +
        '                border-top:1px solid #eee;">' +
        '      <button id="ptw-decl-cancel" type="button" ' +
        '              style="padding:8px 20px;border:1px solid #ccc;background:#fff;' +
        '                     border-radius:4px;cursor:pointer;font-size:13px;color:#555;">' +
        '        Cancel' +
        '      </button>' +
        '      <button id="ptw-decl-confirm" type="button" disabled ' +
        '              style="padding:8px 20px;border:none;background:#c0392b;color:#fff;' +
        '                     border-radius:4px;cursor:not-allowed;font-size:13px;' +
        '                     opacity:0.5;font-weight:600;">' +
        '        <span class="fa fa-clipboard-check"></span>&nbsp;Confirm &amp; Authorise' +
        '      </button>' +
        '    </div>' +

        '  </div>' +
        '</div>';

    $('body').append(modalHtml);

    // Checkbox enables/disables the Confirm button
    $('#ptw-decl-checkbox').on('change', function () {
        var checked = $(this).is(':checked');
        $('#ptw-decl-confirm')
            .prop('disabled', !checked)
            .css({
                'opacity'       : checked ? '1'            : '0.5',
                'cursor'        : checked ? 'pointer'      : 'not-allowed',
                'background'    : checked ? '#c0392b'      : '#c0392b'
            });
    });

    // Cancel — close modal, do nothing
    $('#ptw-decl-cancel').on('click', function () {
        $('#' + modalId).remove();
    });

    // Close on backdrop click
    $('#' + modalId).on('click', function (e) {
        if (e.target === this) {
            $('#' + modalId).remove();
        }
    });

    // Escape key closes
    $(document).one('keydown.ptw-decl', function (e) {
        if (e.key === 'Escape') {
            $('#' + modalId).remove();
        }
    });

    // Confirm — proceed with save and submit
    $('#ptw-decl-confirm').on('click', function () {
        $('#' + modalId).remove();
        saveSignatures();
        captureLocationThenSubmit('AUTHORISE');
    });
}

// =============================================================
// SESSION TIMEOUT GUARD
// Flushes offline queue and saves signatures before the APEX
// session timeout dialog redirects to login.
// Relies on APEX built-in apexbeforelogout / apexwindowunload
// events. Called automatically — no page-level wiring needed
// as ptw-utils.js loads globally via Page 0.
// =============================================================

(function () {
    'use strict';

    function ptwFlushBeforeTimeout() {
        // 1. Save signatures if on a page that has them
        if (typeof saveSignatures === 'function') {
            try { saveSignatures(); } catch (e) { /* ignore */ }
        }

        // 2. Flush any pending offline records
        if (window.OfflineStorage && typeof OfflineStorage.syncIfOnline === 'function') {
            try { OfflineStorage.syncIfOnline(); } catch (e) { /* ignore */ }
        }
    }

    // APEX fires this before session expiry redirect
    $(window).on('apexwindowunload', function () {
        ptwFlushBeforeTimeout();
    });

    // Belt-and-braces: also fires on tab close / navigate away
    window.addEventListener('beforeunload', function () {
        ptwFlushBeforeTimeout();
    });

}());
