function LoadThemeFromJSON {
    param([parameter(Mandatory)][string]$RawJSON)

    $jsonData = $RawJSON | ConvertFrom-Json
    if($jsonData.CustomThemes) { $jsonData = $jsonData.CustomThemes | Select-Object -First 1 }
    if(ValidateTheme $jsonData) {
        return $jsonData
    }
    else { throw "Invalid Theme!"}    
}