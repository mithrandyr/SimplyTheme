Get-ChildItem -Path "$PSScriptRoot\PrivateFunctions" -Filter *.ps1 |
    ForEach-Object { . $_.FullName }

Get-ChildItem -Path "$PSScriptRoot\PublicFunctions" -Filter *.ps1 |
    ForEach-Object { . $_.FullName }