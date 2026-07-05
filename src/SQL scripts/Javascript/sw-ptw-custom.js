// PTW Service Worker - Custom Hook Code
// ============================================================
// HOW TO INSTALL:
//   App Builder > Shared Components > Progressive Web Application
//   > Service Worker Configuration > Configure Hooks
//
//   1. Function and Variable Declaration  -> leave on Default
//   2. Event: fetch > Configure Hooks > Before -> paste SECTION 1 below
//
// Works for both friendly URLs (/ords/r/permitpro/ptw-pro/dashboard)
// and classic URLs (f?p=105:1:SESSION). Uses request.mode === 'navigate'
// to target full page loads only, ignoring AJAX and resource fetches.
// ============================================================


// ============================================================
// SECTION 1: Event: fetch > Configure Hooks > Before
// ============================================================

if (event.request.method === 'GET' && event.request.mode === 'navigate') {
    try {
        var _u = new URL(event.request.url);
        var _p = _u.searchParams.get('p');
        // Classic URL: strip session so f?p=105:2:ANY_SESSION maps to same entry.
        // Friendly URL: strip ALL query params (session=, cs=, p3_permit_id=, etc.)
        //   so the cache key is just the path, matching what we navigate to offline.
        var _key = _p
            ? _u.origin + _u.pathname + '?p=' + _p.split(':').slice(0, 2).join(':')
            : _u.origin + _u.pathname;
        event.respondWith(
            fetch(event.request)
                .then(function (r) {
                    if (r.ok) {
                        var _clone = r.clone();
                        caches.open('ptw-nav-v1').then(function (c) { c.put(_key, _clone); });
                    }
                    return r;
                })
                .catch(function () {
                    return caches.open('ptw-nav-v1').then(function (c) {
                        return c.match(_key).then(function (r) {
                            return r || new Response(
                                '<html><body style="font-family:sans-serif;padding:2rem"><h2>You are offline</h2><p>This page was not cached before you went offline. Please go back and try again when connected.</p><button onclick="history.back()">Go Back</button></body></html>',
                                { status: 503, headers: { 'Content-Type': 'text/html' } }
                            );
                        });
                    });
                })
        );
        // Neutralise respondWith so APEX's own fetch handler can't call it again on the same event.
        // (APEX injects the Before hook inside an IIFE, so 'return' above only exits that scope;
        //  APEX's outer fetch listener would otherwise throw InvalidStateError.)
        event.respondWith = function () {};
        return;
    } catch (_e) {}
}
