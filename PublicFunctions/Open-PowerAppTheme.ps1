function Open-PowerAppTheme {
    param([parameter(Mandatory)][string]$Path
        , [switch]$Passthru
    )
    $ErrorActionPreference = "Stop"
    if(-not(Test-Path -Path $Path -PathType Leaf)) { throw "Not a valid path ('$path')!" }
    if($Path -like "*.msapp") {
        $tmpFolder = Join-Path $env:TEMP ("SimplyTheme-{0}" -f [guid]::NewGuid().guid.replace("-",""))
        New-Item -Path $tmpFolder -ItemType Directory | Out-Null
        try {
            Expand-Archive -Path $PowerAppPath -DestinationPath $tmpFolder
            $rawJSON = Get-Content -Path (Join-Path $tmpFolder "References\Themes.json") -Raw
        }
        catch {
            throw "Error processing PowerApp application file!"
        }
        finally { Remove-Item -Path $tmpFolder -Force -Recurse }
    }
    elseif($path -like "*.json") {
        $rawJSON = Get-Content -Path $ThemePath -Raw
    }
    else { throw "Not a valid PowerApp (*.msapp) or Theme (*.json) File!" }

    if($Passthru) { 
        return LoadThemeFromJSON $rawJSON
    }
    else {
        $script:ThemeData = LoadThemeFromJSON $rawJSON
    }
}

Export-ModuleMember -Function Open-PowerAppTheme