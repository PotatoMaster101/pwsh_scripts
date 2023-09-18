<#
.SYNOPSIS
Clears PowerShell and other program history files.

.DESCRIPTION
The Clear-ProgramHistory cmdlet clears PowerShell and other program history files.
#>

#Requires -PSEdition Core
#Requires -Version 7.3

[CmdletBinding(SupportsShouldProcess)]
param ()

Set-StrictMode -Version Latest
function Remove-Force([string] $item) {
    Remove-Item $item -Force -Recurse -ErrorAction Ignore -Verbose:$VerbosePreference -WhatIf:$WhatIfPreference
}

Remove-Force "$HOME\AppData\Local\nvim-data\shada"
Remove-Force "$HOME\_viminfo"
Remove-Force "$HOME\.bash_history"
Remove-Force "$HOME\.lesshst"
Remove-Force (Get-PSReadLineOption).HistorySavePath
