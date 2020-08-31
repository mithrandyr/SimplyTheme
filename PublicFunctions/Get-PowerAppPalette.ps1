function Get-PowerAppPalette {
    param([Parameter(ValueFromPipeline)][ValidateNotNullOrEmpty()]$customTheme)

    if($customTheme) {
        if(-not (ValidateTheme $customTheme)) { throw "Invalid CustomTheme!" }
    }
    elseif($script:ThemeData) { $customTheme = $script:ThemeData}
    else { throw "No Custom Theme provided nor has a PowerAppTheme been opened!" }

    $customTheme.palette.foreach({
        $pSearch = "%Palette.{0}%" -f $_.Name
        [PSCustomObject]@{
            PSTypeName = "PowerApp.Palette"
            Name = $_.name
            Value = $_.value
            Type = $_.type
            TypeDescription = Switch($_.type) {
                    "c" {"Color"}
                    "x" {"Variable"}
                    "e" {"Expression"}
                    "n" {"Number"}
                    "![]" {"Array"}
                }
            References = $customTheme.styles.foreach({
                $s = $_
                $s.propertyValuesMap.
                    where({$_.value -eq $pSearch}).
                    foreach({
                        [PSCustomObject]@{
                            PSTypeName = "PowerApp.StylePropertyReference"
                            Style = $s.name
                            Control = $s.controlTemplateName
                            Property = $_.property
                            PropertyValue = $_.value
                        }
                    })
            }) | Sort-Object Control, Style
        }
    })
}

Export-ModuleMember -Function Get-PowerAppPalette