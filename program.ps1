function readJSON() {
    param($filename)
    return (Get-Content $filename) -join "`n" | ConvertFrom-Json
}

function calcFreq() {
    param($json)
    $dimensions = @{}
    $json | ForEach-Object {
        $width  = $_."Portrait Width"
        $height = $_."Landscape Width"
        
        if ($width -ne "NA" -and $width -ne "-") {
        
            if (!$dimensions.ContainsKey($width)) {
                $dimensions.Add($width, 1)
            } else {
                $new_value = $dimensions.Get_Item($width) + 1
                $dimensions.Set_Item($width, $new_value)
            }
            
            if (!$dims_combined.ContainsKey($width)) {
                $dims_combined.Add($width, 1)
            } else {
                $new_value = $dims_combined.Get_Item($width) + 1
                $dims_combined.Set_Item($width, $new_value)
            }
        }
        
        if ($height -ne "NA" -and $height -ne "-") {
        
            if (!$dimensions.ContainsKey($height)) {
                $dimensions.Add($height, 1)
            } else {
                $new_value = $dimensions.Get_Item($height) + 1
                $dimensions.Set_Item($height, $new_value)
            }
            
            if (!$dims_combined.ContainsKey($height)) {
                $dims_combined.Add($height, 1)
            } else {
                $new_value = $dims_combined.Get_Item($height) + 1
                $dims_combined.Set_Item($height, $new_value)
            }
        }
    }
    $dimensions = $dimensions.GetEnumerator() | Sort-Object @{Expression = {$_.Value}; Descending = $True}, @{Expression = {[int]$_.Key}; Descending = $True}
    return $dimensions
}

function prepOutput() {
    param($dimensions)
    $output = ($dimensions | Format-Table | Out-String)
    $output = $output -split "`r`n"
    $trimmed = @()
    $output | ForEach-Object {
        $line = $_.Trim()
        if ($line -ne "") {
            $trimmed += $line
        }
    }
    $trimmed = $trimmed -join "`r`n"
    return $trimmed
}

function write2File() {
    param($content, $folder)
    $file_path = $folder + "dimensions.txt"
    if (Test-Path -Path $file_path -PathType Leaf) {
        Remove-Item -Path $file_path
    }
    $content | Out-File -FilePath $file_path
}

function getDimensions() {
    param($folder)
    $json = readJSON ($folder + "devices.json")
    $dimensions = calcFreq $json
    $output = prepOutput $dimensions
    write2File $output $folder
}

$dims_combined = @{}

getDimensions "material.io/"
getDimensions "mydevice.io/"
getDimensions "screensiz.es/"
getDimensions "viewportsizes.com/"

$dims_combined = $dims_combined.GetEnumerator() | Sort-Object @{Expression = {$_.Value}; Descending = $True}, @{Expression = {[int]$_.Key}; Descending = $True}
$dims_output   = prepOutput $dims_combined
write2File $dims_output ""
Start-Process -FilePath "C:\Windows\notepad.exe" -ArgumentList "dimensions.txt"

# Read-Host -Prompt "Press Enter to exit"
