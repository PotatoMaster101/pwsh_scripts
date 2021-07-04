<#
.SYNOPSIS
Removes paths from the PATH environment variable.

.DESCRIPTION
The Remove-EnvPath.ps1 script removes paths from the PATH environment variable. This script can only be run on Windows.

.PARAMETER Path
Specifies the paths to remove.

.INPUTS
System.String[].
You can pipe strings that contain paths to Remove-EnvPath.ps1.

.OUTPUTS
None.
Remove-EnvPath.ps1 does not generate any output.
#>

#Requires -PSEdition Core
#Requires -Version 7.1
#Requires -RunAsAdministrator

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [AllowEmptyString()]
    [string[]] $Path
)

begin {
    if (!$IsWindows) {
        throw 'Can only be run on Windows'
    }
    $machines = [System.Collections.Generic.List[string]]::new(
        [System.Environment]::GetEnvironmentVariable('Path', 'Machine') -split ';'
    )
    $users = [System.Collections.Generic.List[string]]::new(
        [System.Environment]::GetEnvironmentVariable('Path', 'User') -split ';'
    )
}
process {
    foreach ($p in $Path) {
        $count = $machines.RemoveAll( { param($m) $m.Equals($p) })
        $count += $users.RemoveAll( { param($m) $m.Equals($p) })
        if ($count -eq 0) {
            Write-Warning "Path not in PATH environment variable: '$p'"
        }
    }
}
end {
    [System.Environment]::SetEnvironmentVariable('Path', ($machines -join ';'), 'Machine')
    [System.Environment]::SetEnvironmentVariable('Path', ($users -join ';'), 'User')
}
