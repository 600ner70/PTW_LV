prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
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
 p_id=>4
,p_name=>'Equipment Isolation'
,p_alias=>'EQUIPMENT-ISOLATION'
,p_step_title=>'Equipment Isolation'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'#APP_FILES#offline-storage#MIN#.js'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('// \2500\2500 Connection status UI \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'function updateConnectionUI() {',
'    var statusDiv  = document.getElementById(''connection-status'');',
'    var statusIcon = document.getElementById(''status-icon'');',
'    var statusText = document.getElementById(''status-text'');',
'    if (!statusDiv) return;',
'    if (navigator.onLine) {',
'        statusDiv.style.backgroundColor = ''#d4edda'';',
'        statusIcon.innerHTML = ''\u2713'';',
'        statusText.innerHTML = ''Connected'';',
'    } else {',
'        statusDiv.style.backgroundColor = ''#fff3cd'';',
'        statusIcon.innerHTML = ''\u26A0'';',
'        statusText.innerHTML = ''Offline Mode'';',
'    }',
'}',
'updateConnectionUI();',
'window.addEventListener(''online'',  updateConnectionUI);',
'window.addEventListener(''offline'', updateConnectionUI);',
'',
unistr('// \2500\2500 File type helpers \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'function ptwGetFileCategory(mimeType, fileName) {',
'    var ext = (fileName || '''').split(''.'').pop().toLowerCase();',
'    if (mimeType && mimeType.startsWith(''image/''))               return ''image'';',
'    if (mimeType === ''application/pdf'')                          return ''pdf'';',
'    if (mimeType && (mimeType.indexOf(''word'')     > -1 ||',
'                     mimeType.indexOf(''document'') > -1))         return ''word'';',
'    if (mimeType && (mimeType.indexOf(''sheet'')    > -1 ||',
'                     mimeType.indexOf(''excel'')    > -1))         return ''excel'';',
'    // Fallback to extension if MIME is generic',
'    if ([''jpg'',''jpeg'',''png'',''gif'',''webp''].indexOf(ext) > -1)     return ''image'';',
'    if (ext === ''pdf'')                                           return ''pdf'';',
'    if ([''doc'',''docx''].indexOf(ext) > -1)                        return ''word'';',
'    if ([''xls'',''xlsx''].indexOf(ext) > -1)                        return ''excel'';',
'    return ''other'';',
'}',
'',
'function ptwFileIcon(category) {',
'    var icons = {',
'        pdf:   ''<div class="ptw-file-icon icon-pdf">''  + ''<span class="fa fa-file-pdf-o"></span></div>'',',
'        word:  ''<div class="ptw-file-icon icon-word">'' + ''<span class="fa fa-file-word-o"></span></div>'',',
'        excel: ''<div class="ptw-file-icon icon-excel">''+ ''<span class="fa fa-file-excel-o"></span></div>'',',
'        other: ''<div class="ptw-file-icon">''           + ''<span class="fa fa-file-o"></span></div>''',
'    };',
'    return icons[category] || icons.other;',
'}',
'',
unistr('// \2500\2500 Core upload function \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'function ptwUploadFile(file) {',
'    if (!navigator.onLine) {',
'        apex.message.showErrors([{type: ''error'',',
'            message: ''File upload requires an internet connection.''}]);',
'        return;',
'    }',
'',
'    var permitId = apex.item(''P4_PERMIT_ID'').getValue();',
'    if (!permitId) {',
'        apex.message.showErrors([{type: ''error'',',
'            message: ''Permit must be saved before attaching files.''}]);',
'        return;',
'    }',
'',
'    if (file.size > 20 * 1024 * 1024) {',
'        apex.message.showErrors([{type: ''error'',',
'            message: ''File must be less than 20MB.''}]);',
'        return;',
'    }',
'',
'    // Validate by MIME type and extension',
'    var allowed     = [''image/jpeg'',''image/png'',''image/gif'',''image/webp'',',
'                       ''application/pdf'',',
'                       ''application/msword'',',
'                       ''application/vnd.openxmlformats-officedocument.wordprocessingml.document'',',
'                       ''application/vnd.ms-excel'',',
'                       ''application/vnd.openxmlformats-officedocument.spreadsheetml.sheet''];',
'    var allowedExts = [''jpg'',''jpeg'',''png'',''gif'',''webp'',''pdf'',''doc'',''docx'',''xls'',''xlsx''];',
'    var ext         = file.name.split(''.'').pop().toLowerCase();',
'',
'    if (allowed.indexOf(file.type) === -1 && allowedExts.indexOf(ext) === -1) {',
'        apex.message.showErrors([{type: ''error'',',
'            message: ''Allowed file types: PDF, Word, Excel and images only.''}]);',
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
'',
'        apex.server.process(''UPLOAD_PERMIT_PHOTO'', {',
'            x01: permitId,',
'            x02: caption,',
'            x03: apex.item(''P0_LATITUDE'').getValue()  || '''',',
'            x04: apex.item(''P0_LONGITUDE'').getValue() || '''',',
'            x05: file.name,',
'            x06: file.type || ''application/octet-stream'',',
'            f01: f01',
'        }, {',
'            success: function(data) {',
'                spinner$.remove();',
'                if (data.success) {',
'                    apex.message.showPageSuccess(''File uploaded successfully.'');',
'                    document.getElementById(''ptw-caption-input'').value = '''';',
'                    document.getElementById(''ptw-file-input'').value    = '''';',
'                    document.getElementById(''ptw-camera-input'').value  = '''';',
'                    document.getElementById(''ptw-selected-file-info'').style.display = ''none'';',
'                    loadPermitPhotos(permitId);',
'                } else {',
'                    apex.message.showErrors([{type: ''error'', message: data.message}]);',
'                }',
'            },',
'            error: function(xhr, status, error) {',
'                spinner$.remove();',
'                apex.message.showErrors([{type: ''error'',',
'                    message: ''Upload failed: '' + error}]);',
'            }',
'        });',
'    };',
'    reader.onerror = function() {',
'        spinner$.remove();',
'        apex.message.showErrors([{type: ''error'',',
'            message: ''Could not read the file. Please try again.''}]);',
'    };',
'    reader.readAsDataURL(file);',
'}',
'',
unistr('// \2500\2500 File selection handler \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'function ptwHandleFileSelection(file) {',
'    if (!file) return;',
'    document.getElementById(''ptw-selected-file-name'').textContent = file.name;',
'    document.getElementById(''ptw-selected-file-info'').style.display = ''block'';',
'    document.getElementById(''btn-upload-file'').onclick = function() {',
'        ptwUploadFile(file);',
'    };',
'}',
'',
unistr('// \2500\2500 Lightbox \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'function ptwOpenLightbox(url, caption) {',
'    document.getElementById(''ptw-lightbox-img'').src              = url;',
'    document.getElementById(''ptw-lightbox-caption'').textContent  = caption || '''';',
'    document.getElementById(''ptw-lightbox'').style.display        = ''flex'';',
'    document.body.style.overflow                                  = ''hidden'';',
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
unistr('// \2500\2500 Gallery \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'function loadPermitPhotos(permitId) {',
'    if (!permitId) return;',
'',
'    // Determine editability once before building gallery',
'    var statusEl   = document.getElementById(''ptw-workflow-status'');',
'    var isEditable = statusEl && ',
'                     statusEl.getAttribute(''data-status'') === ''IN_PROGRESS'';',
'',
'    apex.server.process(''GET_PERMIT_PHOTOS'', { x01: permitId }, {',
'        success: function(data) {',
'            var gallery = document.getElementById(''ptw-photo-gallery'');',
'            if (!gallery) return;',
'',
'            if (!data.photos || data.photos.length === 0) {',
'                gallery.innerHTML = ''<p class="ptw-no-photos">No files attached to this permit yet.</p>'';',
'                return;',
'            }',
'',
'            var html = ''<div class="ptw-photo-grid">'';',
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
'                          + ''alt="'' + apex.util.escapeHTMLAttr(p.caption || ''Attached image'') + ''" ''',
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
'                // Delete only available when permit is IN_PROGRESS',
'                if (isEditable) {',
'                    html += ''<button type="button" ''',
'                          + ''class="t-Button t-Button--danger t-Button--slim t-Button--stretch ptw-delete-photo" ''',
'                          + ''data-photo-id="'' + p.photoId + ''" ''',
'                          + ''data-permit-id="'' + permitId + ''">''',
'                          + ''<span class="t-Icon fa fa-trash-o"></span> Delete</button>'';',
'                }',
'',
'                html += ''</div>'';',
'            });',
'            html += ''</div>'';',
'            gallery.innerHTML = html;',
'        },',
'        error: function() {',
'            var gallery = document.getElementById(''ptw-photo-gallery'');',
'            if (gallery) {',
'                gallery.innerHTML = ''<p class="ptw-no-photos">Could not load files.</p>'';',
'            }',
'        }',
'    });',
'}',
'',
unistr('// \2500\2500 Delete handler \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'function deletePtwPhoto(photoId, permitId) {',
'    apex.message.confirm(''Delete this file? This cannot be undone.'', function(okPressed) {',
'        if (!okPressed) return;',
'        apex.server.process(''DELETE_PERMIT_PHOTO'', { x01: photoId }, {',
'            success: function(data) {',
'                if (data.success) {',
'                    apex.message.showPageSuccess(''File deleted.'');',
'                    loadPermitPhotos(permitId);',
'                } else {',
'                    apex.message.showErrors([{type: ''error'', message: data.message}]);',
'                }',
'            },',
'            error: function(xhr, status, error) {',
'                apex.message.showErrors([{type: ''error'',',
'                    message: ''Delete failed: '' + error}]);',
'            }',
'        });',
'    });',
'}',
'',
unistr('// \2500\2500 Document ready \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'$(document).ready(function() {',
'',
unistr('    // \2500\2500 Show/hide upload controls based on workflow status \2500\2500\2500'),
'    var statusEl = document.getElementById(''ptw-workflow-status'');',
'    var status   = statusEl ? statusEl.getAttribute(''data-status'') : '''';',
'',
'    if (status !== ''IN_PROGRESS'') {',
unistr('        // Hide all upload controls \2014 permit is read-only'),
'        var fileInput   = document.getElementById(''ptw-file-input'');',
'        var cameraInput = document.getElementById(''ptw-camera-input'');',
'        var attachBtn   = document.getElementById(''btn-attach-file'');',
'        var cameraBtn   = document.getElementById(''btn-take-photo'');',
'        var captionRow  = document.querySelector(''.ptw-caption-row'');',
'        var fileInfo    = document.getElementById(''ptw-selected-file-info'');',
'',
'        if (fileInput)   fileInput.style.display   = ''none'';',
'        if (cameraInput) cameraInput.style.display  = ''none'';',
'        if (attachBtn)   attachBtn.style.display    = ''none'';',
'        if (cameraBtn)   cameraBtn.style.display    = ''none'';',
'        if (captionRow)  captionRow.style.display   = ''none'';',
'        if (fileInfo)    fileInfo.style.display     = ''none'';',
'',
'        // Also hide the upload row container entirely',
'        var uploadRow = document.querySelector(''.ptw-upload-row'');',
'        if (uploadRow) uploadRow.style.display = ''none'';',
'    }',
'',
unistr('    // \2500\2500 File picker input \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'    var fileInputEl = document.getElementById(''ptw-file-input'');',
'    if (fileInputEl) {',
'        fileInputEl.addEventListener(''change'', function() {',
'            if (this.files && this.files[0]) ptwHandleFileSelection(this.files[0]);',
'        });',
'    }',
'',
unistr('    // \2500\2500 Camera input \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'    var cameraInputEl = document.getElementById(''ptw-camera-input'');',
'    if (cameraInputEl) {',
'        cameraInputEl.addEventListener(''change'', function() {',
'            if (this.files && this.files[0]) ptwHandleFileSelection(this.files[0]);',
'        });',
'    }',
'',
unistr('    // \2500\2500 Delegated delete \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500'),
'    $(document).on(''click'', ''.ptw-delete-photo'', function(e) {',
'        e.preventDefault();',
'        e.stopPropagation();',
'        var photoId  = $(this).data(''photo-id'');',
'        var permitId = $(this).data(''permit-id'');',
'        deletePtwPhoto(photoId, permitId);',
'    });',
'',
'});'))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Initialize offline storage',
'OfflineStorage.initDB();',
'ConnectionManager.init();',
'',
'// Offline handler for NEXT_STEP button.',
'// Capture phase (true) fires before APEX''s bubble-phase DA,',
'// preventing the Execute PLSQL action from making an AJAX call that fails offline.',
'(function() {',
'    var btn = document.querySelector(''[data-otel-label="NEXT_STEP"]'');',
'    if (!btn) return;',
'    btn.addEventListener(''click'', function(e) {',
'        if (navigator.onLine) return;',
'        e.stopImmediatePropagation();',
'        e.preventDefault();',
'        var formData = {};',
'        apex.jQuery(''form'').serializeArray().forEach(function(i) { formData[i.name] = i.value; });',
'        OfflineStorage.saveFormData(''4'', formData, apex.jQuery(''#P4_PERMIT_ID'').val() || null)',
'            .then(function() {',
'                var u = new URL(window.location.href);',
'                var p = u.pathname.split(''/'');',
'                while (p[p.length - 1] === '''') p.pop();',
'                if (/^\d+$/.test(p[p.length - 1])) {',
'                    p[p.length - 2] = ''authorisation-acceptance'';',
'                } else {',
'                    p[p.length - 1] = ''authorisation-acceptance'';',
'                }',
'                u.pathname = p.join(''/'');',
'                u.search = '''';',
'                apex.message.showPageSuccess(''Data saved offline. Will sync when reconnected.'');',
'                setTimeout(function() { window.location.href = u.toString(); }, 800);',
'            })',
'            .catch(function(err) {',
'                apex.message.showErrors([{type:''error'',message:''Offline save error: ''+err.message}]);',
'            });',
'    }, true);',
'}());'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.ptw-workflow-progress {',
'    display: flex;',
'    justify-content: space-between;',
'    align-items: flex-start;',
'    margin: 2rem 0;',
'    padding: 1.5rem;',
'    background: var(--ut-component-background-color, #ffffff);',
'    border-radius: 8px;',
'    border: 1px solid var(--ut-component-border-color, #e0e0e0);',
'    position: relative;',
'}',
'',
'.ptw-workflow-progress::before {',
'    content: '''';',
'    position: absolute;',
'    top: 3rem;',
'    left: 3rem;',
'    right: 3rem;',
'    height: 2px;',
'    background: var(--ut-palette-neutral-300, #d0d0d0);',
'    z-index: 0;',
'}',
'',
'.workflow-step {',
'    display: flex;',
'    flex-direction: column;',
'    align-items: center;',
'    position: relative;',
'    z-index: 1;',
'    flex: 1;',
'    gap: 0.5rem;',
'}',
'',
'.step-icon {',
'    width: 48px;',
'    height: 48px;',
'    border-radius: 50%;',
'    background: var(--ut-component-background-color, #ffffff);',
'    border: 3px solid var(--ut-palette-neutral-300, #d0d0d0);',
'    display: flex;',
'    align-items: center;',
'    justify-content: center;',
'    font-weight: 600;',
'    font-size: 1.125rem;',
'    color: var(--ut-palette-neutral-500, #666666);',
'    transition: all 0.3s ease;',
'}',
'',
'.workflow-step.active .step-icon {',
'    background: #003366;',
'    border-color: #003366;',
'    color: #ffffff;',
'    box-shadow: 0 4px 8px rgba(0, 51, 102, 0.2);',
'}',
'',
'.workflow-step.completed .step-icon {',
'    background: var(--ut-palette-success, #3ea055);',
'    border-color: var(--ut-palette-success, #3ea055);',
'    color: #ffffff;',
'}',
'',
'.step-text {',
'    font-size: 0.875rem;',
'    text-align: center;',
'    color: var(--ut-palette-neutral-600, #595959);',
'    max-width: 100px;',
'    line-height: 1.3;',
'}',
'',
'.workflow-step.active .step-text {',
'    color: #003366;',
'    font-weight: 600;',
'}',
'',
'@media (max-width: 768px) {',
'    .ptw-workflow-progress {',
'        flex-wrap: wrap;',
'        gap: 1rem;',
'    }',
'    .workflow-step {',
'        flex-basis: 30%;',
'    }',
'    .ptw-workflow-progress::before {',
'        display: none;',
'    }',
'}',
'',
'.isolation-table {',
'    width: 100%;',
'    border-collapse: collapse;',
'    margin: 10px 0;',
'}',
'',
'.isolation-table th {',
'    background: #003366;',
'    color: white;',
'    padding: 10px 15px;',
'    text-align: left;',
'    font-weight: 600;',
'}',
'',
'.isolation-table td {',
'    padding: 8px 15px;',
'    border-bottom: 1px solid #e0e0e0;',
'}',
'',
'.isolation-table tr:nth-child(even) {',
'    background: #f8f9fa;',
'}',
'',
'.row-number {',
'    width: 40px;',
'    text-align: center;',
'    font-weight: 600;',
'    color: #003366;',
'}',
'',
'/* ---- Permit Photo Gallery ---- */',
'.ptw-photo-grid {',
'    display: grid;',
'    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));',
'    gap: 1rem;',
'    padding: 0.5rem 0;',
'}',
'',
'.ptw-photo-card {',
'    border: 1px solid var(--ut-component-border-color, #e0e0e0);',
'    border-radius: 8px;',
'    overflow: hidden;',
'    background: var(--ut-component-background-color, #fff);',
'    display: flex;',
'    flex-direction: column;',
'}',
'',
'.ptw-photo-thumb {',
'    width: 100%;',
'    height: 130px;',
'    object-fit: cover;',
'    display: block;',
'    transition: opacity 0.2s;',
'}',
'',
'.ptw-photo-thumb:hover { opacity: 0.82; }',
'',
'.ptw-photo-meta {',
'    padding: 0.4rem 0.6rem;',
'    font-size: 0.75rem;',
'    color: var(--ut-component-font-color-muted, #666);',
'    display: flex;',
'    flex-direction: column;',
'    gap: 2px;',
'    flex: 1;',
'}',
'',
'.ptw-photo-caption {',
'    font-weight: 600;',
'    color: var(--ut-component-font-color, #333);',
'    font-size: 0.8rem;',
'}',
'',
'.ptw-photo-date { font-size: 0.7rem; }',
'.ptw-photo-user { font-size: 0.7rem; font-style: italic; }',
'',
'.ptw-delete-photo {',
'    margin: 0.4rem;',
'    font-size: 0.75rem !important;',
'}',
'',
'.ptw-no-photos {',
'    color: var(--ut-component-font-color-muted, #888);',
'    font-style: italic;',
'    padding: 0.5rem 0;',
'    margin: 0;',
'}',
'',
'@media (max-width: 420px) {',
'    .ptw-photo-grid { grid-template-columns: 1fr 1fr; }',
'}',
'',
unistr('/* \2500\2500 File upload controls \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500 */'),
'.ptw-upload-controls {',
'    margin-bottom: 1rem;',
'}',
'.ptw-upload-row {',
'    display: flex;',
'    gap: 0.6rem;',
'    flex-wrap: wrap;',
'}',
'.ptw-upload-row .t-Button {',
'    flex: 1;',
'    min-width: 130px;',
'}',
'',
unistr('/* \2500\2500 File type icons in gallery \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500 */'),
'.ptw-file-icon {',
'    display: flex;',
'    align-items: center;',
'    justify-content: center;',
'    height: 130px;',
'    font-size: 3rem;',
'    background: #f0f4f8;',
'    color: #4A5568;',
'}',
'.ptw-file-icon.icon-pdf  { color: #C0392B; }',
'.ptw-file-icon.icon-word { color: #1F4E79; }',
'.ptw-file-icon.icon-excel{ color: #1E7A4E; }',
'.ptw-file-icon.icon-img  { color: #0D7377; }',
'',
unistr('/* \2500\2500 Lightbox \2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500\2500 */'),
'#ptw-lightbox {',
'    position: fixed;',
'    inset: 0;',
'    background: rgba(0,0,0,0.88);',
'    z-index: 9999;',
'    display: flex;',
'    align-items: center;',
'    justify-content: center;',
'    padding: 1rem;',
'}',
'#ptw-lightbox-inner {',
'    position: relative;',
'    max-width: 95vw;',
'    max-height: 90vh;',
'    display: flex;',
'    flex-direction: column;',
'    align-items: center;',
'}',
'#ptw-lightbox-close {',
'    position: absolute;',
'    top: -2.5rem;',
'    right: 0;',
'    background: none;',
'    border: none;',
'    color: #fff;',
'    font-size: 1.8rem;',
'    cursor: pointer;',
'    padding: 0.25rem 0.5rem;',
'    line-height: 1;',
'}',
'#ptw-lightbox-img {',
'    max-width: 100%;',
'    max-height: 80vh;',
'    border-radius: 4px;',
'    object-fit: contain;',
'}',
'#ptw-lightbox-caption {',
'    color: #ddd;',
'    margin-top: 0.5rem;',
'    font-size: 0.9rem;',
'    text-align: center;',
'}',
'',
'.photo-help {',
'    background: var(--ut-palette-warning-light, #fff8e1);',
'    border-left: 4px solid var(--ut-palette-warning, #f0ad4e);',
'    padding: 1rem 1.25rem;',
'    border-radius: 0 6px 6px 0;',
'    margin-bottom: 1rem;',
'    font-size: 0.9rem;',
'    color: var(--ut-component-font-color, #333333);',
'    line-height: 1.5;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_read_only_when_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_read_only_when=>'P4_WORKFLOW_STATUS'
,p_read_only_when2=>'IN_PROGRESS'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27017411932886525)
,p_plug_name=>'SyncStatus'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>130
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div id="connection-status" style="padding: 10px; margin-bottom: 10px; border-radius: 4px;">',
'    <span id="status-icon"></span>',
'    <span id="status-text"></span>',
'    <!-- <button id="sync-btn" style="margin-left: 10px; display: none;">Sync Now</button> -->',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27017917969886530)
,p_plug_name=>'Workflow Status'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>140
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="ptw-workflow-progress">',
'    <div class="workflow-step completed" data-step="1">',
'        <span class="step-icon">&#10003;</span>',
'        <span class="step-text">Site & Work Details</span>',
'    </div>',
'    <div class="workflow-step completed" data-step="2">',
'        <span class="step-icon">&#10003;</span>',
'        <span class="step-text">Control Measures</span>',
'    </div>',
'    <div class="workflow-step active" data-step="3">',
'        <span class="step-icon">3</span>',
'        <span class="step-text">Equipment Isolation</span>',
'    </div>',
'    <div class="workflow-step" data-step="4">',
'        <span class="step-icon">4</span>',
'        <span class="step-text">Authorisation</span>',
'    </div>',
'    <div class="workflow-step" data-step="5">',
'        <span class="step-icon">5</span>',
'        <span class="step-text">Clearance</span>',
'    </div>',
'</div>',
'',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27018145295886532)
,p_plug_name=>'Permit Information Badge'
,p_plug_display_sequence=>150
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="margin-bottom: 20px;">',
'    <span class="apex-badge" style="background-color: #3ea055; color: white; padding: 6px 16px; border-radius: 20px; font-weight: 600;">',
'        Permit: &P4_PERMIT_NUMBER.',
'    </span>',
'</div>'))
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P4_PERMIT_NUMBER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27018342698886534)
,p_plug_name=>'Equipment Isolation Table'
,p_title=>'Equipment Isolation Details'
,p_icon_css_classes=>'fa-lock'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>170
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27019604951886547)
,p_plug_name=>'Comments'
,p_title=>'Comments and References'
,p_icon_css_classes=>'fa-comment'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>180
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(40556697430170648)
,p_plug_name=>'Permit Photos'
,p_title=>'Permit Files'
,p_parent_plug_id=>wwv_flow_imp.id(27019604951886547)
,p_icon_css_classes=>'fa-camera'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>50
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('<!-- Hidden file inputs \2014 triggered by buttons below -->'),
'<input type="file"',
'       id="ptw-file-input"',
'       accept=".pdf,.doc,.docx,.xls,.xlsx,.jpg,.jpeg,.png,.gif,.webp"',
'       style="display:none">',
'',
'<input type="file"',
'       id="ptw-camera-input"',
'       accept="image/*"',
'       capture="environment"',
'       style="display:none">',
'',
'<!-- Expose workflow status for JS visibility control -->',
'<span id="ptw-workflow-status"',
'      data-status="&P4_WORKFLOW_STATUS."',
'      style="display:none;"></span>',
'',
'<!-- Upload controls -->',
'<div class="ptw-upload-controls">',
'    <div class="ptw-upload-row">',
'        <button type="button"',
'                id="btn-attach-file"',
'                class="t-Button t-Button--primary t-Button--iconLeft"',
'                onclick="document.getElementById(''ptw-file-input'').click()">',
'            <span class="t-Icon fa fa-paperclip"></span>',
'            Attach File',
'        </button>',
'',
'        <button type="button"',
'                id="btn-take-photo"',
'                class="t-Button t-Button--primary t-Button--iconLeft"',
'                onclick="document.getElementById(''ptw-camera-input'').click()">',
'            <span class="t-Icon fa fa-camera"></span>',
'            Take Photo',
'        </button>',
'    </div>',
'',
'    <div class="ptw-caption-row">',
'        <input type="text"',
'               id="ptw-caption-input"',
'               class="apex-item-text"',
'               placeholder="Caption / description (optional)"',
'               maxlength="500"',
'               style="width:100%; margin-top:0.5rem;">',
'    </div>',
'',
'    <div id="ptw-selected-file-info" style="display:none; margin-top:0.4rem;">',
'        <span class="t-Icon fa fa-file-o"></span>',
'        <span id="ptw-selected-file-name" style="font-size:0.85rem; color:#555;"></span>',
'        <button type="button"',
'                id="btn-upload-file"',
'                class="t-Button t-Button--hot t-Button--slim t-Button--iconLeft"',
'                style="margin-left:0.75rem;">',
'            <span class="t-Icon fa fa-upload"></span>',
'            Upload',
'        </button>',
'    </div>',
'</div>',
'',
'<hr style="margin: 1rem 0; border-color: #e0e0e0;">',
'',
'<div class="photo-help">',
'    <strong>Attaching files to this permit:</strong>',
'    Tap <strong>Attach File</strong> to upload a PDF, Word or Excel document, or an image from your device.',
'    Tap <strong>Take Photo</strong> to use your camera directly.',
'    <br>',
unistr('    <span class="fa fa-file-image-o"></span> <strong>Images</strong> \2014 tap to view full screen &nbsp;&nbsp;'),
unistr('    <span class="fa fa-file-pdf-o"></span> <strong>PDFs</strong> \2014 tap to open in a new tab &nbsp;&nbsp;'),
'    <span class="fa fa-file-word-o"></span>',
unistr('    <span class="fa fa-file-excel-o"></span> <strong>Word &amp; Excel</strong> \2014 tap to download'),
'</div>',
'',
'<!-- Gallery -->',
'<div id="ptw-photo-gallery">',
'    <p class="ptw-no-photos">Loading files...</p>',
'</div>',
'',
'<!-- Lightbox overlay for images -->',
'<div id="ptw-lightbox" style="display:none;"',
'     onclick="if(event.target===this)ptwCloseLightbox()">',
'    <div id="ptw-lightbox-inner">',
'        <button type="button"',
'                id="ptw-lightbox-close"',
'                onclick="ptwCloseLightbox()"',
'                aria-label="Close">',
'            <span class="fa fa-times"></span>',
'        </button>',
'        <img id="ptw-lightbox-img" src="" alt="File preview">',
'        <div id="ptw-lightbox-caption"></div>',
'    </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27019835346886549)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>190
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27353028511033401)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(27019835346886549)
,p_button_name=>'SAVE_DRAFT'
,p_button_static_id=>'BTN_SAVE_DRAFT_P4'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save Draft'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27353109498033402)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(27019835346886549)
,p_button_name=>'NEXT_STEP'
,p_button_static_id=>'BTN_NEXT_STEP_P4'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Next Step'
,p_button_position=>'NEXT'
,p_icon_css_classes=>'fa-arrow-right'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27019975461886550)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(27019835346886549)
,p_button_name=>'BACK'
,p_button_static_id=>'BTN_BACK_P4'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Back'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:P3_PERMIT_ID:&P4_PERMIT_ID.'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(27353640786033407)
,p_branch_name=>'Refresh Current Page (SAVE_DRAFT)'
,p_branch_action=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4:P4_PERMIT_ID:&P4_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'SAVE_DRAFT'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(27355396888033424)
,p_branch_name=>'Go to Authorisation (NEXT_STEP)'
,p_branch_action=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_PERMIT_ID:&P4_PERMIT_ID.'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>20
,p_branch_condition_type=>'REQUEST_EQUALS_CONDITION'
,p_branch_condition=>'NEXT_STEP'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27016408036886515)
,p_name=>'P4_PERMIT_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27016543785886516)
,p_name=>'P4_PERMIT_NUMBER'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27016635165886517)
,p_name=>'P4_WORKFLOW_STATUS'
,p_item_sequence=>50
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27016711172886518)
,p_name=>'P4_NEXT_STEP'
,p_item_sequence=>60
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27017550498886526)
,p_name=>'P4_ISO_1_ID'
,p_item_sequence=>90
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27017612768886527)
,p_name=>'P4_ISO_2_ID'
,p_item_sequence=>100
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27017746971886528)
,p_name=>'P4_ISO_3_ID'
,p_item_sequence=>110
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27017866743886529)
,p_name=>'P4_ISO_4_ID'
,p_item_sequence=>120
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27018057140886531)
,p_name=>'P4_CURRENT_STEP'
,p_item_sequence=>70
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27018457939886535)
,p_name=>'P4_ISO_1_EQUIPMENT'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Equipment Isolated (Row 1)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_colspan=>5
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27018568710886536)
,p_name=>'P4_ISO_1_MEANS'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Means of Isolation (Row 1)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_begin_on_new_line=>'N'
,p_colspan=>5
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27018618101886537)
,p_name=>'P4_ISO_1_LOCK_NO'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Safety Lock No. (Row 1)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27018795561886538)
,p_name=>'P4_ISO_2_EQUIPMENT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Equipment Isolated (Row 2)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_colspan=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27018813428886539)
,p_name=>'P4_ISO_2_MEANS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Means of Isolation (Row 2)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_begin_on_new_line=>'N'
,p_colspan=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27018963903886540)
,p_name=>'P4_ISO_2_LOCK_NO'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Safety Lock No. (Row 2)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27019093609886541)
,p_name=>'P4_ISO_3_EQUIPMENT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Equipment Isolated (Row 3)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_colspan=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27019124716886542)
,p_name=>'P4_ISO_3_MEANS'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Means of Isolation (Row 3)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_begin_on_new_line=>'N'
,p_colspan=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27019250959886543)
,p_name=>'P4_ISO_3_LOCK_NO'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Safety Lock No. (Row 3)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27019329194886544)
,p_name=>'P4_ISO_4_EQUIPMENT'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Equipment Isolated (Row 4)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_colspan=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27019475030886545)
,p_name=>'P4_ISO_4_MEANS'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Means of Isolation (Row 4)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>200
,p_begin_on_new_line=>'N'
,p_colspan=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27019534738886546)
,p_name=>'P4_ISO_4_LOCK_NO'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(27018342698886534)
,p_prompt=>'Safety Lock No. (Row 4)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27019719187886548)
,p_name=>'P4_COMMENTS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(27019604951886547)
,p_prompt=>'Comments and references to associated safety documentation, including risk assessments, method statements and other permits. '
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>4000
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'N',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(30143438995642703)
,p_name=>'P4_IS_CHANGED'
,p_item_sequence=>80
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40555827392170640)
,p_name=>'P4_PHOTO_CAPTION'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(27019604951886547)
,p_prompt=>'Photo Caption (optional)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>500
,p_display_when_type=>'NEVER'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(27353229062033403)
,p_validation_name=>'Permit ID Required'
,p_validation_sequence=>10
,p_validation=>'P4_PERMIT_ID'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Permit ID is required.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(30158963221375313)
,p_name=>'Capture Location and Submit page'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(27353109498033402)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30159344777375310)
,p_event_id=>wwv_flow_imp.id(30158963221375313)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P4_IS_CHANGED'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'captureLocationThenSubmit(''NEXT_STEP'');',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33350285133951416)
,p_name=>'Capture Location and Save Draft'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(27353028511033401)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33350358017951417)
,p_event_id=>wwv_flow_imp.id(33350285133951416)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'captureLocationThenSubmit(''SAVE_DRAFT'');'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(40556210605170644)
,p_name=>'Load gallery on Page Load'
,p_event_sequence=>30
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(40556395946170645)
,p_event_id=>wwv_flow_imp.id(40556210605170644)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var permitId = apex.item(''P4_PERMIT_ID'').getValue();',
'if (permitId) {',
'    loadPermitPhotos(permitId);',
'}'))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27353441963033405)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Equipment Isolation and Comments'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    -- Helper procedure to save one isolation row',
'    PROCEDURE save_isolation_row(',
'        p_iso_id     IN OUT NUMBER,',
'        p_permit_id  IN NUMBER,',
'        p_row_num    IN NUMBER,',
'        p_equipment  IN VARCHAR2,',
'        p_means      IN VARCHAR2,',
'        p_lock_no    IN VARCHAR2',
'    ) IS',
'    BEGIN',
'        IF p_equipment IS NOT NULL OR p_means IS NOT NULL OR p_lock_no IS NOT NULL THEN',
'            IF p_iso_id IS NULL THEN',
'                -- INSERT',
'                INSERT INTO ptw_pro.ptw_lv_equipment_isolation (',
'                    permit_id, row_number, equipment_isolated, means_of_isolation, safety_lock_no',
'                ) VALUES (',
'                    p_permit_id, p_row_num, p_equipment, p_means, p_lock_no',
'                ) RETURNING isolation_id INTO p_iso_id;',
'            ELSE',
'                -- UPDATE only if something changed',
'                UPDATE ptw_pro.ptw_lv_equipment_isolation',
'                SET    equipment_isolated = p_equipment,',
'                       means_of_isolation = p_means,',
'                       safety_lock_no     = p_lock_no,',
'                       modified_date      = CURRENT_TIMESTAMP',
'                WHERE  isolation_id = p_iso_id',
'                AND (',
'                    NVL(equipment_isolated, ''x'') != NVL(p_equipment, ''x'') OR',
'                    NVL(means_of_isolation, ''x'') != NVL(p_means,     ''x'') OR',
'                    NVL(safety_lock_no,     ''x'') != NVL(p_lock_no,   ''x'')',
'                );',
'            END IF;',
'        ELSIF p_iso_id IS NOT NULL THEN',
'            -- All fields cleared - delete the row',
'            DELETE FROM ptw_pro.ptw_lv_equipment_isolation',
'            WHERE isolation_id = p_iso_id;',
'            p_iso_id := NULL;',
'        END IF;',
'    END save_isolation_row;',
'',
'BEGIN',
'  IF :P4_WORKFLOW_STATUS = ''IN_PROGRESS'' THEN',
'    -- Save each isolation row',
'    save_isolation_row(:P4_ISO_1_ID, :P4_PERMIT_ID, 1, :P4_ISO_1_EQUIPMENT, :P4_ISO_1_MEANS, :P4_ISO_1_LOCK_NO);',
'    save_isolation_row(:P4_ISO_2_ID, :P4_PERMIT_ID, 2, :P4_ISO_2_EQUIPMENT, :P4_ISO_2_MEANS, :P4_ISO_2_LOCK_NO);',
'    save_isolation_row(:P4_ISO_3_ID, :P4_PERMIT_ID, 3, :P4_ISO_3_EQUIPMENT, :P4_ISO_3_MEANS, :P4_ISO_3_LOCK_NO);',
'    save_isolation_row(:P4_ISO_4_ID, :P4_PERMIT_ID, 4, :P4_ISO_4_EQUIPMENT, :P4_ISO_4_MEANS, :P4_ISO_4_LOCK_NO);',
'',
'    -- Save comments on permits table',
'    UPDATE ptw_pro.ptw_lv_permits',
'    SET comments = :P4_COMMENTS,',
'        current_step = :P4_CURRENT_STEP,',
'        equip_iso_latitude = :APP_LATITUDE,',
'        equip_iso_longitude = :APP_LONGITUDE,',
'        modified_by = NVL(V(''APP_USER''), USER),',
'        modified_date = CURRENT_TIMESTAMP',
'    WHERE permit_id = :P4_PERMIT_ID;',
'',
'    COMMIT;',
'  END IF;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message => ''Error saving equipment isolation data: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RAISE;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Equipment isolation data saved successfully.'
,p_security_scheme=>wwv_flow_imp.id(31533963716212424)
,p_internal_uid=>27353441963033405
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27353350362033404)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Equipment Isolation Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'',
'    :P4_CURRENT_STEP := ''EQUIP_ISOLATION'';',
'    -- Load permit info',
'    SELECT permit_number, comments, workflow_status',
'    INTO :P4_PERMIT_NUMBER, :P4_COMMENTS, :P4_WORKFLOW_STATUS',
'    FROM ptw_pro.ptw_lv_permits',
'    WHERE permit_id = :P4_PERMIT_ID;',
'',
'    -- Load isolation rows (up to 4)',
'    FOR r IN (',
'        SELECT isolation_id, row_number, equipment_isolated, means_of_isolation, safety_lock_no',
'        FROM ptw_pro.ptw_lv_equipment_isolation',
'        WHERE permit_id = :P4_PERMIT_ID',
'        ORDER BY row_number',
'    ) LOOP',
'        CASE r.row_number',
'            WHEN 1 THEN',
'                :P4_ISO_1_ID := r.isolation_id;',
'                :P4_ISO_1_EQUIPMENT := r.equipment_isolated;',
'                :P4_ISO_1_MEANS := r.means_of_isolation;',
'                :P4_ISO_1_LOCK_NO := r.safety_lock_no;',
'            WHEN 2 THEN',
'                :P4_ISO_2_ID := r.isolation_id;',
'                :P4_ISO_2_EQUIPMENT := r.equipment_isolated;',
'                :P4_ISO_2_MEANS := r.means_of_isolation;',
'                :P4_ISO_2_LOCK_NO := r.safety_lock_no;',
'            WHEN 3 THEN',
'                :P4_ISO_3_ID := r.isolation_id;',
'                :P4_ISO_3_EQUIPMENT := r.equipment_isolated;',
'                :P4_ISO_3_MEANS := r.means_of_isolation;',
'                :P4_ISO_3_LOCK_NO := r.safety_lock_no;',
'            WHEN 4 THEN',
'                :P4_ISO_4_ID := r.isolation_id;',
'                :P4_ISO_4_EQUIPMENT := r.equipment_isolated;',
'                :P4_ISO_4_MEANS := r.means_of_isolation;',
'                :P4_ISO_4_LOCK_NO := r.safety_lock_no;',
'        END CASE;',
'    END LOOP;',
'',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        apex_error.add_error(',
'            p_message => ''Permit not found.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P4_PERMIT_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>27353350362033404
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(30143977664642708)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Engineer Own Permit Check'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_is_engineer NUMBER;',
'    v_is_owner    NUMBER;',
'    v_is_auth     NUMBER;',
'BEGIN',
'    SELECT COUNT(*) INTO v_is_engineer',
'    FROM   ptw_pro.ptw_lv_user_roles_v          -- changed',
'    WHERE  UPPER(username) = UPPER(V(''APP_USER''))',
'    AND    role_name = ''ENGINEER''',
'    AND    is_active = ''Y'';',
'',
'    IF v_is_engineer > 0 AND :P3_PERMIT_ID IS NOT NULL THEN  -- use correct Pn_PERMIT_ID per page',
'',
'        SELECT COUNT(*) INTO v_is_owner',
'        FROM   ptw_pro.ptw_lv_permits',
'        WHERE  permit_id = :P4_PERMIT_ID         -- use correct Pn_PERMIT_ID per page',
'        AND    UPPER(created_by) = UPPER(V(''APP_USER''));',
'',
'        IF v_is_owner = 0 THEN',
'',
'          SELECT COUNT(*) INTO v_is_auth ',
'          FROM   ptw_pro.ptw_lv_permits',
'          WHERE  permit_id = :P4_PERMIT_ID',
'          AND    NVL(UPPER(auth_person_name),''XXX'') = UPPER(V(''APP_USER''));  -- check if the engineer is the auth_person',
'',
'          IF v_is_auth = 0 THEN',
'            apex_error.add_error(',
'                p_message          => ''Access denied. You can only edit permits you have created.'',',
'                p_display_location => apex_error.c_inline_in_notification',
'            );',
'            apex_util.redirect_url(',
'                apex_page.get_url(p_page => 1)',
'            );',
'          END IF;',
'        END IF;',
'    END IF;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P4_PERMIT_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>30143977664642708
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(40555468663170636)
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
'        apex_json.write(''message'', ''No file data received.'');        -- CHANGED',
'        apex_json.close_object;',
'        RETURN;',
'    END IF;',
'',
'    -- Reassemble the base64 CLOB from the f01 array chunks',
'    DBMS_LOB.CREATETEMPORARY(l_b64_clob, FALSE, DBMS_LOB.SESSION);',
'    FOR i IN 1 .. apex_application.g_f01.COUNT LOOP',
'        l_token := apex_application.g_f01(i);',
'        IF LENGTH(l_token) > 0 THEN',
'            DBMS_LOB.WRITEAPPEND(l_b64_clob, LENGTH(l_token), l_token);',
'        END IF;',
'    END LOOP;',
'',
'    -- Convert base64 CLOB to BLOB',
'    l_blob := apex_web_service.clobbase642blob(l_b64_clob);',
'    DBMS_LOB.FREETEMPORARY(l_b64_clob);',
'',
'    -- ADDED: 20MB size guard',
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
'        NVL(l_mime_type, ''application/octet-stream''),    -- CHANGED',
'        NVL(l_file_name, ''attachment''),                   -- CHANGED',
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
'    apex_json.write(''message'', ''File uploaded successfully.'');        -- CHANGED',
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
,p_internal_uid=>40555468663170636
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(40555524689170637)
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
'                p_values => r.photo_id',
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
,p_internal_uid=>40555524689170637
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(40555666162170638)
,p_process_sequence=>30
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'DELETE_PERMIT_PHOTO'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_photo_id  NUMBER := TO_NUMBER(apex_application.g_x01);',
'    l_app_user  VARCHAR2(255) := NVL(V(''APP_USER''), USER);',
'    l_can_delete NUMBER;',
'BEGIN',
'    -- Check permission: uploader can always delete their own',
'    -- Admin and Contract Support can delete any file',
'    SELECT COUNT(*)',
'    INTO   l_can_delete',
'    FROM   ptw_pro.ptw_lv_permit_photos ph',
'    WHERE  ph.photo_id = l_photo_id',
'    AND    (',
unistr('               -- Own file \2014 any role'),
'               UPPER(ph.uploaded_by) = UPPER(l_app_user)',
'               OR',
unistr('               -- Admin or Contract Support \2014 can delete any file'),
'               EXISTS (',
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
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>40555666162170638
);
wwv_flow_imp.component_end;
end;
/
