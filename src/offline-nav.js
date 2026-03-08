// PTW Offline Navigation
// Pre-caches workflow pages while connected so navigation works when signal drops.
var PTWOfflineNav = {

    // Add new page IDs here as the app grows (used for classic f?p= URLs).
    pageIds: [1, 2, 3, 4, 5, 9],

    // Must match the cache name used in the service worker hook.
    cacheName: 'ptw-nav-v1',

    init: function () {
        if (!('caches' in window)) return;
        var self = this;
        if (navigator.onLine) self.preCachePages();
        // Re-cache whenever connectivity is restored mid-session.
        window.addEventListener('online', function () { self.preCachePages(); });
    },

    // Normalise URL to a stable cache key — must produce the same key as
    // the service worker hook so lookups match what was stored.
    cacheKey: function (url) {
        try {
            var u = new URL(url);
            var p = u.searchParams.get('p');
            if (p) {
                // Classic URL: strip session, request, checksum etc.
                return u.origin + u.pathname + '?p=' + p.split(':').slice(0, 2).join(':');
            }
            // Friendly URL: session is in a cookie, not the URL — use as-is.
            return url;
        } catch (e) { return url; }
    },

    // Build the full URL for each page using the current page's URL as a template.
    buildUrls: function () {
        var urls = [];
        var href = window.location.href;

        // Classic APEX URL format: f?p=APP_ID:PAGE_ID:SESSION:REQUEST:...
        if (/[?&]p=\d+:\d+:/.test(href)) {
            this.pageIds.forEach(function (id) {
                urls.push(href.replace(/([?&]p=\d+:)\d+(:)/, '$1' + id + '$2'));
            });
        } else {
            // Friendly URL format: scrape navigation links already in the DOM.
            // These are already correct, fully-qualified URLs with no session token.
            [].forEach.call(document.querySelectorAll('a[href]'), function (a) {
                var h = a.href || '';
                if (h && h.indexOf('/r/') !== -1) {
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
