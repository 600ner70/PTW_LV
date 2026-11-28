prompt --application/pages/page_00030
begin
--   Manifest
--     PAGE: 00030
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.6'
,p_default_workspace_id=>11608532912323752
,p_default_application_id=>105
,p_default_id_offset=>0
,p_default_owner=>'PTW_PRO'
);
wwv_flow_imp_page.create_page(
 p_id=>30
,p_name=>'Monitoring Concern'
,p_alias=>'MONITORING-CONCERN'
,p_page_mode=>'MODAL'
,p_step_title=>'Concern - Check &P30_CHECK_NUMBER. Not In Order'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var p30SigPad = null;',
'',
'function p30InitSig() {',
'    var canvas = document.getElementById(''p30SigCanvas'');',
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
'    p30SigPad = new SignaturePad(canvas, ctx);',
'}',
'',
'function p30ClearSig() {',
'    if (p30SigPad) { p30SigPad.clear(); }',
'}',
'',
'function p30SaveSig() {',
'    if (!p30SigPad || p30SigPad.isEmpty) {',
'        apex.item(''P30_CONCERN_SIGNATURE_DATA'').setValue('''');',
'    } else {',
'        apex.item(''P30_CONCERN_SIGNATURE_DATA'').setValue(p30SigPad.getDataURL());',
'    }',
'}',
'',
unistr('// \2500\2500 File type helpers (copied from Page 17 / Page 4) \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
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
unistr('// \2500\2500 Upload \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'// x07 is the ONE addition to Page 17''s real UPLOAD_PERMIT_PHOTO',
'// call - it carries concern_id (Part D). x01-x06 are otherwise',
'// identical to the live Page 17 code: permit_id, caption,',
'// latitude, longitude, filename, mime type.',
'function p30UploadFile(file) {',
'    var permitId = apex.item(''P30_PERMIT_ID'').getValue();',
'    if (!permitId) {',
'        apex.message.showErrors([{type:''error'',',
'            message:''Concern must be loaded before attaching files.''}]);',
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
'            x07: apex.item(''P30_CONCERN_ID'').getValue(),',
'            f01: f01',
'        }, {',
'            pageId: 30,',
'            success: function(data) {',
'                spinner$.remove();',
'                if (data.success) {',
'                    apex.message.showPageSuccess(''Photo uploaded successfully.'');',
'                    document.getElementById(''ptw-caption-input'').value              = '''';',
'                    document.getElementById(''ptw-file-input'').value                 = '''';',
'                    document.getElementById(''ptw-camera-input'').value               = '''';',
'                    document.getElementById(''ptw-selected-file-info'').style.display = ''none'';',
'                    p30LoadPhotos();',
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
'function p30HandleFileSelection(file) {',
'    if (!file) return;',
'    // Show filename and upload button - don''t upload yet',
'    document.getElementById(''ptw-selected-file-name'').textContent   = file.name;',
'    document.getElementById(''ptw-selected-file-info'').style.display = ''block'';',
'    document.getElementById(''btn-upload-file'').onclick = function() {',
'        p30UploadFile(file);',
'    };',
'}',
'',
unistr('// \2500\2500 Gallery \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'// x02 is the ONE addition to Page 17''s real GET_PERMIT_PHOTOS',
'// call - it carries concern_id (Part D), so each check''s photos',
'// stay separate even though they share the same permit_id and',
'// source_page_id (30).',
'function p30LoadPhotos() {',
'    var permitId   = apex.item(''P30_PERMIT_ID'').getValue();',
'    var concernId  = apex.item(''P30_CONCERN_ID'').getValue();',
'    if (!permitId || !concernId) return;',
'',
'    var isReadOnly = (apex.item(''P30_RESOLVED'').getValue() === ''Y'');',
'',
'    apex.server.process(''GET_PERMIT_PHOTOS'', { x01: permitId, x02: concernId }, {',
'        pageId: 30,',
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
'                html += ''<span class="ptw-photo-caption">'' + apex.util.escapeHTML(p.fileName) + ''</span>'';',
'                if (p.caption) {',
'                    html += ''<span class="ptw-photo-caption" style="font-weight:normal;">''',
'                          + apex.util.escapeHTML(p.caption) + ''</span>'';',
'                }',
'                html += ''<span class="ptw-photo-date">'' + p.uploadedDate + ''</span>'';',
'                html += ''<span class="ptw-photo-user">'' + apex.util.escapeHTML(p.uploadedBy) + ''</span>'';',
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
'            if (gallery) gallery.innerHTML = ''<p class="ptw-no-photos">Could not load photos.</p>'';',
'        }',
'    });',
'}',
'',
'function p30DeletePhoto(photoId, permitId) {',
'    apex.message.confirm(''Delete this photo? This cannot be undone.'', function(okPressed) {',
'        if (!okPressed) return;',
'        apex.server.process(''DELETE_PERMIT_PHOTO'', { x01: photoId }, {',
'            pageId: 30,',
'            success: function(data) {',
'                if (data.success) {',
'                    apex.message.showPageSuccess(''Photo deleted.'');',
'                    p30LoadPhotos();',
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
'function p30LockCanvas() {',
'    var canvas = document.getElementById(''p30SigCanvas'');',
'    if (!canvas) return;',
'    canvas.style.pointerEvents   = ''none'';',
'    canvas.style.opacity         = ''0.85'';',
'    canvas.style.cursor          = ''not-allowed'';',
'    canvas.style.backgroundColor = ''#ffffff'';',
'    canvas.title                 = ''Signature is locked'';',
'}'))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.jQuery(document).on(''apexbeforepagesubmit'', function() {',
'    p30SaveSig();',
'});',
'',
'$(document).on(''change'', ''#ptw-file-input'', function() {',
'    if (this.files && this.files[0]) p30HandleFileSelection(this.files[0]);',
'});',
'$(document).on(''change'', ''#ptw-camera-input'', function() {',
'    if (this.files && this.files[0]) p30HandleFileSelection(this.files[0]);',
'});',
'',
'$(document).on(''click'', ''.ptw-delete-photo'', function(e) {',
'    e.preventDefault();',
'    e.stopPropagation();',
'    p30DeletePhoto($(this).data(''photo-id''), $(this).data(''permit-id''));',
'});',
'',
'setTimeout(function() {',
'',
'    var isReadOnly = (apex.item(''P30_RESOLVED'').getValue() === ''Y'');',
'',
'    // Signature pad',
'    p30InitSig();',
'    if (p30SigPad) { p30SigPad.clear(); }',
'',
'    var existingSig = apex.item(''P30_CONCERN_SIGNATURE_DATA_URL'').getValue();',
'    if (existingSig) {',
'        var sigCanvas = document.getElementById(''p30SigCanvas'');',
'        loadSignature(p30SigPad, sigCanvas, existingSig);',
'    }',
'',
'    p30LoadPhotos();',
'',
'    if (isReadOnly) {',
'',
'        p30LockCanvas();',
'',
'        document.getElementById(''p30-clear-sig-btn'')?.style.setProperty(''display'', ''none'');',
'',
'        apex.item(''P30_CONCERN_DESCRIPTION'').disable();',
'        apex.item(''P30_ACTIONS_TAKEN'').disable();',
'        apex.item(''P30_CONCERN_PERSON_NAME'').disable();',
'        $(''input[name="P30_HAPPY_TO_CONTINUE"]'').prop(''disabled'', true);',
'',
'        var uploadControls = document.querySelector(''.ptw-upload-controls'');',
'        if (uploadControls) uploadControls.style.display = ''none'';',
'',
'        $(''#BTN_SAVE_CLOSE_P30'').hide();',
'        $(''#BTN_SIGN_CONCERN_P30'').hide();',
'',
'        var banner = document.getElementById(''p30-readonly-banner'');',
'        if (banner) banner.style.display = ''block'';',
'    }',
'',
'    (function () {',
'        var itemName = ''P30_HAPPY_TO_CONTINUE'';',
'        var badges = [',
unistr('            { val: ''Y'', cls: ''cm-badge-yes'', label: ''\2713'' },'),
unistr('            { val: ''N'', cls: ''cm-badge-no'',  label: ''\2717'' }'),
'        ];',
'',
'        function buildBadgeRow(name, badgeList) {',
'            var currentVal = apex.item(name).getValue() || '''';',
'            var $row = $(''<div class="cm-badge-row"></div>'').attr(''data-item'', name);',
'',
'            badgeList.forEach(function (b) {',
'                $(''<span></span>'')',
'                    .addClass(''cm-badge '' + b.cls)',
'                    .toggleClass(''cm-active'', currentVal === b.val)',
'                    .toggleClass(''cm-badge-readonly'', isReadOnly)',
'                    .attr(''data-value'', b.val)',
'                    .text(b.label)',
'                    .appendTo($row);',
'            });',
'            return $row;',
'        }',
'',
'        var $fc = $(''#'' + itemName).closest(''.t-Form-fieldContainer'');',
'        if ($fc.length) {',
'            $fc.find(''.cm-badge-row'').remove();',
'            $fc.find(''.t-Form-inputContainer'').append(buildBadgeRow(itemName, badges));',
'        }',
'',
'        $(''.cm-binary-item .apex-item-radio'').hide();',
'',
'        $(document).off(''click.p30badges'').on(''click.p30badges'', ''.cm-badge:not(.cm-badge-readonly)'', function () {',
'            var $badge = $(this);',
'            var $row   = $badge.closest(''.cm-badge-row'');',
'            var name   = $row.attr(''data-item'');',
'            var val    = $badge.attr(''data-value'');',
'',
'            $(''input[name="'' + name + ''"][value="'' + val + ''"]'')',
'                .prop(''checked'', true).trigger(''change'');',
'',
'            $row.find(''.cm-badge'').removeClass(''cm-active'');',
'            $badge.addClass(''cm-active'');',
'        });',
'    }());',
'',
'}, 350);',
'',
'(function () {',
'    var itemName = ''P30_HAPPY_TO_CONTINUE'';',
'    var badges = [',
unistr('        { val: ''Y'', cls: ''cm-badge-yes'', label: ''\2713'' },'),
unistr('        { val: ''N'', cls: ''cm-badge-no'',  label: ''\2717'' }'),
'    ];',
'',
'    function buildBadgeRow(name, badgeList) {',
'        var currentVal = apex.item(name).getValue() || '''';',
'        var $row = $(''<div class="cm-badge-row"></div>'').attr(''data-item'', name);',
'',
'        badgeList.forEach(function (b) {',
'            $(''<span></span>'')',
'                .addClass(''cm-badge '' + b.cls)',
'                .toggleClass(''cm-active'', currentVal === b.val)',
'                .attr(''data-value'', b.val)',
'                .text(b.label)',
'                .appendTo($row);',
'        });',
'        return $row;',
'    }',
'',
'    var $fc = $(''#'' + itemName).closest(''.t-Form-fieldContainer'');',
'    if ($fc.length) {',
'        $fc.find(''.cm-badge-row'').remove();',
'        $fc.find(''.t-Form-inputContainer'').append(buildBadgeRow(itemName, badges));',
'    }',
'',
'    $(''.cm-binary-item .apex-item-radio'').hide();',
'',
'    $(document).off(''click.p30badges'').on(''click.p30badges'', ''.cm-badge:not(.cm-badge-readonly)'', function () {',
'        var $badge = $(this);',
'        var $row   = $badge.closest(''.cm-badge-row'');',
'        var name   = $row.attr(''data-item'');',
'        var val    = $badge.attr(''data-value'');',
'',
'        $(''input[name="'' + name + ''"][value="'' + val + ''"]'')',
'            .prop(''checked'', true).trigger(''change'');',
'',
'        $row.find(''.cm-badge'').removeClass(''cm-active'');',
'        $badge.addClass(''cm-active'');',
'    });',
'}());'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.p30-sig-wrapper canvas {',
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
''))
,p_step_template=>2100407606326202693
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'16'
,p_created_on=>wwv_flow_imp.dz('20260719192329Z')
,p_last_updated_on=>wwv_flow_imp.dz('20260829155520Z')
,p_created_by=>'PTW_PRO'
,p_last_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8747246084520315)
,p_plug_name=>'Buttons'
,p_static_id=>'buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>170
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719194708Z')
,p_updated_on=>wwv_flow_imp.dz('20260728211041Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8746836114520311)
,p_plug_name=>'Concern Details'
,p_static_id=>'concern-details'
,p_title=>'Concern Details'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>130
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719194708Z')
,p_updated_on=>wwv_flow_imp.dz('20260728211040Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8746739467520310)
,p_plug_name=>'Concern Info Banner'
,p_static_id=>'concern-info-banner'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>120
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="t-Alert t-Alert--warning t-Alert--horizontal p30-concern-banner" role="region" style="margin-bottom:8px;">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon">',
'      <span class="t-Icon fa fa-exclamation-triangle" aria-hidden="true"></span>',
'    </div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-header">',
'        <h2 class="t-Alert-title">Method Statement Check Not In Order</h2>',
'      </div>',
'      <div class="t-Alert-body">',
'        Permit: <strong>&P30_PERMIT_NUMBER.</strong> &mdash; Check <strong>&P30_CHECK_NUMBER.</strong>',
'      </div>',
'    </div>',
'  </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719194708Z')
,p_updated_on=>wwv_flow_imp.dz('20260728211040Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8746952838520312)
,p_plug_name=>'Decision'
,p_static_id=>'decision'
,p_title=>'Decision'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>150
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719194708Z')
,p_updated_on=>wwv_flow_imp.dz('20260728211040Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8747053550520313)
,p_plug_name=>'Evidence Photos'
,p_static_id=>'evidence-photos'
,p_title=>'Evidence Photos'
,p_icon_css_classes=>'fa-camera'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>140
,p_plug_item_display_point=>'ABOVE'
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
'</div>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719194708Z')
,p_updated_on=>wwv_flow_imp.dz('20260728211040Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(8747139495520314)
,p_plug_name=>'Sign Off'
,p_static_id=>'p30-signoff-region'
,p_title=>'Sign Off'
,p_icon_css_classes=>'fa-pencil-square-o'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>160
,p_plug_item_display_point=>'ABOVE'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div id="p30-readonly-banner" class="t-Alert t-Alert--success t-Alert--horizontal" style="display:none; margin-bottom:8px;">',
'  <div class="t-Alert-wrap">',
'    <div class="t-Alert-icon"><span class="t-Icon fa fa-check-circle" aria-hidden="true"></span></div>',
'    <div class="t-Alert-content">',
'      <div class="t-Alert-body">This concern has been signed off and can no longer be edited.</div>',
'    </div>',
'  </div>',
'</div>',
'<div class="p30-sig-wrapper">',
'    <canvas id="p30SigCanvas"></canvas>',
'</div>',
'<div style="margin-top:8px;">',
'    <button type="button"',
'            id="p30-clear-sig-btn"',
'            class="t-Button t-Button--small"',
'            onclick="p30ClearSig();">',
'        <span class="t-Icon fa fa-eraser"></span> Clear Signature',
'    </button>',
'</div>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719194708Z')
,p_updated_on=>wwv_flow_imp.dz('20260728211041Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(53190646436153130)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(8747246084520315)
,p_button_name=>'SAVE_CLOSE'
,p_static_id=>'BTN_SAVE_CLOSE_P30'
,p_button_static_id=>'BTN_SAVE_CLOSE_P30'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save Draft'
,p_button_position=>'PREVIOUS'
,p_warn_on_unsaved_changes=>null
,p_created_on=>wwv_flow_imp.dz('20260720205552Z')
,p_updated_on=>wwv_flow_imp.dz('20260728210018Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(53190767387153131)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(8747246084520315)
,p_button_name=>'SIGN_CONCERN'
,p_static_id=>'BTN_SIGN_CONCERN_P30'
,p_button_static_id=>'BTN_SIGN_CONCERN_P30'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Continue'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_created_on=>wwv_flow_imp.dz('20260720205552Z')
,p_updated_on=>wwv_flow_imp.dz('20260728210018Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(8878091750853329)
,p_branch_name=>'Back to Dashboard if Cancelled'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:1::'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_branch_condition=>'P30_PERMIT_CANCELLED'
,p_branch_condition_text=>'Y'
,p_created_on=>wwv_flow_imp.dz('20260728211418Z')
,p_updated_on=>wwv_flow_imp.dz('20260728211418Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8747455647520317)
,p_name=>'P30_ACTIONS_TAKEN'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(8746836114520311)
,p_prompt=>'Actions taken so far'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'N',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719194709Z')
,p_updated_on=>wwv_flow_imp.dz('20260725150148Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8746157899520304)
,p_name=>'P30_CHECK_NUMBER'
,p_item_sequence=>60
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719194709Z')
,p_updated_on=>wwv_flow_imp.dz('20260719194709Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8747316976520316)
,p_name=>'P30_CONCERN_DESCRIPTION'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(8746836114520311)
,p_prompt=>'What''s the concern?'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'N',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719194709Z')
,p_updated_on=>wwv_flow_imp.dz('20260725150148Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8746243520520305)
,p_name=>'P30_CONCERN_ID'
,p_item_sequence=>70
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719194709Z')
,p_updated_on=>wwv_flow_imp.dz('20260719194709Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(53190568154153129)
,p_name=>'P30_CONCERN_PERSON_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(8747139495520314)
,p_prompt=>'Signed off by (name)'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260720205552Z')
,p_updated_on=>wwv_flow_imp.dz('20260725141528Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8746357801520306)
,p_name=>'P30_CONCERN_SIGNATURE_DATA'
,p_item_sequence=>80
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719194709Z')
,p_updated_on=>wwv_flow_imp.dz('20260719194709Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8877804957853327)
,p_name=>'P30_CONCERN_SIGNATURE_DATA_URL'
,p_item_sequence=>90
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260728203504Z')
,p_updated_on=>wwv_flow_imp.dz('20260728203504Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8747696547520319)
,p_name=>'P30_HAPPY_TO_CONTINUE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(8746952838520312)
,p_prompt=>'Happy To Continue?'
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC:Yes - Safe to Continue;Y,No - Permit Must Be Cancelled;N'
,p_field_template=>1609121967514267634
,p_item_css_classes=>'cm-binary-item'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1',
  'page_action_on_selection', 'NONE')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719195258Z')
,p_updated_on=>wwv_flow_imp.dz('20260725141005Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8746073152520303)
,p_name=>'P30_MONITORING_ID'
,p_item_sequence=>50
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719194709Z')
,p_updated_on=>wwv_flow_imp.dz('20260719194709Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8877942386853328)
,p_name=>'P30_PERMIT_CANCELLED'
,p_item_sequence=>110
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260728211041Z')
,p_updated_on=>wwv_flow_imp.dz('20260728211041Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8745820809520301)
,p_name=>'P30_PERMIT_ID'
,p_item_sequence=>30
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719194709Z')
,p_updated_on=>wwv_flow_imp.dz('20260719194709Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8745913976520302)
,p_name=>'P30_PERMIT_NUMBER'
,p_item_sequence=>40
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719194709Z')
,p_updated_on=>wwv_flow_imp.dz('20260719194709Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(8746679174520309)
,p_name=>'P30_RESOLVED'
,p_item_sequence=>100
,p_source_type=>'ALWAYS_NULL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260719194709Z')
,p_updated_on=>wwv_flow_imp.dz('20260728203504Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(53191714969153141)
,p_validation_name=>'Actions Taken NOT NULL'
,p_static_id=>'actions-taken-not-null'
,p_validation_sequence=>20
,p_validation=>'P30_ACTIONS_TAKEN'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Actions Taken is mandatory.'
,p_when_button_pressed=>wwv_flow_imp.id(53190767387153131)
,p_associated_item=>wwv_flow_imp.id(8747455647520317)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260720211155Z')
,p_updated_on=>wwv_flow_imp.dz('20260720211155Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(53192148167153145)
,p_validation_name=>'At least 1 photo required (below)'
,p_static_id=>'at-least-1-photo-required-below'
,p_validation_sequence=>60
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_count NUMBER;',
'BEGIN',
'    IF :P30_HAPPY_TO_CONTINUE != ''N'' THEN',
'        RETURN TRUE;',
'    END IF;',
'',
'    SELECT COUNT(*)',
'    INTO   l_count',
'    FROM   ptw_pro.ptw_lv_permit_photos',
'    WHERE  concern_id = :P30_CONCERN_ID;',
'',
'    RETURN l_count > 0;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'At least one photo of the issue is required before this concern can be signed off.'
,p_when_button_pressed=>wwv_flow_imp.id(53190767387153131)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260720211155Z')
,p_updated_on=>wwv_flow_imp.dz('20260725145208Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(53191567312153139)
,p_validation_name=>'Concern Description NOT NULL'
,p_static_id=>'concern-description-not-null'
,p_validation_sequence=>10
,p_validation=>'P30_CONCERN_DESCRIPTION'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Concern Description is mandatory.'
,p_when_button_pressed=>wwv_flow_imp.id(53190767387153131)
,p_associated_item=>wwv_flow_imp.id(8747316976520316)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260720210524Z')
,p_updated_on=>wwv_flow_imp.dz('20260720210524Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(53191999056153143)
,p_validation_name=>'Concern Person NOT NULL'
,p_static_id=>'concern-person-not-null'
,p_validation_sequence=>40
,p_validation=>'P30_CONCERN_PERSON_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'The concern person is mandatory.'
,p_validation_condition=>':P30_HAPPY_TO_CONTINUE = ''N'''
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_when_button_pressed=>wwv_flow_imp.id(53190767387153131)
,p_associated_item=>wwv_flow_imp.id(53190568154153129)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260720211155Z')
,p_updated_on=>wwv_flow_imp.dz('20260725145208Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(53191866542153142)
,p_validation_name=>'Happy To Continue NOT NULL'
,p_static_id=>'happy-to-continue-not-null'
,p_validation_sequence=>30
,p_validation=>'P30_HAPPY_TO_CONTINUE'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Happy to Continue is mandatory.'
,p_when_button_pressed=>wwv_flow_imp.id(53190767387153131)
,p_associated_item=>wwv_flow_imp.id(8747696547520319)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260720211155Z')
,p_updated_on=>wwv_flow_imp.dz('20260720211155Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(53192096776153144)
,p_validation_name=>'Signature required'
,p_static_id=>'signature-required'
,p_validation_sequence=>50
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'RETURN',
'    :P30_HAPPY_TO_CONTINUE != ''N''',
'    OR NOT (',
'        :P30_CONCERN_SIGNATURE_DATA IS NULL',
'        OR TRIM(:P30_CONCERN_SIGNATURE_DATA) IS NULL',
'        OR :P30_CONCERN_SIGNATURE_DATA = ''data:,''',
'    );'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Please sign before continuing.'
,p_when_button_pressed=>wwv_flow_imp.id(53190767387153131)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_created_on=>wwv_flow_imp.dz('20260720211155Z')
,p_updated_on=>wwv_flow_imp.dz('20260725145208Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(8876824933853317)
,p_name=>'Force signature if not happy to continue'
,p_static_id=>'force-signature-if-not-happy-to-continue'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_HAPPY_TO_CONTINUE'
,p_condition_element=>'P30_HAPPY_TO_CONTINUE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'N'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_created_on=>wwv_flow_imp.dz('20260725145208Z')
,p_updated_on=>wwv_flow_imp.dz('20260725145648Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(8877100777853320)
,p_event_id=>wwv_flow_imp.id(8876824933853317)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-hide'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(8747139495520314)
,p_created_on=>wwv_flow_imp.dz('20260725145208Z')
,p_updated_on=>wwv_flow_imp.dz('20260725145208Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(8877277811853321)
,p_event_id=>wwv_flow_imp.id(8876824933853317)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-hide_1'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_CONCERN_PERSON_NAME'
,p_created_on=>wwv_flow_imp.dz('20260725145208Z')
,p_updated_on=>wwv_flow_imp.dz('20260725145648Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(8876915791853318)
,p_event_id=>wwv_flow_imp.id(8876824933853317)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-show'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(8747139495520314)
,p_created_on=>wwv_flow_imp.dz('20260725145208Z')
,p_updated_on=>wwv_flow_imp.dz('20260725145208Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(8877066541853319)
,p_event_id=>wwv_flow_imp.id(8876824933853317)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_static_id=>'native-show_1'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P30_CONCERN_PERSON_NAME'
,p_created_on=>wwv_flow_imp.dz('20260725145208Z')
,p_updated_on=>wwv_flow_imp.dz('20260725145208Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(53191141117153135)
,p_name=>'Save Concern - Capture Location and Submit'
,p_static_id=>'save-concern-capture-location-and-submit'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(53190646436153130)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20260720210216Z')
,p_updated_on=>wwv_flow_imp.dz('20260720210216Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53191297851153136)
,p_event_id=>wwv_flow_imp.id(53191141117153135)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', 'captureLocationThenSubmit(''SAVE_CLOSE'');')).to_clob
,p_created_on=>wwv_flow_imp.dz('20260720210216Z')
,p_updated_on=>wwv_flow_imp.dz('20260720210216Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(8877391815853322)
,p_name=>'set to session state'
,p_static_id=>'set-to-session-state'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P30_HAPPY_TO_CONTINUE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_created_on=>wwv_flow_imp.dz('20260725145916Z')
,p_updated_on=>wwv_flow_imp.dz('20260725145916Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(8877487828853323)
,p_event_id=>wwv_flow_imp.id(8877391815853322)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-execute-plsql-code'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'items_to_submit', 'P30_HAPPY_TO_CONTINUE',
  'language', 'PLSQL',
  'plsql_code', 'NULL;',
  'show_processing', 'N')).to_clob
,p_wait_for_result=>'Y'
,p_created_on=>wwv_flow_imp.dz('20260725145916Z')
,p_updated_on=>wwv_flow_imp.dz('20260725145916Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(53191344780153137)
,p_name=>'Sign Concern - Capture Location and Submit'
,p_static_id=>'sign-concern-capture-location-and-submit'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(53190767387153131)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_created_on=>wwv_flow_imp.dz('20260720210216Z')
,p_updated_on=>wwv_flow_imp.dz('20260728212713Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53191495133153138)
,p_event_id=>wwv_flow_imp.id(53191344780153137)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_static_id=>'native-javascript-code'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'js_code', wwv_flow_string.join(wwv_flow_t_varchar2(
    'apex.page.cancelWarnOnUnsavedChanges();',
    '',
    'if (apex.item(''P30_HAPPY_TO_CONTINUE'').getValue() === ''N'') {',
    '    apex.message.confirm(',
    '        ''This will cancel the permit and stop the work. This cannot be undone. Do you want to continue?'',',
    '        function (okPressed) {',
    '            if (okPressed) {',
    '                captureLocationThenSubmit(''SIGN_CONCERN'');',
    '            }',
    '        }',
    '    );',
    '} else {',
    '    captureLocationThenSubmit(''SIGN_CONCERN'');',
    '}')))).to_clob
,p_created_on=>wwv_flow_imp.dz('20260720210216Z')
,p_updated_on=>wwv_flow_imp.dz('20260728212713Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(8877579172853324)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close this dialog'
,p_static_id=>'close-this-dialog'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'show_success_messages', 'N')).to_clob
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'P30_PERMIT_CANCELLED'
,p_process_when_type=>'ITEM_IS_NULL'
,p_internal_uid=>8877579172853324
,p_created_on=>wwv_flow_imp.dz('20260725174908Z')
,p_updated_on=>wwv_flow_imp.dz('20260728211303Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(8875530919853304)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_PERMIT_PHOTOS'
,p_static_id=>'get-permit-photos'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_permit_id  NUMBER := TO_NUMBER(apex_application.g_x01);',
'    l_concern_id NUMBER;',
'BEGIN',
'    BEGIN l_concern_id := TO_NUMBER(apex_application.g_x02); EXCEPTION WHEN OTHERS THEN l_concern_id := NULL; END;',
'',
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
'        WHERE  permit_id      = l_permit_id',
'        AND    source_page_id = :APP_PAGE_ID',
'        AND    NVL(concern_id, -1) = NVL(l_concern_id, NVL(concern_id, -1))  -- see note above',
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
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>8875530919853304
,p_created_on=>wwv_flow_imp.dz('20260720213130Z')
,p_updated_on=>wwv_flow_imp.dz('20260720213130Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(53190892789153132)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Or Create Concern'
,p_static_id=>'load-or-create-concern'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_concern_id ptw_pro.ptw_lv_monitoring_concerns.concern_id%TYPE;',
'    l_sig_blob   ptw_pro.ptw_lv_monitoring_concerns.concern_signature%TYPE;',
'    l_clob       CLOB;',
'BEGIN',
'    BEGIN',
'        SELECT concern_id,',
'               concern_description,',
'               actions_taken,',
'               happy_to_continue,',
'               concern_person_name,',
'               concern_signature,',
'               CASE WHEN happy_to_continue = ''Y'' THEN ''Y''',
'                 WHEN happy_to_continue = ''N'' AND concern_signature IS NOT NULL THEN ''Y''',
'                 ELSE ''N'' ',
'               END',
'        INTO   :P30_CONCERN_ID,',
'               :P30_CONCERN_DESCRIPTION,',
'               :P30_ACTIONS_TAKEN,',
'               :P30_HAPPY_TO_CONTINUE,',
'               :P30_CONCERN_PERSON_NAME,',
'               l_sig_blob,',
'               :P30_RESOLVED',
'        FROM   ptw_pro.ptw_lv_monitoring_concerns',
'        WHERE  monitoring_id = :P30_MONITORING_ID',
'        AND    check_number  = :P30_CHECK_NUMBER;',
'',
'        IF l_sig_blob IS NOT NULL AND DBMS_LOB.GETLENGTH(l_sig_blob) > 0 THEN',
'            l_clob := apex_web_service.blob2clobbase64(l_sig_blob);',
'            l_clob := REPLACE(REPLACE(l_clob, CHR(13), ''''), CHR(10), '''');',
'            :P30_CONCERN_SIGNATURE_DATA_URL :=',
'                ''data:image/png;base64,'' || DBMS_LOB.SUBSTR(l_clob, 32000, 1);',
'        ELSE',
'            :P30_CONCERN_SIGNATURE_DATA_URL := NULL;',
'        END IF;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            INSERT INTO ptw_pro.ptw_lv_monitoring_concerns',
'                (monitoring_id, check_number, created_by)',
'            VALUES',
'                (:P30_MONITORING_ID, :P30_CHECK_NUMBER, :APP_USER)',
'            RETURNING concern_id INTO l_concern_id;',
'',
'            :P30_CONCERN_ID := l_concern_id;',
'            :P30_RESOLVED   := ''N'';',
'            :P30_CONCERN_SIGNATURE_DATA_URL := NULL;',
'            COMMIT;',
'    END;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>53190892789153132
,p_created_on=>wwv_flow_imp.dz('20260720210216Z')
,p_updated_on=>wwv_flow_imp.dz('20260829155520Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(53190980766153133)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save & Close'
,p_static_id=>'save-close'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    UPDATE ptw_pro.ptw_lv_monitoring_concerns',
'    SET    concern_description = :P30_CONCERN_DESCRIPTION,',
'           actions_taken       = :P30_ACTIONS_TAKEN,',
'           happy_to_continue   = :P30_HAPPY_TO_CONTINUE,',
'           concern_person_name = :P30_CONCERN_PERSON_NAME,',
'           concern_datetime    = SYSDATE,',
'           concern_latitude    = :APP_LATITUDE,',
'           concern_longitude   = :APP_LONGITUDE,',
'           modified_date       = SYSTIMESTAMP,',
'           modified_by         = :APP_USER',
'    WHERE  concern_id = :P30_CONCERN_ID;',
' ',
'    INSERT INTO ptw_pro.ptw_stage_locations (',
'        permit_id, permit_stage, latitude, longitude,',
'        created_date, created_by, company_id',
'    ) VALUES (',
'        :P30_PERMIT_ID, ''MONITORING_CONCERN'', :APP_LATITUDE, :APP_LONGITUDE,',
'        SYSDATE, NVL(:APP_USER, USER),',
'        (SELECT company_id FROM ptw_pro.ptw_lv_permits WHERE permit_id = :P30_PERMIT_ID)',
'    );',
'    COMMIT;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(53190646436153130)
,p_internal_uid=>53190980766153133
,p_created_on=>wwv_flow_imp.dz('20260720210216Z')
,p_updated_on=>wwv_flow_imp.dz('20260829155520Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(53191094052153134)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Sign & Continue'
,p_static_id=>'sign-continue'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_sig_clob  CLOB;',
'    l_sig_blob  BLOB;',
'    l_permit_id NUMBER := :P30_PERMIT_ID;',
'BEGIN',
'    l_sig_clob := REGEXP_REPLACE(:P30_CONCERN_SIGNATURE_DATA, ''^data:image/[^;]+;base64,'', '''');',
'    l_sig_blob := apex_web_service.clobbase642blob(l_sig_clob);',
'',
'    UPDATE ptw_pro.ptw_lv_monitoring_concerns',
'    SET    concern_description = :P30_CONCERN_DESCRIPTION,',
'           actions_taken       = :P30_ACTIONS_TAKEN,',
'           happy_to_continue   = :P30_HAPPY_TO_CONTINUE,',
'           concern_person_name = :P30_CONCERN_PERSON_NAME,',
'           concern_signature   = l_sig_blob,',
'           concern_datetime    = SYSDATE,',
'           concern_latitude    = :APP_LATITUDE,',
'           concern_longitude   = :APP_LONGITUDE,',
'           modified_date       = SYSTIMESTAMP,',
'           modified_by         = :APP_USER',
'    WHERE  concern_id = :P30_CONCERN_ID;',
'',
'    IF :P30_HAPPY_TO_CONTINUE = ''N'' THEN',
'        UPDATE ptw_pro.ptw_lv_permits',
'        SET    cancel_work_complete    = ''N'',',
'               cancel_person_name      = UPPER(TRIM(:P30_CONCERN_PERSON_NAME)),',
'               cancel_person_signature = l_sig_blob,',
'               cancel_datetime         = SYSDATE,',
'               cancel_latitude         = :APP_LATITUDE,',
'               cancel_longitude        = :APP_LONGITUDE,',
'               workflow_status         = ''CANCELLED'',',
'               current_step            = ''CANCELLED'',',
'               completion_date         = SYSDATE,',
'               modified_by             = NVL(V(''APP_USER''), USER),',
'               modified_date           = CURRENT_TIMESTAMP',
'        WHERE  permit_id       = l_permit_id',
'        AND    workflow_status NOT IN (''CANCELLED'',''COMPLETED'',''CLEARED'');',
'',
'        UPDATE ptw_pro.ptw_lv_monitoring',
'        SET    monitor_name       = UPPER(TRIM(:P30_CONCERN_PERSON_NAME)),',
'               monitor_signature  = l_sig_blob,',
'               monitor_date       = SYSDATE,',
'               monitor_latitude   = :APP_LATITUDE,',
'               monitor_longitude  = :APP_LONGITUDE,',
'               monitoring_status  = ''COMPLETED'',',
'               modified_date      = CURRENT_TIMESTAMP,',
'               modified_by        = NVL(V(''APP_USER''), USER)',
'        WHERE  monitoring_id      = :P30_MONITORING_ID;',
'',
'        INSERT INTO ptw_pro.ptw_stage_locations (',
'            permit_id, permit_stage, latitude, longitude,',
'            created_date, created_by, company_id',
'        ) VALUES (',
'            l_permit_id, ''MONITORING_CONCERN'', :APP_LATITUDE, :APP_LONGITUDE,',
'            SYSDATE, NVL(:APP_USER, USER),',
'            (SELECT company_id FROM ptw_pro.ptw_lv_permits WHERE permit_id = l_permit_id)',
'        );',
'',
'        :P30_PERMIT_CANCELLED := ''Y'';',
'',
'        IF SQL%ROWCOUNT = 0 THEN',
'            ROLLBACK;',
'            apex_error.add_error(',
'                p_message          => ''This permit could not be cancelled - it may already ''',
'                                    || ''be cancelled or completed. Please refresh and check ''',
'                                    || ''its current status.'',',
'                p_display_location => apex_error.c_inline_in_notification',
'            );',
'            RETURN;',
'        END IF;',
'    END IF;',
'',
'    :P30_RESOLVED := ''Y'';',
'    COMMIT;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message          => ''Error signing concern: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RAISE;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(53190767387153131)
,p_internal_uid=>53191094052153134
,p_created_on=>wwv_flow_imp.dz('20260720210216Z')
,p_updated_on=>wwv_flow_imp.dz('20260829155520Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(8875408045853303)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'UPLOAD_PERMIT_PHOTO'
,p_static_id=>'upload-permit-photo'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_permit_id   NUMBER        := TO_NUMBER(apex_application.g_x01);',
'    l_caption     VARCHAR2(500) := apex_application.g_x02;',
'    l_latitude    NUMBER;',
'    l_longitude   NUMBER;',
'    l_file_name   VARCHAR2(255) := apex_application.g_x05;',
'    l_mime_type   VARCHAR2(100) := apex_application.g_x06;',
'    l_concern_id  NUMBER;                                    -- ADDED',
'    l_b64_clob    CLOB;',
'    l_blob        BLOB;',
'    l_token       VARCHAR2(32767);',
'BEGIN',
'    BEGIN l_latitude   := TO_NUMBER(apex_application.g_x03); EXCEPTION WHEN OTHERS THEN l_latitude   := NULL; END;',
'    BEGIN l_longitude  := TO_NUMBER(apex_application.g_x04); EXCEPTION WHEN OTHERS THEN l_longitude  := NULL; END;',
'    BEGIN l_concern_id := TO_NUMBER(apex_application.g_x07); EXCEPTION WHEN OTHERS THEN l_concern_id := NULL; END; -- ADDED',
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
'        uploaded_by, uploaded_date, source_page_id, concern_id  -- ADDED concern_id',
'    ) VALUES (',
'        l_permit_id, l_blob,',
'        NVL(l_mime_type, ''application/octet-stream''),',
'        NVL(l_file_name, ''attachment''),',
'        NULLIF(TRIM(l_caption), ''''),',
'        l_latitude, l_longitude,',
'        NVL(V(''APP_USER''), USER),',
'        CURRENT_TIMESTAMP,',
'        :APP_PAGE_ID,',
'        l_concern_id                                            -- ADDED',
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
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>8875408045853303
,p_created_on=>wwv_flow_imp.dz('20260720213130Z')
,p_updated_on=>wwv_flow_imp.dz('20260720213130Z')
,p_created_by=>'PTW_PRO'
,p_updated_by=>'PTW_PRO'
);
wwv_flow_imp.component_end;
end;
/
