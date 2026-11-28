/* =====================================================================
   PTW-PRO | Authority to Work - pass page + verify scanner
   Upload: Shared Components > Static Application Files (ptw-atw.js)
   Reference on pages 34 and 37 only (not Page 0):
     JavaScript > File URLs: #APP_FILES#ptw-atw#MIN#.js
   Page 37 also needs #APP_FILES#jsQR.min.js listed BEFORE this file
   (QR decoder for iPhone/iPad; Chrome/Android use the built-in one).
   Uses native APEX JS APIs only (apex.region, apex.item, apex.page,
   apex.message).
   ===================================================================== */
window.ptwAtw = (function () {
    "use strict";

    var clockTimer = null,
        refreshTimer = null,
        wakeLock = null;

    function pad(n) { return (n < 10 ? "0" : "") + n; }

    function deviceToday() {
        var d = new Date();
        return d.getFullYear() + "-" + pad(d.getMonth() + 1) + "-" + pad(d.getDate());
    }

    /* Live clock in every pass on the page (survives region refresh because
       it re-queries the DOM each tick). Also expires a cached pass from a
       previous day when the device is offline and the server can't say so. */
    function tick() {
        var now = new Date(),
            txt = pad(now.getHours()) + ":" + pad(now.getMinutes()) + ":" + pad(now.getSeconds()),
            today = deviceToday();

        document.querySelectorAll(".ptw-atw-pass").forEach(function (pass) {
            var clock = pass.querySelector(".ptw-atw-clock");
            if (clock) { clock.textContent = txt; }

            var validDate = pass.getAttribute("data-valid-date");
            var live = ["ON_SITE", "ISSUED", "CHECKED_OUT"].indexOf(pass.getAttribute("data-status")) > -1;
            if (live && validDate && validDate < today && !pass.classList.contains("ptw-atw--expired")) {
                pass.className = pass.className.replace(/ptw-atw--\w+/, "ptw-atw--expired");
                var strong = pass.querySelector(".ptw-atw-status-text strong");
                var small = pass.querySelector(".ptw-atw-status-text small");
                if (strong) { strong.textContent = "Expired"; }
                if (small) { small.textContent = "This pass was for a previous day"; }
            }
        });
    }

    function setOfflineBanner() {
        var offline = !navigator.onLine;
        document.querySelectorAll(".ptw-atw-offline").forEach(function (el) {
            el.hidden = !offline;
        });
    }

    /* Keep the screen on while the pass is shown. Progressive enhancement:
       silently does nothing where the Screen Wake Lock API isn't available. */
    function requestWakeLock() {
        if (!("wakeLock" in navigator) || document.visibilityState !== "visible") { return; }
        navigator.wakeLock.request("screen").then(function (lock) {
            wakeLock = lock;
        }).catch(function () { /* not allowed / not supported - ignore */ });
    }

    /**
     * Pass page (34). regionStaticId = Static ID of the dynamic content
     * region that calls ptw_atw_pkg.render_pass.
     */
    function initPass(regionStaticId, refreshSeconds) {
        tick();
        setOfflineBanner();
        clearInterval(clockTimer);
        clockTimer = setInterval(tick, 1000);

        window.addEventListener("online", setOfflineBanner);
        window.addEventListener("offline", setOfflineBanner);

        // Pull fresh status (e.g. revoked by BGIS) while the pass is open
        clearInterval(refreshTimer);
        refreshTimer = setInterval(function () {
            if (navigator.onLine && document.visibilityState === "visible") {
                apex.region(regionStaticId).refresh();
            }
        }, (refreshSeconds || 60) * 1000);

        requestWakeLock();
        document.addEventListener("visibilitychange", function () {
            if (document.visibilityState === "visible") {
                requestWakeLock();
                if (navigator.onLine) { apex.region(regionStaticId).refresh(); }
            }
        });

        // After each refresh the offline banner element is new
        apex.jQuery("#" + regionStaticId).on("apexafterrefresh", function () {
            tick();
            setOfflineBanner();
        });
    }

    /* ------------------------------------------------------------------
       Verify page (37) scanner. Nothing is loaded from outside the app.
       Decoder, in order of preference:
         1. Native BarcodeDetector (Chrome / Android) - built into the browser
         2. jsQR (iPhone / iPad / anything else) - uploaded to Static
            Application Files as jsQR.min.js and referenced on Page 37
       ------------------------------------------------------------------ */
    var stream = null, scanning = false;

    function stopScanner() {
        scanning = false;
        if (stream) {
            stream.getTracks().forEach(function (t) { t.stop(); });
            stream = null;
        }
    }

    function extractToken(text) {
        var m = (text || "").toLowerCase().match(/[0-9a-f]{32}/);
        return m ? m[0] : null;
    }

    /* Returns a function(video) -> Promise<string|null> (decoded text),
       or null if no decoder is available in this browser. */
    function makeDecoder() {
        var nativeDetector = null;

        if ("BarcodeDetector" in window) {
            try { nativeDetector = new window.BarcodeDetector({ formats: ["qr_code"] }); }
            catch (e) { nativeDetector = null; }   // present but QR not supported
        }
        if (nativeDetector) {
            return function (video) {
                return nativeDetector.detect(video).then(function (codes) {
                    return codes.length ? codes[0].rawValue : null;
                });
            };
        }

        if (typeof window.jsQR === "function") {
            var canvas = document.createElement("canvas"),
                ctx = canvas.getContext("2d", { willReadFrequently: true });
            return function (video) {
                var w = video.videoWidth, h = video.videoHeight;
                if (!w || !h) { return Promise.resolve(null); }
                // Downscale to max 640px on the long side: plenty for a QR on a
                // phone screen and keeps each decode fast on older iPhones.
                var scale = Math.min(1, 640 / Math.max(w, h));
                canvas.width = Math.round(w * scale);
                canvas.height = Math.round(h * scale);
                ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
                var img = ctx.getImageData(0, 0, canvas.width, canvas.height);
                // The pass QR is dark-on-light, so skip the inverted pass (2x faster)
                var code = window.jsQR(img.data, img.width, img.height, { inversionAttempts: "dontInvert" });
                return Promise.resolve(code ? code.data : null);
            };
        }
        return null;
    }

    /**
     * videoId     - id of a <video playsinline muted> element
     * msgId       - id of an element for status text
     * tokenItem   - page item to receive the token (e.g. "P37_TOKEN")
     * request     - submit request name (e.g. "VERIFY")
     */
    function initScanner(videoId, msgId, tokenItem, request) {
        var video = document.getElementById(videoId),
            msg = document.getElementById(msgId),
            decode = makeDecoder(),
            busy = false,
            last = 0;

        function say(t) { if (msg) { msg.textContent = t; } }

        if (!decode) {
            say("This browser can't scan codes. Enter the ATW number below instead.");
            return;
        }
        if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
            say("Camera not available. Enter the ATW number below instead.");
            return;
        }

        function found(token) {
            stopScanner();
            if (navigator.vibrate) { navigator.vibrate(60); }
            say("Pass found, checking...");
            var values = {};
            values[tokenItem] = token;
            apex.page.submit({ request: request, set: values, showWait: true });
        }

        function loop(ts) {
            if (!scanning) { return; }
            // ~5 scans per second is plenty and saves battery
            if (!busy && (!ts || ts - last > 200)) {
                last = ts || 0;
                busy = true;
                decode(video).then(function (text) {
                    busy = false;
                    var token = extractToken(text);
                    if (token && scanning) { found(token); }
                }).catch(function () { busy = false; /* frame not ready - keep going */ });
            }
            requestAnimationFrame(loop);
        }

        navigator.mediaDevices.getUserMedia({
            video: { facingMode: { ideal: "environment" } },
            audio: false
        }).then(function (s) {
            stream = s;
            video.srcObject = s;
            video.setAttribute("playsinline", "");   // iOS: don't go full screen
            video.muted = true;
            return video.play();
        }).then(function () {
            scanning = true;
            say("Point the camera at the QR code on the pass.");
            requestAnimationFrame(loop);
        }).catch(function (err) {
            say(err && err.name === "NotAllowedError"
                ? "Camera permission was refused. Allow camera access for this site in your phone settings, or enter the ATW number below."
                : "Could not start the camera. Enter the ATW number below instead.");
        });

        window.addEventListener("pagehide", stopScanner);
        document.addEventListener("visibilitychange", function () {
            if (document.visibilityState === "hidden") { stopScanner(); }
        });
    }

    return {
        initPass: initPass,
        initScanner: initScanner,
        stopScanner: stopScanner
    };
})();
