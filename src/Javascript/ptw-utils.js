/**
 * ptw-utils.js
 * PTW LV-Electrical - Shared Utility Functions
 * Upload to: Shared Components > Static Application Files
 * Reference: #APP_FILES#ptw-utils#MIN#.js on Page 0
 */

function captureLocationThenSubmit(request, callback) {

    function doSubmit() {
        if (typeof callback === 'function') {
            callback(request);
        } else {
            apex.page.submit(request);
        }
    }

    if (!navigator.geolocation) {
        console.warn('Geolocation not supported - submitting without coordinates.');
        doSubmit();
        return;
    }

    navigator.geolocation.getCurrentPosition(
        function(position) {
            apex.item('P0_LATITUDE').setValue(position.coords.latitude);
            apex.item('P0_LONGITUDE').setValue(position.coords.longitude);
            console.log('Location captured: ' + position.coords.latitude + ', ' + position.coords.longitude);
            doSubmit();
        },
        function(error) {
            console.warn('Geolocation error (' + error.code + '): ' + error.message);
            apex.item('P0_LATITUDE').setValue('');
            apex.item('P0_LONGITUDE').setValue('');
            doSubmit();
        },
        {
            enableHighAccuracy: true,
            timeout: 8000,
            maximumAge: 0
        }
    );
}
