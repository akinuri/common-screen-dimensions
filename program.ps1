
if (!(Test-Path -Path "devices.json" -PathType Leaf)) {
    $WebClient = New-Object system.Net.WebClient;
    $WebClient.downloadFile("http://viewportsizes.com/devices.json", "devices.json")
}

$json = (Get-Content "devices.json") -join "`n" | ConvertFrom-Json

$dimensions = @{}

$json | ForEach-Object {
    $width  = $_."Portrait Width"
    $height = $_."Landscape Width"
    
    if ($width -ne "NA" -and $width -ne "-") {
        if (!$dimensions.ContainsKey($width)) {
            $dimensions.Add($width, 1);
        } else {
            $old_value = $dimensions.Get_Item($width);
            $dimensions.Set_Item($width, $old_value + 1);
        }
    }
    if ($height -ne "NA" -and $height -ne "-") {
        if (!$dimensions.ContainsKey($height)) {
            $dimensions.Add($height, 1);
        } else {
            $old_value = $dimensions.Get_Item($height);
            $dimensions.Set_Item($height, $old_value + 1);
        }
    }
}

$dimensions = $dimensions.GetEnumerator() | Sort-Object @{Expression = {$_.Value}; Descending = $True}, @{Expression = {[int]$_.Key}; Descending = $True} 

if (Test-Path -Path "dimensions.txt" -PathType Leaf) {
    Remove-Item -Path "dimensions.txt"
}

($dimensions | Format-Table | Out-String) | Out-File -FilePath "dimensions.txt"

Start-Process -FilePath "C:\Windows\notepad.exe" -ArgumentList "dimensions.txt"

# Read-Host -Prompt "Press Enter to exit"
