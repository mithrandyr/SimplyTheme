function ValidateTheme{
    param($theme)
    
    if(($theme.palette).count -gt 0 -and ($theme.styles).count -gt 0) { return $true }
    else { return $false }
}