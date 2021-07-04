<#
.SYNOPSIS
Clears PowerShell and other program history files.

.DESCRIPTION
The Clear-ProgramHistory.ps1 script clears PowerShell and other program history files.

.PARAMETER Force
Specifies to ignore any prompts and proceed.

.INPUTS
None.
You cannot pipe objects to Clear-ProgramHistory.ps1.

.OUTPUTS
None.
Clear-ProgramHistory.ps1 does not generate any output.
#>

#Requires -PSEdition Core
#Requires -Version 7.1

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [switch] $Force
)

if (!($Force -or $PSCmdlet.ShouldContinue('Would you like to clear history?', 'Clear History'))) {
    return      # user chose 'N'
}
function Remove-Force ($item) {
    Remove-Item $item -Force -Recurse -ErrorAction SilentlyContinue
}

Remove-Force "$HOME\AppData\Local\nvim-data\shada"
Remove-Force "$HOME\_viminfo"
Remove-Force "$HOME\.bash_history"
Remove-Force "$HOME\.lesshst"
Remove-Force (Get-PSReadLineOption).HistorySavePath
Clear-Host
Clear-History
