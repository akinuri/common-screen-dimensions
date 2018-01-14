// copy/paste into console at https://mydevice.io/devices/

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

var rows = Array.from(qs("#sortSmartphones tbody tr"));
rows.concat(Array.from(qs("#sortTablets tbody tr")));

var devices = [];

rows.forEach(function (row) {
    var device = {
        "Device Name"     : qs("td", row)[0].innerText,
        "Portrait Width"  : qs("td", row)[3].innerText,
        "Landscape Width" : qs("td", row)[4].innerText,
    };
    devices.push(device);
});

var json = JSON.stringify(devices, null, "\t");

downloadText(json, "devices_mydevice.io.json");