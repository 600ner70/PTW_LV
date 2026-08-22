// ============================================================
// File: geolocation.js
// Description: Captures GPS coordinates into APEX page items
// Upload to: Shared Components > Static Application Files
// Reference as: #APP_FILES#geolocation.js
// ============================================================

var AppGeo = AppGeo || {};

AppGeo.captureLocation = function(latItemName, lngItemName) {

    console.log("captureLocation called with:", latItemName, lngItemName);

  if (!navigator.geolocation) {
    apex.message.alert("Geolocation is not supported by this browser.");
    return;
  }

  console.log("Calling getCurrentPosition...");

  navigator.geolocation.getCurrentPosition(
    function(position) {
      var lat = position.coords.latitude;
      var lng = position.coords.longitude;

      console.log("latitude:", lat);
      console.log("longitude", lng);

      apex.item(latItemName).setValue(lat);
      apex.item(lngItemName).setValue(lng);

    },
function(error) {
  console.log("Geolocation error code: " + error.code + " - " + error.message);
  switch (error.code) {
    case error.PERMISSION_DENIED:
      apex.message.alert("Location access was denied by the user.");
      break;
    case error.POSITION_UNAVAILABLE:
      apex.message.alert("Location information is unavailable.");
      break;
    case error.TIMEOUT:
      apex.message.alert("The request to get location timed out.");
      break;
    default:
      apex.message.alert("An unknown error occurred while retrieving location.");
  }
},
    {
      enableHighAccuracy: false,
      timeout: 10000,
      maximumAge: 0
    }
  );
  console.log("getCurrentPosition called, waiting for response...");
};