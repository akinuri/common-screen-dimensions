// copy/paste into console at http://screensiz.es/

function qs(q, parent) {
    if (parent)
        return parent.querySelectorAll(q);
    return document.querySelectorAll(q);
}
    
function downloadText(text, fileName) {
    var blob      = new Blob([text], {type: "text/plain"});
    var link      = document.createElement("a");
    link.href     = window.URL.createObjectURL(blob);
    link.download = fileName;
    link.click();
}

var rows = Array.from(qs("#device_info tbody tr"));

var devices = [];

rows.forEach(function (row) {
    var px_den = parseInt(qs(".px_width-value", row)[0].innerText) / parseInt(qs(".device_width-value", row)[0].innerText);
    var device = {
        "Device Name"     : qs(".name", row)[0].innerText,
        "Platform"        : qs(".operating_system-value ", row)[0].innerText,
        "Portrait Width"  : qs(".device_width-value", row)[0].innerText,
        "Landscape Width" : Math.round(parseInt(qs(".px_height-value", row)[0].innerText) * (1 / px_den)) + "",
    };
    devices.push(device);
});

var json = JSON.stringify(devices, null, "\t");

downloadText(json, "devices.json");