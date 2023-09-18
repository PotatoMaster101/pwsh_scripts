<#
.SYNOPSIS
Gets the PATH environment variable.

.DESCRIPTION
The Get-EnvPath cmdlet gets the entries in the PATH environment variable. This cmdlet can only be run on Windows.

.PARAMETER Invalid
Specifies whether to only return the invalid paths.

.OUTPUTS
System.Management.Automation.PSCustomObject
This cmdlet returns the entries in the PATH environment variable.

.EXAMPLE
Get-EnvPath
Get all entries from the PATH environment variable.

.EXAMPLE
Get-EnvPath -Invalid
Get all invalid entries from the PATH environment variable.
#>

#Requires -PSEdition Core
#Requires -Version 7.3

[CmdletBinding()]
param (
    [switch] $Invalid
)

Set-StrictMode -Version Latest
if (!$IsWindows) {
    throw 'Can only be run on Windows'
}

function Out-EnvPath([string] $path, [string] $target) {
    if (!$Invalid -or ($Invalid -and !(Test-Path $path -PathType Container))) {
        [PSCustomObject]@{
            Target = $target
            Path   = $path
        }
    }
}

foreach ($p in [System.Environment]::GetEnvironmentVariable('Path', 'Machine') -split ';') {
    Out-EnvPath $p 'Machine'
}
foreach ($p in [System.Environment]::GetEnvironmentVariable('Path', 'User') -split ';') {
    Out-EnvPath $p 'User'
}
