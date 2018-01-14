// copy/paste into console at https://material.io/devices/

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

var rows = Array.from(qs("#main-table .tr.device-row"));

var devices = [];

rows.forEach(function (row) {
    var device = {
        "Device Name"     : qs(".td.device", row)[0].innerText,
        "Platform"        : qs(".td.platform", row)[0].innerText,
        "Portrait Width"  : qs(".td.screen-dp .value-width", row)[0].innerText,
        "Landscape Width" : qs(".td.screen-dp .value-height", row)[0].innerText,
    };
    devices.push(device);
});

var json = JSON.stringify(devices, null, "\t");

downloadText(json, "devices.json");