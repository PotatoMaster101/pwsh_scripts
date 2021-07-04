<#
.SYNOPSIS
Updates all the outdated packages in pip.

.DESCRIPTION
The Update-Pip.ps1 script updates all the outdated packages in pip.

.PARAMETER List
Specifies to list the outdated packages, but do not perform the update.

.INPUTS
None.
You cannot pipe objects to Update-Pip.ps1.

.OUTPUTS
None or System.Management.Automation.PSCustomObject.
Update-Pip.ps1 returns all the outdated packages and their versions if the List option is specified. Otherwise, Update-Pip.ps1 will not generate any output.
#>

#Requires -PSEdition Core
#Requires -Version 7.1

[CmdletBinding()]
param (
    [switch] $List
)

if (!(Get-Command 'pip' -ErrorAction SilentlyContinue)) {
    throw 'Program not found: pip'
}

$outdated = (pip list --outdated)
if (!$outdated) {
    Write-Host 'All pip packages are up to date'
    return
}

$outdated = $outdated[2..($outdated.Length - 1)]
foreach ($update in $outdated) {
    $split = $update.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
    if ($List) {
        [PSCustomObject]@{
            Package    = $split[0]
            Current    = $split[1]
            NewVersion = $split[2]
            Type       = $split[3]
        }
    } else {
        Write-Host "Updating $($split[0])..."
        pip install --upgrade $split[0] | Out-Null
    }
}
