// PTW Offline Navigation
// Pre-caches workflow pages while connected so navigation works when signal drops.
var PTWOfflineNav = {

    // Add new page IDs here as the app grows.
    pageIds: [1, 2, 3, 4, 5, 9, 10],

    // Must match PTW_CACHE in the service worker hooks (Function and Variable Declaration).
    cacheName: 'ptw-nav-v1',

    init: function () {
        if (!('caches' in window)) return;
        var self = this;
        if (navigator.onLine) self.preCachePages();
        // Re-cache whenever connectivity is restored mid-session.
        window.addEventListener('online', function () { self.preCachePages(); });
    },

    // Normalise APEX URL to app:page only.
    // Must produce the same key as ptwCacheKey() in the service worker hooks.
    cacheKey: function (url) {
        try {
            var u = new URL(url);
            var parts = (u.searchParams.get('p') || '').split(':');
            return u.origin + u.pathname + '?p=' + parts[0] + ':' + parts[1];
        } catch (e) { return url; }
    },

    // Build the full URL for each page using the current session's URL as a template.
    buildUrls: function () {
        var urls = [];
        var href = window.location.href;

        // Classic APEX URL format: f?p=APP_ID:PAGE_ID:SESSION:REQUEST:...
        if (/[?&]p=\d+:\d+:/.test(href)) {
            this.pageIds.forEach(function (id) {
                // Replace only the PAGE_ID segment, preserving session and everything else.
                urls.push(href.replace(/([?&]p=\d+:)\d+(:)/, '$1' + id + '$2'));
            });
        } else {
            // Friendly URL format: gather navigation links already rendered in the DOM.
            [].forEach.call(document.querySelectorAll('a[href]'), function (a) {
                var h = a.href || '';
                if (h && (h.indexOf('/r/') !== -1 || h.indexOf('f?p=') !== -1)) {
                    if (urls.indexOf(h) === -1) urls.push(h);
                }
            });
        }
        return urls;
    },

    preCachePages: function () {
        var self = this;
        var urls = this.buildUrls();
        if (!urls.length) return;

        // Populate the cache directly from page JS — no postMessage needed.
        caches.open(this.cacheName).then(function (cache) {
            urls.forEach(function (url) {
                var key = self.cacheKey(url);
                fetch(url).then(function (response) {
                    if (response.ok) {
                        cache.put(key, response.clone());
                        console.log('PTW: cached ' + key);
                    }
                }).catch(function () {});
            });
        });
    }
};

apex.jQuery(document).ready(function () { PTWOfflineNav.init(); });
