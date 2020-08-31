function Export-PowerAppTheme {
    param([parameter(Mandatory)][PowerApp.Palette[]]$Palette
        , [parameter(Mandatory)][PowerApp.Control[]]$Control
        , [parameter(Mandatory)][string]$Path
    )

    $Palette.foreach({
        [PSCustomObject]@{
            Name = $_.Name
            Value = $_.Value
            TypeDescription = $_.TypeDescription
            Usage = $_.References.foreach({"{0}({1}).{2}" -f $_.Control, $_.Style, $_.Property}) -join "; "
        }
    }) | Export-Excel -Path $Path -WorksheetName Palette -AutoSize -FreezeTopRow -AutoFilter -BoldTopRow

    $Control.foreach({
        $s = $_
        $_.Properties.foreach({
            [PSCustomObject]@{
                Style = $s.Style
                Control = $s.Control
                Property = $_.Property
                Value = $_.PropertyValue
                ReferenceName = $_.Reference[0].Name
                ReferenceValue = $_.Reference[0].Value
                ReferenceType = $_.Reference[0].TypeDescription
            }
        })
    }) | Export-Excel -Path $Path -WorksheetName Control -AutoSize -FreezeTopRow -AutoFilter -BoldTopRow
}

Export-ModuleMember -Function Export-PowerAppTheme