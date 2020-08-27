function Get-PowerAppPalette {
    param([Parameter(ValueFromPipeline)][ValidateNotNullOrEmpty()]$customTheme = $script:ThemeData
        , [switch]$IncludeReferences)

    If(-not (ValidatePalette $customTheme)) { throw "Invalid CustomTheme!" }
    
        foreach($p in $jsonPaletteData) {

    }

    $typeNameProp = @{
        MemberType = "ScriptProperty"
        Name = "TypeName"
        Passthru = $true
        Value = {
            Switch($this.type) {
                "c" {"Color"}
                "x" {"Variable"}
                "e" {"Expression"}
                "n" {"Number"}
                "![]" {"Array"}
            }            
        }
        SecondValue = {
            param($value)
            Switch($value) {
                "Color" {$this.type = "c"} 
                "Variable" {$this.type = "x"} 
                "Expression" {$this.type = "e"} 
                "Number" {$this.type = "n"} 
                "Array" {$this.type = "![]"} 
                default {
                    Write-Warning "Specify one of ['Array', 'Color', 'Expression', 'Number', 'Variable']. Invalid Option: '$value'"
                }
            }
        }
    }
    
    [scriptblock]$NewLogic = {
        [PSCustomObject]@{
            PaletteName = $_.Name
            Value = $_.Value
            Type = $_.type
        } | Add-Member @typeNameProp
    }
  
    if($jsonPath) { $jsonPath = Get-Content -Raw -Path $jsonPath | ConvertFrom-Json }
    if($jsonData.CustomThemes) {
        $jsonData.CustomThemes |
            Select-Object -First 1 -ExpandProperty palette |
            ForEach-Object $NewLogic
    }
    elseif($jsonData.palette) {
        $jsonData.palette |
        ForEach-Object $NewLogic
    }    
}

Export-ModuleMember -Function Get-PowerAppPalette