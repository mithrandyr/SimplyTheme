function Get-PowerAppControls {
    [cmdletbinding(DefaultParameterSetName="default")]
    param(
        [Parameter(ValueFromPipeline, ParameterSetName="default")][ValidateNotNullOrEmpty()]$jsonData = $script:ThemeData
        , [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName="path")][Alias("Path","FullName")][string]$jsonPath
    )

    if($jsonPath) { $jsonPath = Get-Content -Raw -Path $jsonPath | ConvertFrom-Json }
    if($jsonData.CustomThemes) {
        $jsonData.CustomThemes |
            Select-Object -First 1 -ExpandProperty styles |
            ForEach-Object $NewLogic
    }
    elseif($jsonData.styles) {
        $jsonData.styles |
        ForEach-Object $NewLogic
    }
    else {
        
    }
}
Export-ModuleMember -Function Get-PowerAppControls