<#
.SYNOPSIS
Gets the PATH environment variable.

.DESCRIPTION
The Get-EnvPath.ps1 script gets the entries in the PATH environment variable. This script can only be run on Windows.

.PARAMETER Invalid
Specifies whether to only return the invalid paths.

.INPUTS
None.
You cannot pipe objects to Get-EnvPath.ps1.

.OUTPUTS
System.Management.Automation.PSCustomObject.
Get-EnvPath.ps1 returns the entries in the PATH environment variable.
#>

#Requires -PSEdition Core
#Requires -Version 7.1

[CmdletBinding()]
param (
    [switch] $Invalid
)

if (!$IsWindows) {
    throw 'Can only be run on Windows'
}

# Outputs the specified path and check for `Invalid` flag.
function Test-EnvPath($path, $target) {
    if ($Invalid) {
        if (!(Test-Path $path -PathType Container)) {
            Out-EnvPath $path $target
        }
    } else {
        Out-EnvPath $path $target
    }
}

# Outputs the specified path.
function Out-EnvPath($path, $target) {
    [PSCustomObject]@{
        Target = $target
        Path   = $path
    }
}

# Outputs all of the paths from the given target.
function Out-AllEnvPath($target) {
    ([System.Environment]::GetEnvironmentVariable('Path', $target) -split ';') | ForEach-Object {
        Test-EnvPath $_ $target
    }
}

Out-AllEnvPath 'Machine'
Out-AllEnvPath 'User'
