<#
.SYNOPSIS
Removes paths from the PATH environment variable.

.DESCRIPTION
The Remove-EnvPath cmdlet removes paths from the PATH environment variable. This cmdlet can only be run on Windows.

.PARAMETER Path
Specifies the paths to remove.

.INPUTS
System.String[]
You can pipe strings that contain paths to this cmdlet.

.EXAMPLE
Remove-EnvPath 'Foo', 'Bar'
Remove directories Foo and Bar from the PATH environment variable.
#>

#Requires -PSEdition Core
#Requires -RunAsAdministrator
#Requires -Version 7.3

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [AllowEmptyString()]
    [string[]] $Path
)

begin {
    Set-StrictMode -Version Latest
    if (!$IsWindows) {
        throw 'Can only be run on Windows'
    }

    $machineCount = 0
    $userCount = 0
    $machines = [System.Collections.Generic.List[string]]::new(
        [System.Environment]::GetEnvironmentVariable('Path', 'Machine') -split ';'
    )
    $users = [System.Collections.Generic.List[string]]::new(
        [System.Environment]::GetEnvironmentVariable('Path', 'User') -split ';'
    )
}
process {
    foreach ($p in $Path) {
        $removed = $false
        if ($machines.Contains($p) -and $PSCmdlet.ShouldProcess($p, 'Remove Machine Path')) {
            $machineCount += $machines.RemoveAll({$args[0].Equals($p)})
            $removed = $true
        }
        if ($users.Contains($p) -and $PSCmdlet.ShouldProcess($p, 'Remove User Path')) {
            $userCount += $users.RemoveAll({$args[0].Equals($p)})
            $removed = $true
        }
        if (!$removed -and !$WhatIfPreference) {
            Write-Error "Path not in PATH: $p"
        }
    }
}
end {
    if ($machineCount -gt 0) {
        [System.Environment]::SetEnvironmentVariable('Path', ($machines -join ';'), 'Machine')
    }
    if ($userCount -gt 0) {
        [System.Environment]::SetEnvironmentVariable('Path', ($users -join ';'), 'User')
    }
}
