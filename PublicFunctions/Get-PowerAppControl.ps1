function Get-PowerAppControl {
    param([Parameter(ValueFromPipeline)][ValidateNotNullOrEmpty()]$customTheme)

    if($customTheme) {
        if(-not (ValidateTheme $customTheme)) { throw "Invalid CustomTheme!" }
    }
    elseif($script:ThemeData) { $customTheme = $script:ThemeData}
    else { throw "No Custom Theme provided nor has a PowerAppTheme been opened!" }

    $customTheme.styles.foreach({
        $s = $_
        [PSCustomObject]@{
            PSTypeName = "PowerApp.Control"
            Style = $s.name
            Control = $s.controlTemplateName
            IsDefault = $s.name.StartsWith("default")
            Properties = $s.propertyValuesMap.foreach({
                $pSearch = if($_.value -like "%Palette.*%") { $_.value.Substring(9).TrimEnd("%") }
                [PSCustomObject]@{
                    PSTypeName = "PowerApp.StyleProperty"
                    Property = $_.property
                    PropertyValue = $_.value
                    Reference = $customTheme.palette.
                        where({$pSearch -and $_.name -eq $pSearch}).
                        foreach({
                            [PSCustomObject]@{
                                PSTypeName = "PowerApp.PaletteReference"
                                Name = $_.name
                                TypeDescription = Switch($_.type) {
                                        "c" {"Color"}
                                        "x" {"Variable"}
                                        "e" {"Expression"}
                                        "n" {"Number"}
                                        "![]" {"Array"}
                                    }
                                Value = $_.value
                            }
                        })[0]
                }
            })
        }
    })
}
Export-ModuleMember -Function Get-PowerAppControl