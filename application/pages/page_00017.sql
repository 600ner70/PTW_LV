prompt --application/pages/page_00017
begin
--   Manifest
--     PAGE: 00017
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.16'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_page.create_page(
 p_id=>17
,p_name=>'Cancel Permit'
,p_alias=>'CANCEL-PERMIT'
,p_page_mode=>'MODAL'
,p_step_title=>'Cancel Permit'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var p17SigPad = null;',
'',
'function p17InitSig() {',
'    var canvas = document.getElementById(''p17SigCanvas'');',
'    if (!canvas) return;',
'    var wrapper = canvas.parentElement;',
'    var w = Math.max((wrapper ? wrapper.offsetWidth - 24 : 400), 280);',
'    canvas.width  = w;',
'    canvas.height = 150;',
'    canvas.style.width  = w + ''px'';',
'    canvas.style.height = ''150px'';',
'    var ctx = canvas.getContext(''2d'');',
'    ctx.strokeStyle = ''#000000'';',
'    ctx.lineWidth   = 2;',
'    ctx.lineCap     = ''round'';',
'    ctx.lineJoin    = ''round'';',
'    p17SigPad = new SignaturePad(canvas, ctx);',
'}',
'',
'function p17ClearSig() {',
'    if (p17SigPad) { p17SigPad.clear(); }',
'}',
'',
'function p17SaveSig() {',
'    if (!p17SigPad || p17SigPad.isEmpty) {',
'        apex.item(''P17_CANCEL_SIGNATURE_DATA'').setValue('''');',
'    } else {',
'        apex.item(''P17_CANCEL_SIGNATURE_DATA'').setValue(p17SigPad.getDataURL());',
'    }',
'}',
'',
'function p17LockCanvas() {',
'    var canvas = document.getElementById(''p17SigCanvas'');',
'    if (!canvas) return;',
'    canvas.style.pointerEvents   = ''none'';',
'    canvas.style.opacity         = ''0.85'';',
'    canvas.style.cursor          = ''not-allowed'';',
'    canvas.style.backgroundColor = ''#ffffff'';',
'    canvas.title                 = ''Signature is locked'';',
'}',
'',
'function p17TogglePhotoRequirement() {',
'    var workStatus  = apex.item(''P17_CANCEL_WORK_COMPLETE'').getValue();',
'    var warning     = document.getElementById(''p17-photo-warning'');',
'    var uploadArea  = document.getElementById(''p17-photo-upload-area'');',
'    var sigRegion   = document.getElementById(''p17-signature-region'');',
'    var photoRegion = document.getElementById(''p17-photo-region'');',
'',
'    if (workStatus === ''N'') {',
'        if (photoRegion) photoRegion.style.display = '''';',
'        if (warning)     warning.style.display     = ''block'';',
'        if (uploadArea)  uploadArea.style.display  = ''block'';',
'        var uploaded = apex.item(''P17_AREA_PHOTO_UPLOADED'').getValue();',
'        if (sigRegion) {',
'            sigRegion.style.display = (uploaded === ''Y'') ? '''' : ''none'';',
'        }',
'    } else {',
'        if (photoRegion) photoRegion.style.display = ''none'';',
'        if (sigRegion)   sigRegion.style.display   = '''';',
'    }',
'}',
'',
unistr('// \2500\2500 File type helpers (copied from Page 4) \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'function ptwGetFileCategory(mimeType, fileName) {',
'    var ext = (fileName || '''').split(''.'').pop().toLowerCase();',
'    if (mimeType && mimeType.startsWith(''image/''))               return ''image'';',
'    if (mimeType === ''application/pdf'')                          return ''pdf'';',
'    if (mimeType && (mimeType.indexOf(''word'')     > -1 ||',
'                     mimeType.indexOf(''document'') > -1))         return ''word'';',
'    if (mimeType && (mimeType.indexOf(''sheet'')    > -1 ||',
'                     mimeType.indexOf(''excel'')    > -1))         return ''excel'';',
'    if ([''jpg'',''jpeg'',''png'',''gif'',''webp''].indexOf(ext) > -1)     return ''image'';',
'    if (ext === ''pdf'')                                           return ''pdf'';',
'    if ([''doc'',''docx''].indexOf(ext) > -1)                        return ''word'';',
'    if ([''xls'',''xlsx''].indexOf(ext) > -1)                        return ''excel'';',
'    return ''other'';',
'}',
'',
'function ptwFileIcon(category) {',
'    var icons = {',
'        pdf:   ''<div class="ptw-file-icon icon-pdf"><span class="fa fa-file-pdf-o"></span></div>'',',
'        word:  ''<div class="ptw-file-icon icon-word"><span class="fa fa-file-word-o"></span></div>'',',
'        excel: ''<div class="ptw-file-icon icon-excel"><span class="fa fa-file-excel-o"></span></div>'',',
'        other: ''<div class="ptw-file-icon"><span class="fa fa-file-o"></span></div>''',
'    };',
'    return icons[category] || icons.other;',
'}',
'',
'function ptwOpenLightbox(url, caption) {',
'    document.getElementById(''ptw-lightbox-img'').src             = url;',
'    document.getElementById(''ptw-lightbox-caption'').textContent = caption || '''';',
'    document.getElementById(''ptw-lightbox'').style.display       = ''flex'';',
'    document.body.style.overflow                                 = ''hidden'';',
'}',
'function ptwCloseLightbox() {',
'    document.getElementById(''ptw-lightbox'').style.display = ''none'';',
'    document.getElementById(''ptw-lightbox-img'').src       = '''';',
'    document.body.style.overflow                          = '''';',
'}',
'document.addEventListener(''keydown'', function(e) {',
'    if (e.key === ''Escape'') ptwCloseLightbox();',
'});',
'',
unistr('// \2500\2500 Upload \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'function p17UploadFile(file) {',
'    var permitId = apex.item(''P17_PERMIT_ID'').getValue();',
'    if (!permitId) {',
'        apex.message.showErrors([{type:''error'',',
'            message:''Permit must be saved before attaching files.''}]);',
'        return;',
'    }',
'    if (file.size > 20 * 1024 * 1024) {',
'        apex.message.showErrors([{type:''error'', message:''File must be less than 20MB.''}]);',
'        return;',
'    }',
'    var allowed     = [''image/jpeg'',''image/png'',''image/gif'',''image/webp''];',
'    var allowedExts = [''jpg'',''jpeg'',''png'',''gif'',''webp''];',
'    var ext         = file.name.split(''.'').pop().toLowerCase();',
'    if (allowed.indexOf(file.type) === -1 && allowedExts.indexOf(ext) === -1) {',
'        apex.message.showErrors([{type:''error'', message:''Images only (JPG, PNG, GIF, WEBP).''}]);',
'        return;',
'    }',
'',
'    var caption  = document.getElementById(''ptw-caption-input'').value;',
'    var spinner$ = apex.util.showSpinner($(''#ptw-photo-gallery''));',
'',
'    var reader = new FileReader();',
'    reader.onload = function(e) {',
'        var b64       = e.target.result.replace(/^data:[^;]+;base64,/, '''');',
'        var f01       = [];',
'        var chunkSize = 30000;',
'        for (var i = 0; i < b64.length; i += chunkSize) {',
'            f01.push(b64.substring(i, i + chunkSize));',
'        }',
'        apex.server.process(''UPLOAD_PERMIT_PHOTO'', {',
'            x01: permitId,',
'            x02: caption,',
'            x03: apex.item(''P0_LATITUDE'').getValue()  || '''',',
'            x04: apex.item(''P0_LONGITUDE'').getValue() || '''',',
'            x05: file.name,',
'            x06: file.type || ''image/jpeg'',',
'            f01: f01',
'        }, {',
'            pageId: 17,',
'            success: function(data) {',
'                spinner$.remove();',
'                if (data.success) {',
'                    apex.message.showPageSuccess(''Photo uploaded successfully.'');',
'                    document.getElementById(''ptw-caption-input'').value              = '''';',
'                    document.getElementById(''ptw-file-input'').value                 = '''';',
'                    document.getElementById(''ptw-camera-input'').value               = '''';',
'                    document.getElementById(''ptw-selected-file-info'').style.display = ''none'';',
'',
'                    // Flag uploaded and reveal signature region',
'                    apex.item(''P17_AREA_PHOTO_UPLOADED'').setValue(''Y'');',
'',
'                    // Re-run toggle to show signature now photo is uploaded',
'                    p17TogglePhotoRequirement();',
'',
'                    // Refresh gallery',
'                    p17LoadPhotos();',
'',
'                } else {',
'                    apex.message.showErrors([{type:''error'', message: data.message}]);',
'                }',
'            },',
'            error: function(xhr, status, error) {',
'                spinner$.remove();',
'                apex.message.showErrors([{type:''error'', message:''Upload failed: '' + error}]);',
'            }',
'        });',
'    };',
'    reader.readAsDataURL(file);',
'}',
'',
'function p17HandleFileSelection(file) {',
'    if (!file) return;',
unistr('    // Show filename and upload button \2014 don''t upload yet'),
'    document.getElementById(''ptw-selected-file-name'').textContent   = file.name;',
'    document.getElementById(''ptw-selected-file-info'').style.display = ''block'';',
'    document.getElementById(''btn-upload-file'').onclick = function() {',
'        p17UploadFile(file);',
'    };',
'}',
'',
unistr('// \2500\2500 Gallery \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'function p17LoadPhotos() {',
'    var permitId = apex.item(''P17_PERMIT_ID'').getValue();',
'    if (!permitId) return;',
'',
'    var isReadOnly = (apex.item(''P17_WORKFLOW_STATUS'').getValue() === ''CANCELLED'');',
'',
'    apex.server.process(''GET_PERMIT_PHOTOS'', { x01: permitId }, {',
'        pageId: 17,',
'        success: function(data) {',
'            var gallery = document.getElementById(''ptw-photo-gallery'');',
'            if (!gallery) return;',
'',
'            if (!data.photos || data.photos.length === 0) {',
'                gallery.innerHTML = ''<p class="ptw-no-photos">No photos attached.</p>'';',
'                return;',
'            }',
'',
'            var html = ''<div class="ptw-photo-grid">'';',
'',
'            data.photos.forEach(function(p) {',
'                var cat = ptwGetFileCategory(p.mimeType, p.fileName);',
'',
'                html += ''<div class="ptw-photo-card" data-photo-id="'' + p.photoId + ''">'';',
'',
'                if (cat === ''image'') {',
'                    html += ''<a href="javascript:void(0)" ''',
'                          + ''onclick="ptwOpenLightbox(\'''' + p.url + ''\'',''',
'                          + ''\'''' + apex.util.escapeHTMLAttr(p.caption || '''') + ''\'')">'';',
'                    html += ''<img src="'' + p.url + ''" ''',
'                          + ''alt="'' + apex.util.escapeHTMLAttr(p.caption || ''Photo'') + ''" ''',
'                          + ''class="ptw-photo-thumb" loading="lazy">'';',
'                    html += ''</a>'';',
'                } else {',
'                    html += ''<a href="'' + p.url + ''" target="_blank" rel="noopener">'';',
'                    html += ptwFileIcon(cat);',
'                    html += ''</a>'';',
'                }',
'',
'                html += ''<div class="ptw-photo-meta">'';',
'                html += ''<span class="ptw-photo-caption">''',
'                      + apex.util.escapeHTML(p.fileName) + ''</span>'';',
'                if (p.caption) {',
'                    html += ''<span class="ptw-photo-caption" style="font-weight:normal;">''',
'                          + apex.util.escapeHTML(p.caption) + ''</span>'';',
'                }',
'                html += ''<span class="ptw-photo-date">'' + p.uploadedDate + ''</span>'';',
'                html += ''<span class="ptw-photo-user">''',
'                      + apex.util.escapeHTML(p.uploadedBy) + ''</span>'';',
'                html += ''</div>'';',
'',
'                if (!isReadOnly) {',
'                    html += ''<button type="button" ''',
'                          + ''class="t-Button t-Button--danger t-Button--slim t-Button--stretch ptw-delete-photo" ''',
'                          + ''data-photo-id="'' + p.photoId + ''" ''',
'                          + ''data-permit-id="'' + permitId + ''">''',
'                          + ''<span class="t-Icon fa fa-trash-o"></span> Delete</button>'';',
'                }',
'',
'                html += ''</div>'';',
'            });',
'',
'            html += ''</div>'';',
'            gallery.innerHTML = html;',
'        },',
'        error: function() {',
'            var gallery = document.getElementById(''ptw-photo-gallery'');',
'            if (gallery) {',
'                gallery.innerHTML = ''<p class="ptw-no-photos">Could not load photos.</p>'';',
'            }',
'        }',
'    });',
'}',
'',
'function p17DeletePhoto(photoId, permitId) {',
'    apex.message.confirm(''Delete this photo? This cannot be undone.'', function(okPressed) {',
'        if (!okPressed) return;',
'        apex.server.process(''DELETE_PERMIT_PHOTO'', { x01: photoId }, {',
'            pageId: 17,',
'            success: function(data) {',
'                if (data.success) {',
'                    apex.message.showPageSuccess(''Photo deleted.'');',
'                    p17LoadPhotos();',
'                } else {',
'                    apex.message.showErrors([{type:''error'', message: data.message}]);',
'                }',
'            },',
'            error: function(xhr, status, error) {',
'                apex.message.showErrors([{type:''error'', message:''Delete failed: '' + error}]);',
'            }',
'        });',
'    });',
'}',
'',
'function p17UpdateDeclaration() {',
'    var workVal = apex.item(''P17_CANCEL_WORK_COMPLETE'').getValue();',
'    var $work   = $(''#p17-decl-work-complete'');',
'',
'    if (workVal === ''Y'') {',
'        $work.text(''completed'').css(''color'', ''#1e7e34'');',
'    } else if (workVal === ''N'') {',
'        $work.text(''not complete'').css(''color'', ''#a71d2a'');',
'    } else {',
'        $work.text(''completed / not complete'').css(''color'', ''#344B5C'');',
'    }',
'}',
'',
'function p17ViewPhoto(photoId, el) {',
'    var container = document.getElementById(''p17-thumb-'' + photoId);',
'    if (!container) return;',
'',
'    // If already loaded, open lightbox',
'    var img = container.querySelector(''img'');',
'    if (img && img.src && img.src.indexOf(''data:'') === 0) {',
'        ptwOpenLightbox(img.src, '''');',
'        return;',
'    }',
'',
'    // Show spinner while loading',
'    container.innerHTML = ''<span class="fa fa-spinner fa-spin" ''',
'        + ''style="font-size:2rem; color:#aaa;"></span>'';',
'',
'    apex.server.process(''GET_PHOTO_DATA'', { x01: photoId }, {',
'        pageId: 17,',
'        success: function(data) {',
'            if (data.success && data.dataUrl) {',
unistr('                // Reset container styles \2014 remove flex/height that clips img'),
'                container.style.display    = ''block'';',
'                container.style.height     = ''auto'';',
'                container.style.background = ''none'';',
'                container.style.padding    = ''0'';',
'                container.style.cursor     = ''pointer'';',
'',
'                // Render image',
'                container.innerHTML = ''<img src="'' + data.dataUrl + ''" ''',
'                    + ''class="ptw-photo-thumb" ''',
'                    + ''alt="Area photo" ''',
'                    + ''style="width:100%; height:130px; object-fit:cover; display:block;">'';',
'',
'                // Open lightbox immediately',
'                ptwOpenLightbox(data.dataUrl, '''');',
'',
'            } else {',
'                container.style.display         = ''flex'';',
'                container.style.alignItems      = ''center'';',
'                container.style.justifyContent  = ''center'';',
'                container.style.height          = ''130px'';',
'                container.style.background      = ''#f0f4f8'';',
'                container.innerHTML = ''<span class="fa fa-exclamation-circle" ''',
'                    + ''style="font-size:2rem; color:#c0392b;" ''',
'                    + ''title="Could not load image"></span>'';',
'            }',
'        },',
'        error: function() {',
'            container.style.display         = ''flex'';',
'            container.style.alignItems      = ''center'';',
'            container.style.justifyContent  = ''center'';',
'            container.style.height          = ''130px'';',
'            container.style.background      = ''#f0f4f8'';',
'            container.innerHTML = ''<span class="fa fa-exclamation-circle" ''',
'                + ''style="font-size:2rem; color:#c0392b;" ''',
'                + ''title="Load failed"></span>'';',
'        }',
'    });',
'}',
''))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('// \2500\2500 Save sig before submit \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'apex.jQuery(document).on(''apexbeforepagesubmit'', function() {',
'    p17SaveSig();',
'});',
'',
unistr('// \2500\2500 Radio change handlers \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'$(document).on(''change'', ''input[name="P17_CANCEL_WORK_COMPLETE"]'', function() {',
'    p17TogglePhotoRequirement();',
'    setTimeout(p17UpdateDeclaration, 50);',
'});',
'',
unistr('// \2500\2500 File inputs \2014 delegated to handle modal timing \2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'$(document).on(''change'', ''#ptw-file-input'', function() {',
'    if (this.files && this.files[0]) p17HandleFileSelection(this.files[0]);',
'});',
'$(document).on(''change'', ''#ptw-camera-input'', function() {',
'    if (this.files && this.files[0]) p17HandleFileSelection(this.files[0]);',
'});',
'',
unistr('// \2500\2500 Delegated delete handler \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'$(document).on(''click'', ''.ptw-delete-photo'', function(e) {',
'    e.preventDefault();',
'    e.stopPropagation();',
'    p17DeletePhoto($(this).data(''photo-id''), $(this).data(''permit-id''));',
'});',
'',
unistr('// \2500\2500 Main init inside setTimeout \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'setTimeout(function() {',
'',
unistr('    // Read status here \2014 guaranteed available'),
'    var p17Status  = apex.item(''P17_WORKFLOW_STATUS'').getValue();',
'    var isReadOnly = (p17Status === ''CANCELLED'');',
'',
'    // Initialise signature pad',
'    p17InitSig();',
'    if (p17SigPad) { p17SigPad.clear(); }',
'',
'    // Load existing signature',
'    var sigItem     = document.querySelector(''input[name="P17_CANCEL_SIGNATURE_DATA_URL"]'');',
'    var existingSig = sigItem ? sigItem.value : null;',
'',
'    if (existingSig) {',
'        var sigCanvas = document.getElementById(''p17SigCanvas'');',
'        loadSignature(p17SigPad, sigCanvas, existingSig);',
'    }',
'',
'    // Update declaration text',
'    p17UpdateDeclaration();',
'',
'    if (isReadOnly) {',
'',
'        // Lock canvas',
'        var canvas = document.getElementById(''p17SigCanvas'');',
'        if (canvas) {',
'            canvas.style.pointerEvents  = ''none'';',
'            canvas.style.opacity        = ''0.85'';',
'            canvas.style.cursor         = ''not-allowed'';',
'            canvas.title                = ''Signature locked'';',
'        }',
'',
'        // Hide clear sig button',
'        var clearBtn = document.getElementById(''p17-clear-sig-btn'');',
'        if (clearBtn) clearBtn.style.display = ''none'';',
'',
'        // Disable form items',
'        apex.item(''P17_CANCEL_WORK_COMPLETE'').disable();',
'        apex.item(''P17_CANCEL_PERSON_NAME'').disable();',
'',
'        // Disable native radio inputs underlying badges',
'        $(''input[name="P17_CANCEL_WORK_COMPLETE"]'').prop(''disabled'', true);',
'',
'        // Hide required indicator',
'        $(''#P17_CANCEL_PERSON_NAME'')',
'            .closest(''.t-Form-fieldContainer'')',
'            .find(''.t-Form-required'').hide();',
'',
'        // Hide submit button',
'        $(''#BTN_CANCEL_PERMIT_P17'').hide();',
'',
'        // Show readonly banner',
'        var banner = document.getElementById(''p17-readonly-banner'');',
'        if (banner) banner.style.display = ''block'';',
'',
'        // Show area photo if work was not complete',
'        var workStatus  = apex.item(''P17_CANCEL_WORK_COMPLETE'').getValue();',
'        var photoRegion = document.getElementById(''p17-photo-region'');',
'',
'        if (workStatus === ''N'') {',
'            if (photoRegion) photoRegion.style.display = '''';',
'',
'            // Hide upload controls in readonly',
'            var uploadControls = document.querySelector(''.ptw-upload-controls'');',
'            if (uploadControls) uploadControls.style.display = ''none'';',
'',
'            p17LoadPhotos();',
'',
'        } else {',
'            if (photoRegion) photoRegion.style.display = ''none'';',
'        }',
'',
'    } else {',
'',
unistr('        // Entry mode \2014 show/hide photo region based on work status'),
'        var photoRegion = document.getElementById(''p17-photo-region'');',
'        if (photoRegion) photoRegion.style.display = ''none'';',
'        p17TogglePhotoRequirement();',
'',
'        // Load gallery in case photos already exist this session',
'        p17LoadPhotos();',
'',
'    }',
'',
'    // Binary Y/N badges',
'    (function() {',
'        var BINARY_ITEMS = [''P17_CANCEL_WORK_COMPLETE''];',
'        var BADGES = [',
unistr('            { val: ''Y'', cls: ''binary-badge-yes'', label: ''\2713'' },'),
unistr('            { val: ''N'', cls: ''binary-badge-no'',  label: ''\2717'' }'),
'        ];',
'',
'        BINARY_ITEMS.forEach(function(itemName) {',
'            var $fc = $(''#'' + itemName).closest(''.t-Form-fieldContainer'');',
'            if ($fc.length === 0) return;',
'',
'            $fc.find(''.binary-badge-row'').remove();',
'',
'            var currentVal = isReadOnly',
'                ? (apex.item(itemName).getValue() || '''')',
'                : ($(''input[name="'' + itemName + ''"]:checked'').val() || '''');',
'',
'            var $row = $(''<div class="binary-badge-row"></div>'')',
'                .attr(''data-item'', itemName);',
'',
'            BADGES.forEach(function(b) {',
'                $(''<span></span>'')',
'                    .addClass(''binary-badge '' + b.cls)',
'                    .toggleClass(''cm-active'',       currentVal === b.val)',
'                    .toggleClass(''binary-readonly'',  isReadOnly)',
'                    .attr(''data-value'', b.val)',
'                    .text(b.label)',
'                    .appendTo($row);',
'            });',
'',
'            $fc.find(''.t-Form-inputContainer'').append($row);',
'        });',
'',
'        $(''.cm-binary-item .apex-item-grid'').hide();',
'',
'        $(document)',
'            .off(''click.binarybadge'')',
'            .on(''click.binarybadge'', ''.binary-badge:not(.binary-readonly)'', function() {',
'                var $badge   = $(this);',
'                var $row     = $badge.closest(''.binary-badge-row'');',
'                var itemName = $row.attr(''data-item'');',
'                var val      = $badge.attr(''data-value'');',
'',
'                $(''input[name="'' + itemName + ''"][value="'' + val + ''"]'')',
'                    .prop(''checked'', true).trigger(''change'');',
'',
'                $row.find(''.binary-badge'').removeClass(''cm-active'');',
'                $badge.addClass(''cm-active'');',
'            });',
'    }());',
'',
'}, 350);',
'',
unistr('// \2500\2500 Required star \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'apex.jQuery(document).on(''apexreadyend'', function() {',
'    var $fc = $(''#P17_CANCEL_WORK_COMPLETE'').closest(''.t-Form-fieldContainer'');',
'    if ($fc.length === 0) return;',
'    $fc.find(''.t-Form-labelContainer label'').first()',
'       .append(''<span class="cm-required-star" aria-hidden="true"> *</span>'');',
'});'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.p17-declaration-box {',
'    background: #fff8e1;',
'    border-left: 4px solid #f59c00;',
'    padding: 16px 20px;',
'    border-radius: 4px;',
'    font-size: 14px;',
'    line-height: 1.7;',
'    margin-bottom: 4px;',
'}',
'.p17-declaration-box strong { color: #344B5C; }',
'',
'.p17-sig-wrapper canvas {',
'    display: block;',
'    border: 1px dashed var(--ut-component-border-color, #ccc);',
'    border-radius: 4px;',
'    touch-action: none;',
'    cursor: crosshair;',
'    background: #fff;',
'}',
'',
'.ptw-photo-grid {',
'    display: grid;',
'    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));',
'    gap: 1rem;',
'    padding: 0.5rem 0;',
'}',
'.ptw-photo-card {',
'    border: 1px solid var(--ut-component-border-color, #e0e0e0);',
'    border-radius: 8px;',
'    overflow: hidden;',
'    background: var(--ut-component-background-color, #fff);',
'    display: flex;',
'    flex-direction: column;',
'}',
'.ptw-photo-thumb {',
'    width: 100%;',
'    height: 130px;',
'    object-fit: cover;',
'    display: block;',
'    transition: opacity 0.2s;',
'}',
'.ptw-photo-thumb:hover { opacity: 0.82; }',
'.ptw-photo-meta {',
'    padding: 0.4rem 0.6rem;',
'    font-size: 0.75rem;',
'    color: var(--ut-component-font-color-muted, #666);',
'    display: flex;',
'    flex-direction: column;',
'    gap: 2px;',
'    flex: 1;',
'}',
'.ptw-photo-caption { font-weight: 600; color: var(--ut-component-font-color, #333); font-size: 0.8rem; }',
'.ptw-photo-date    { font-size: 0.7rem; }',
'.ptw-photo-user    { font-size: 0.7rem; font-style: italic; }',
'.ptw-delete-photo  { margin: 0.4rem; font-size: 0.75rem !important; }',
'.ptw-no-photos     { color: var(--ut-component-font-color-muted, #888); font-style: italic; padding: 0.5rem 0; margin: 0; }',
'.ptw-file-icon     { display: flex; align-items: center; justify-content: center; height: 130px; font-size: 3rem; background: #f0f4f8; color: #4A5568; }',
'.ptw-file-icon.icon-pdf   { color: #C0392B; }',
'.ptw-file-icon.icon-word  { color: #1F4E79; }',
'.ptw-file-icon.icon-excel { color: #1E7A4E; }',
'.ptw-upload-row { display: flex; gap: 0.6rem; flex-wrap: wrap; }',
'.ptw-upload-row .t-Button { flex: 1; min-width: 130px; }',
'#ptw-lightbox {',
'    position: fixed; inset: 0; background: rgba(0,0,0,0.88);',
'    z-index: 9999; display: flex; align-items: center;',
'    justify-content: center; padding: 1rem;',
'}',
'#ptw-lightbox-inner {',
'    position: relative; max-width: 95vw; max-height: 90vh;',
'    display: flex; flex-direction: column; align-items: center;',
'}',
'#ptw-lightbox-close {',
'    position: absolute; top: -2.5rem; right: 0;',
'    background: none; border: none; color: #fff;',
'    font-size: 1.8rem; cursor: pointer; padding: 0.25rem 0.5rem; line-height: 1;',
'}',
'#ptw-lightbox-img { max-width: 100%; max-height: 80vh; border-radius: 4px; object-fit: contain; }',
'#ptw-lightbox-caption { color: #ddd; margin-top: 0.5rem; font-size: 0.9rem; text-align: center; }',
'@media (max-width: 420px) { .ptw-photo-grid { grid-template-columns: 1fr 1fr; } }',
'',
'.ptw-photo-placeholder {',
'    min-height: 130px;',
'}',
'',
'.ptw-photo-placeholder img {',
'    width: 100% !important;',
'    height: 130px !important;',
'    object-fit: cover !important;',
'    display: block !important;',
'    border-radius: 4px 4px 0 0;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(30177956100539874)
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(47749327162890015)
,p_plug_name=>'Permit Info Banner'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>100
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--info t-Alert--horizontal p17-cancel-banner" role="region" style="margin-bottom:8px;">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon">',
'      <span class="t-Icon fa fa-ban" aria-hidden="true"></span>',
'    </div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-header">',
'        <h2 class="t-Alert-title">Cancellation of Permit to Work</h2>',
'      </div>',
'      <div class="t-Alert-body">',
'        Permit: <strong>&P17_PERMIT_NUMBER.</strong>',
'      </div>',
'    </div>',
'  </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(47749474592890016)
,p_plug_name=>'Declaration'
,p_title=>'Declaration'
,p_icon_css_classes=>'fa-file-text-o'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>110
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="p17-declaration-box">',
'    <p style="margin:0 0 8px 0;">',
'        I confirm that these works have been',
'        <strong><span id="p17-decl-work-complete">completed / not complete</span></strong>',
'        and that I have checked that the place of work has been left in a',
'        safe and tidy condition. Where the work is not complete a further',
'        Permit may be required.',
'    </p>',
'    <p style="margin:0;">',
'        Both the Original and copy of this Permit to Work must be signed',
'        by the Authorised Person when cancelling this Permit.',
'    </p>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(47749512874890017)
,p_plug_name=>'Cancellation Details'
,p_title=>'Cancellation Details'
,p_icon_css_classes=>'fa-user-circle'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>120
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(47749957235890021)
,p_plug_name=>'Signature'
,p_title=>'Authorised Person Signature'
,p_region_name=>'p17-signature-region'
,p_icon_css_classes=>'fa-pencil-square-o'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>140
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="p17-sig-wrapper">',
'    <canvas id="p17SigCanvas"></canvas>',
'</div>',
'<div style="margin-top:8px;">',
'    <button type="button"',
'            class="t-Button t-Button--small"',
'            onclick="p17ClearSig();">',
'        <span class="t-Icon fa fa-eraser"></span> Clear Signature',
'    </button>',
'</div>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(47750040795890022)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>150
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(47751998134890041)
,p_plug_name=>'Area Photo'
,p_title=>'Area Photo'
,p_region_name=>'p17-photo-region'
,p_icon_css_classes=>'fa-camera'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>130
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<!-- Hidden file inputs -->',
'<input type="file"',
'       id="ptw-file-input"',
'       accept=".jpg,.jpeg,.png,.gif,.webp"',
'       style="display:none">',
'',
'<input type="file"',
'       id="ptw-camera-input"',
'       accept="image/*"',
'       capture="environment"',
'       style="display:none">',
'',
'<!-- Workflow status marker for JS -->',
'<span id="ptw-workflow-status"',
'      data-status="&P17_WORKFLOW_STATUS."',
'      style="display:none;"></span>',
'',
'<!-- Upload controls -->',
'<div class="ptw-upload-controls">',
'    <div class="ptw-upload-row">',
'        <button type="button"',
'                id="btn-attach-file"',
'                class="t-Button t-Button--primary t-Button--iconLeft"',
'                onclick="document.getElementById(''ptw-file-input'').click()">',
'            <span class="t-Icon fa fa-paperclip"></span> Attach Photo',
'        </button>',
'        <button type="button"',
'                id="btn-take-photo"',
'                class="t-Button t-Button--primary t-Button--iconLeft"',
'                onclick="document.getElementById(''ptw-camera-input'').click()">',
'            <span class="t-Icon fa fa-camera"></span> Take Photo',
'        </button>',
'    </div>',
'',
'    <div class="ptw-caption-row" style="margin-top:0.5rem;">',
'        <input type="text"',
'               id="ptw-caption-input"',
'               class="apex-item-text"',
'               placeholder="Caption / description (optional)"',
'               maxlength="500"',
'               style="width:100%;">',
'    </div>',
'',
'    <div id="ptw-selected-file-info" style="display:none; margin-top:0.4rem;">',
'        <span class="t-Icon fa fa-file-o"></span>',
'        <span id="ptw-selected-file-name" style="font-size:0.85rem; color:#555;"></span>',
'        <button type="button"',
'                id="btn-upload-file"',
'                class="t-Button t-Button--hot t-Button--slim t-Button--iconLeft"',
'                style="margin-left:0.75rem;">',
'            <span class="t-Icon fa fa-upload"></span> Upload',
'        </button>',
'    </div>',
'</div>',
'',
'<hr style="margin: 1rem 0; border-color: #e0e0e0;">',
'',
'<!-- Gallery -->',
'<div id="ptw-photo-gallery">',
'    <p class="ptw-no-photos">Loading files...</p>',
'</div>',
'',
'<!-- Lightbox -->',
'<div id="ptw-lightbox" style="display:none;"',
'     onclick="if(event.target===this)ptwCloseLightbox()">',
'    <div id="ptw-lightbox-inner">',
'        <button type="button"',
'                id="ptw-lightbox-close"',
'                onclick="ptwCloseLightbox()"',
'                aria-label="Close">',
'            <span class="fa fa-times"></span>',
'        </button>',
'        <img id="ptw-lightbox-img" src="" alt="Photo preview">',
'        <div id="ptw-lightbox-caption"></div>',
'    </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(47750408723890026)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(47750040795890022)
,p_button_name=>'CANCEL_PERMIT'
,p_button_static_id=>'BTN_CANCEL_PERMIT_P17'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Cancel Permit'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-ban'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(47750138528890023)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(47750040795890022)
,p_button_name=>'CANCEL'
,p_button_static_id=>'BTN_CANCEL_P17'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(47751744369890039)
,p_branch_name=>'Navigate back to Dashboard'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_branch_condition=>'P17_CANCELLED'
,p_branch_condition_text=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(47748966673890011)
,p_name=>'P17_PERMIT_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(47749009218890012)
,p_name=>'P17_PERMIT_NUMBER'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(47749159685890013)
,p_name=>'P17_CANCEL_SIGNATURE_DATA'
,p_item_sequence=>50
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(47749214391890014)
,p_name=>'P17_CANCELLED'
,p_item_sequence=>90
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(47749630284890018)
,p_name=>'P17_CANCEL_WORK_COMPLETE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(47749512874890017)
,p_prompt=>'Works Status'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Completed;Y,Not Complete;N'
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(47749787786890019)
,p_name=>'P17_CANCEL_PERSON_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(47749512874890017)
,p_prompt=>'Authorised Person Name'
,p_placeholder=>'Full name (print clearly)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_colspan=>6
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(47749882578890020)
,p_name=>'P17_CANCEL_DATETIME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(47749512874890017)
,p_item_default=>'TO_CHAR(SYSDATE, ''DD-MON-YYYY HH24:MI'')'
,p_item_default_type=>'EXPRESSION'
,p_item_default_language=>'PLSQL'
,p_prompt=>'Date / Time'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(47751346756890035)
,p_name=>'P17_WORKFLOW_STATUS'
,p_item_sequence=>80
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(47751532313890037)
,p_name=>'P17_CANCEL_SIGNATURE_DATA_URL'
,p_item_sequence=>60
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(47751839324890040)
,p_name=>'P17_AREA_PHOTO_UPLOADED'
,p_item_sequence=>70
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(47750760220890029)
,p_validation_name=>'Work Status Required'
,p_validation_sequence=>10
,p_validation=>'P17_CANCEL_WORK_COMPLETE'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Please indicate whether the works are completed  or not complete.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(47750881002890030)
,p_validation_name=>'Person Name Required'
,p_validation_sequence=>20
,p_validation=>'P17_CANCEL_PERSON_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Name of Authorised Person is required.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(47750983222890031)
,p_validation_name=>'Signature Required'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'RETURN NOT (',
'    :P17_CANCEL_SIGNATURE_DATA IS NULL',
'    OR TRIM(:P17_CANCEL_SIGNATURE_DATA) IS NULL',
'    OR :P17_CANCEL_SIGNATURE_DATA = ''data:,''',
');'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'A signature is required to cancel this permit.'
,p_when_button_pressed=>wwv_flow_imp.id(47750408723890026)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(47751088513890032)
,p_validation_name=>'Permit Still Valid for Cancellation'
,p_validation_sequence=>40
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_count NUMBER;',
'BEGIN',
'    SELECT COUNT(*)',
'    INTO   l_count',
'    FROM   ptw_pro.ptw_lv_permits',
'    WHERE  permit_id       = :P17_PERMIT_ID',
'    AND    workflow_status NOT IN (''CANCELLED'',''COMPLETED'',''CLEARED'');',
'    IF l_count > 0 THEN',
'      RETURN TRUE;',
'    ELSE',
'      RETURN FALSE;',
'    END IF;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'This permit cannot be cancelled. It may already be cancelled or completed.'
,p_when_button_pressed=>wwv_flow_imp.id(47750408723890026)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(47752380362890045)
,p_validation_name=>'Area Photo Required'
,p_validation_sequence=>50
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'RETURN NOT (',
'    :P17_CANCEL_WORK_COMPLETE = ''N''',
'    AND (',
'        :P17_AREA_PHOTO_UPLOADED IS NULL',
'        OR :P17_AREA_PHOTO_UPLOADED != ''Y''',
'    )',
');'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'A photo of the area is required when works are not complete. Please take or upload a photo before signing off the cancellation.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(47750296407890024)
,p_name=>'Cancel - Close Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(47750138528890023)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(47750373778890025)
,p_event_id=>wwv_flow_imp.id(47750296407890024)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(47750598951890027)
,p_name=>'Cancel Permit - Capture Location and Submit'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(47750408723890026)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(47750676740890028)
,p_event_id=>wwv_flow_imp.id(47750598951890027)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'captureLocationThenSubmit(''CANCEL_PERMIT'');'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(47751164940890033)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Cancel Permit'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_sig_blob BLOB;',
'',
'    FUNCTION base64_to_blob(p_base64 CLOB) RETURN BLOB IS',
'        v_blob BLOB;',
'        v_clob CLOB;',
'    BEGIN',
'        IF p_base64 IS NULL THEN RETURN NULL; END IF;',
'        v_clob := REGEXP_REPLACE(p_base64, ''^data:image/[^;]+;base64,'', '''');',
'        v_blob := apex_web_service.clobbase642blob(v_clob);',
'        RETURN v_blob;',
'    END base64_to_blob;',
'',
'BEGIN',
'    v_sig_blob := base64_to_blob(:P17_CANCEL_SIGNATURE_DATA);',
'',
'    UPDATE ptw_pro.ptw_lv_permits',
'    SET    cancel_work_complete    = :P17_CANCEL_WORK_COMPLETE,',
'           cancel_person_name     = UPPER(TRIM(:P17_CANCEL_PERSON_NAME)),',
'           cancel_person_signature = v_sig_blob,',
'           cancel_datetime        = SYSDATE,',
'           cancel_latitude        = :APP_LATITUDE,',
'           cancel_longitude       = :APP_LONGITUDE,',
'           workflow_status        = ''CANCELLED'',',
'           current_step           = ''CANCELLED'',',
'           completion_date        = SYSDATE,',
'           modified_by            = NVL(V(''APP_USER''), USER),',
'           modified_date          = CURRENT_TIMESTAMP',
'    WHERE  permit_id              = :P17_PERMIT_ID',
'    AND    workflow_status NOT IN (''CANCELLED'',''COMPLETED'',''CLEARED'');',
'',
'    IF SQL%ROWCOUNT = 0 THEN',
'        apex_error.add_error(',
'            p_message          => ''Permit could not be cancelled. It may have already ''',
'                               || ''been cancelled or completed. Please refresh the ''',
'                               || ''permits list.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RETURN;',
'    END IF;',
'',
'    :P17_CANCELLED := ''Y'';',
'',
'    COMMIT;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message          => ''Error cancelling permit: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RAISE;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(47750408723890026)
,p_internal_uid=>47751164940890033
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(47751263076890034)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_01=>'P17_CANCELLED'
,p_attribute_02=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P17_CANCELLED'
,p_process_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_process_when2=>'N'
,p_internal_uid=>47751263076890034
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(47751662520890038)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Cancel Permit Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_clob  CLOB;',
'    v_sig   BLOB;',
'    v_count NUMBER;',
'BEGIN',
'    -- Load permit number and workflow status first',
'    SELECT permit_number,',
'           workflow_status',
'    INTO   :P17_PERMIT_NUMBER,',
'           :P17_WORKFLOW_STATUS',
'    FROM   ptw_pro.ptw_lv_permits',
'    WHERE  permit_id = :P17_PERMIT_ID;',
' ',
'    -- If already cancelled, load the saved cancellation data',
'    -- for readonly display',
'    IF :P17_WORKFLOW_STATUS = ''CANCELLED'' THEN',
' ',
'        SELECT cancel_work_complete,',
'               cancel_person_name,',
'               TO_CHAR(cancel_datetime, ''DD-MON-YYYY HH24:MI''),',
'               cancel_person_signature',
'        INTO   :P17_CANCEL_WORK_COMPLETE,',
'               :P17_CANCEL_PERSON_NAME,',
'               :P17_CANCEL_DATETIME,',
'               v_sig',
'        FROM   ptw_pro.ptw_lv_permits',
'        WHERE  permit_id = :P17_PERMIT_ID;',
' ',
'        -- Convert signature BLOB to base64 data URL for canvas display',
'        -- Same pattern as Page 10 Load Monitoring Data process',
'        IF v_sig IS NOT NULL',
'           AND DBMS_LOB.GETLENGTH(v_sig) > 0',
'        THEN',
'            v_clob := apex_web_service.blob2clobbase64(v_sig);',
'            -- Strip newlines introduced by base64 encoding',
'            v_clob := REPLACE(REPLACE(v_clob, CHR(13), ''''), CHR(10), '''');',
'            -- Truncate to 32k for session state (sufficient for sig PNG)',
'            :P17_CANCEL_SIGNATURE_DATA_URL :=',
'                ''data:image/png;base64,'' || DBMS_LOB.SUBSTR(v_clob, 32000, 1);',
'        ELSE',
'            :P17_CANCEL_SIGNATURE_DATA_URL := NULL;',
'        END IF;',
' ',
'    ELSE',
unistr('        -- Not yet cancelled \2014 new entry mode'),
'        -- Pre-fill datetime display to NOW',
'        :P17_CANCEL_DATETIME := TO_CHAR(SYSDATE, ''DD-MON-YYYY HH24:MI'');',
'        :P17_CANCEL_SIGNATURE_DATA_URL := NULL;',
' ',
'    END IF;',
' ',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        apex_error.add_error(',
'            p_message          => ''Permit not found.'',',
'            p_display_location => apex_error.c_on_error_page',
'        );',
'    WHEN OTHERS THEN',
'        apex_error.add_error(',
'            p_message          => ''Error loading cancellation data: '' || SQLERRM,',
'            p_display_location => apex_error.c_on_error_page',
'        );',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P17_PERMIT_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>47751662520890038
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(47752004439890042)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'UPLOAD_PERMIT_PHOTO'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_permit_id   NUMBER        := TO_NUMBER(apex_application.g_x01);',
'    l_caption     VARCHAR2(500) := apex_application.g_x02;',
'    l_latitude    NUMBER;',
'    l_longitude   NUMBER;',
'    l_file_name   VARCHAR2(255) := apex_application.g_x05;',
'    l_mime_type   VARCHAR2(100) := apex_application.g_x06;',
'    l_b64_clob    CLOB;',
'    l_blob        BLOB;',
'    l_token       VARCHAR2(32767);',
'BEGIN',
'    BEGIN l_latitude  := TO_NUMBER(apex_application.g_x03); EXCEPTION WHEN OTHERS THEN l_latitude  := NULL; END;',
'    BEGIN l_longitude := TO_NUMBER(apex_application.g_x04); EXCEPTION WHEN OTHERS THEN l_longitude := NULL; END;',
'',
'    IF l_permit_id IS NULL THEN',
'        apex_json.open_object;',
'        apex_json.write(''success'', false);',
'        apex_json.write(''message'', ''Invalid permit ID.'');',
'        apex_json.close_object;',
'        RETURN;',
'    END IF;',
'',
'    IF apex_application.g_f01.COUNT = 0 THEN',
'        apex_json.open_object;',
'        apex_json.write(''success'', false);',
'        apex_json.write(''message'', ''No file data received.'');',
'        apex_json.close_object;',
'        RETURN;',
'    END IF;',
'',
'    -- Reassemble base64 CLOB from chunked f01 array',
'    DBMS_LOB.CREATETEMPORARY(l_b64_clob, FALSE, DBMS_LOB.SESSION);',
'    FOR i IN 1 .. apex_application.g_f01.COUNT LOOP',
'        l_token := apex_application.g_f01(i);',
'        IF LENGTH(l_token) > 0 THEN',
'            DBMS_LOB.WRITEAPPEND(l_b64_clob, LENGTH(l_token), l_token);',
'        END IF;',
'    END LOOP;',
'',
'    l_blob := apex_web_service.clobbase642blob(l_b64_clob);',
'    DBMS_LOB.FREETEMPORARY(l_b64_clob);',
'',
'    IF DBMS_LOB.GETLENGTH(l_blob) > 20971520 THEN',
'        DBMS_LOB.FREETEMPORARY(l_blob);',
'        apex_json.open_object;',
'        apex_json.write(''success'', false);',
'        apex_json.write(''message'', ''File exceeds the 20MB size limit.'');',
'        apex_json.close_object;',
'        RETURN;',
'    END IF;',
'',
'    INSERT INTO ptw_pro.ptw_lv_permit_photos (',
'        permit_id, photo_data, mime_type, file_name,',
'        photo_caption, photo_latitude, photo_longitude,',
'        uploaded_by, uploaded_date',
'    ) VALUES (',
'        l_permit_id, l_blob,',
'        NVL(l_mime_type, ''application/octet-stream''),',
'        NVL(l_file_name, ''attachment''),',
'        NULLIF(TRIM(l_caption), ''''),',
'        l_latitude, l_longitude,',
'        NVL(V(''APP_USER''), USER),',
'        CURRENT_TIMESTAMP',
'    );',
'',
'    COMMIT;',
'    DBMS_LOB.FREETEMPORARY(l_blob);',
'',
'    apex_json.open_object;',
'    apex_json.write(''success'', true);',
'    apex_json.write(''message'', ''Photo uploaded successfully.'');',
'    apex_json.close_object;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_json.open_object;',
'        apex_json.write(''success'', false);',
'        apex_json.write(''message'', ''Upload error: '' || SQLERRM);',
'        apex_json.close_object;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>47752004439890042
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(47752153706890043)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_PERMIT_PHOTOS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_permit_id NUMBER := TO_NUMBER(apex_application.g_x01);',
'BEGIN',
'    apex_json.open_object;',
'    apex_json.open_array(''photos'');',
'',
'    FOR r IN (',
'        SELECT photo_id,',
'               photo_caption,',
'               file_name,',
'               mime_type,',
'               TO_CHAR(uploaded_date, ''DD-Mon-YYYY HH24:MI'') AS uploaded_date,',
'               uploaded_by',
'        FROM   ptw_pro.ptw_lv_permit_photos',
'        WHERE  permit_id = l_permit_id',
'        ORDER  BY uploaded_date DESC',
'    ) LOOP',
'        apex_json.open_object;',
'        apex_json.write(''photoId'',      r.photo_id);',
'        apex_json.write(''caption'',      NVL(r.photo_caption, ''''));',
'        apex_json.write(''fileName'',     NVL(r.file_name, ''attachment''));',
'        apex_json.write(''mimeType'',     NVL(r.mime_type, ''application/octet-stream''));',
'        apex_json.write(''uploadedDate'', r.uploaded_date);',
'        apex_json.write(''uploadedBy'',   r.uploaded_by);',
'        apex_json.write(''url'',',
'            apex_page.get_url(',
'                p_page   => 20,',
'                p_items  => ''P20_PHOTO_ID'',',
'                p_values => r.photo_id,',
'                p_plain_url => true',
'            )',
'        );',
'        apex_json.close_object;',
'    END LOOP;',
'',
'    apex_json.close_array;',
'    apex_json.close_object;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_json.open_object;',
'        apex_json.open_array(''photos'');',
'        apex_json.close_array;',
'        apex_json.write(''error'', SQLERRM);',
'        apex_json.close_object;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>47752153706890043
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(47752296176890044)
,p_process_sequence=>30
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'DELETE_PERMIT_PHOTO'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_photo_id   NUMBER        := TO_NUMBER(apex_application.g_x01);',
'    l_app_user   VARCHAR2(255) := NVL(V(''APP_USER''), USER);',
'    l_can_delete NUMBER;',
'BEGIN',
'    SELECT COUNT(*)',
'    INTO   l_can_delete',
'    FROM   ptw_pro.ptw_lv_permit_photos ph',
'    WHERE  ph.photo_id = l_photo_id',
'    AND    (',
'               UPPER(ph.uploaded_by) = UPPER(l_app_user)',
'               OR EXISTS (',
'                   SELECT 1',
'                   FROM   ptw_pro.ptw_lv_user_roles_v',
'                   WHERE  UPPER(username) = UPPER(l_app_user)',
'                   AND    role_name IN (''ADMIN'', ''ADMIN_CONTRACT_SUPPORT'')',
'                   AND    is_active = ''Y''',
'               )',
'           );',
'',
'    IF l_can_delete = 0 THEN',
'        apex_json.open_object;',
'        apex_json.write(''success'', false);',
'        apex_json.write(''message'', ''File not found or you do not have permission to delete it.'');',
'        apex_json.close_object;',
'        RETURN;',
'    END IF;',
'',
'    DELETE FROM ptw_pro.ptw_lv_permit_photos',
'    WHERE  photo_id = l_photo_id;',
'',
'    COMMIT;',
'',
'    apex_json.open_object;',
'    apex_json.write(''success'', true);',
'    apex_json.close_object;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_json.open_object;',
'        apex_json.write(''success'', false);',
'        apex_json.write(''message'', ''Delete error: '' || SQLERRM);',
'        apex_json.close_object;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>47752296176890044
);
wwv_flow_imp.component_end;
end;
/
