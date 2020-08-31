function LoadJSONFromTheme {
    param([parameter(Mandatory)][PowerApp.Palette[]]$Palette
        , [parameter(Mandatory)][PowerApp.Control[]]$Control)
        
    [PSCustomObject]@{
        CurrentTheme = "defaultTheme"
        CustomThemes = @(
            [PSCustomObject]@{
                name = "defaultTheme"
                palette = $Palette.foreach({
                    [PSCustomObject]@{
                        name = $_.Name
                        value = $_.value
                        type = Switch($_.TypeDescription) {
                            "Color" {"c"}
                            "Variable" {"x"}
                            "Expression" {"e"}
                            "Number" {"n"}
                            "Array" {"![]"}
                            default {$_.type}
                        }
                    }
                })
                styles = $Control.foreach({
                    [PSCustomObject]@{
                        name = $_.Style
                        controlTemplateName = $_.Control
                        propertyValuesMap = $_.Properties.foreach({
                            [PSCustomObject]@{
                                property = $_.Property
                                value = $_.PropertyValue
                            }
                        })
                    }
                })
            }
        )
    }
}