<#
.SYNOPSIS
Adds new paths to the PATH environment variable.

.DESCRIPTION
The Add-EnvPath.ps1 script adds new paths to the PATH environment variable. This script can only be run on Windows.

.PARAMETER Path
Specifies the paths to add.

.PARAMETER Target
Specifies the environment variable target to use, defaults to 'Machine'.
Possible options are 'Machine', 'User' and 'Process'. If 'Process' is selected, then the added paths will be only valid for the current session.

.PARAMETER Force
Specifies to add the path by force, skipping any path checkings.

.INPUTS
System.String[].
You can pipe strings that contain paths to Add-EnvPath.ps1.

.OUTPUTS
None.
Add-EnvPath.ps1 does not generate any output.
#>

#Requires -PSEdition Core
#Requires -Version 7.1
#Requires -RunAsAdministrator

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string[]] $Path,

    [ValidateSet('Machine', 'User', 'Process')]
    [string] $Target = 'Machine',

    [switch] $Force
)

begin {
    if (!$IsWindows) {
        throw 'Can only be run on Windows'
    }
    $envPath = [System.Environment]::GetEnvironmentVariable('Path', $Target) -split ';'
    $envList = [System.Collections.Generic.List[string]]::new($envPath)
}
process {
    foreach ($p in $Path) {
        $resolve = Resolve-Path $p -ErrorAction SilentlyContinue
        if ($Force) {
            $envList.Add($p)
        } elseif (!$resolve) {
            Write-Warning "Path cannot be resolved: '$p'"
        } elseif (!(Test-Path $resolve -PathType Container)) {
            Write-Warning "Path is not a directory: '$resolve'"
        } elseif ($envList | Where-Object { $_ -like $resolve }) {
            Write-Warning "Path already exists: '$resolve'"
        } else {
            $envList.Add($resolve)
        }
    }
}
end {
    [System.Environment]::SetEnvironmentVariable('Path', $envList -join ';', $Target)
}
