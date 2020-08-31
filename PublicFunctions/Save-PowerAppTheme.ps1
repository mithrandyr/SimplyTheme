function Save-PowerAppTheme {
    param([parameter(Mandatory)][PowerApp.Palette[]]$Palette
        , [parameter(Mandatory)][PowerApp.Control[]]$Control
        , [parameter(Mandatory)][string]$Path
    )

    $ErrorActionPreference = "Stop"
    if(-not(Test-Path -Path $Path -PathType Leaf)) { throw "Not a valid path ('$path')!" }
    if($Path -like "*.msapp") {
        $tmpFolder = Join-Path $env:TEMP ("SimplyTheme-{0}" -f [guid]::NewGuid().guid.replace("-",""))
        New-Item -Path $tmpFolder -ItemType Directory | Out-Null
        try {
            Expand-Archive -Path $PowerAppPath -DestinationPath $tmpFolder
            Set-Content -Path (Join-Path $tmpFolder "References\Themes.json") -Value (LoadJSONFromTheme -Palette $Palette -Control $Control)
            Compress-Archive -Path (Join-Path $tmpFolder "References\") -DestinationPath $path -Update
        }
        catch {
            throw "Error processing PowerApp application file!"
        }
        finally { Remove-Item -Path $tmpFolder -Force -Recurse }
    }
    elseif($path -like "*.json") {
        Set-Content -Path $Path -Value (LoadJSONFromTheme -Palette $Palette -Control $Control)
    }
    else { throw "Not a valid PowerApp (*.msapp) or Theme (*.json) File!" }
}

Export-ModuleMember -Function Save-PowerAppTheme