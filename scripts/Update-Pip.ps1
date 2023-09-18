<#
.SYNOPSIS
Updates all the outdated packages in pip.

.DESCRIPTION
The Update-Pip cmdlet updates all the outdated packages in pip.

.PARAMETER List
Specifies to list the outdated packages, but do not perform the update.

.OUTPUTS
System.String[]
This cmdlet returns the output messages from pip.

System.Management.Automation.PSCustomObject
This cmdlet returns all the outdated packages and their version if the List option is specified.

.EXAMPLE
Update-Pip
Update all pip packages.

.EXAMPLE
Update-Pip -List
List all the outdated pip packages, but do not update.
#>

#Requires -PSEdition Core
#Requires -Version 7.3

[CmdletBinding()]
param (
    [switch] $List
)

Set-StrictMode -Version Latest
if (!(Get-Command 'pip' -ErrorAction Ignore)) {
    throw 'Program not found: pip'
}

$outdated = (pip list --outdated) | Select-Object -Skip 2
foreach ($pkg in $outdated) {
    $split = $pkg.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
    if ($List) {
        [PSCustomObject]@{
            Package = $split[0]
            Current = $split[1]
            New     = $split[2]
            Type    = $split[3]
        }
    } else {
        pip install --upgrade $split[0]
    }
}
