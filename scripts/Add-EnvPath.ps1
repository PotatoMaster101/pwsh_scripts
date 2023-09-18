<#
.SYNOPSIS
Adds new paths to the PATH environment variable.

.DESCRIPTION
The Add-EnvPath cmdlet adds new paths to the PATH environment variable. This cmdlet can only be run on Windows.

.PARAMETER Path
Specifies the paths to add.

.PARAMETER Target
Specifies the environment variable target to use, defaults to 'Machine'.
Possible options are 'Machine', 'User' and 'Process'. If 'Process' is selected, the added paths will be only valid for the current session.

.INPUTS
System.String[]
You can pipe strings that contain paths to this cmdlet.

.EXAMPLE
Add-EnvPath 'Foo', 'Bar'
Add directories Foo and Bar into the PATH environment variable (under Machine target).

.EXAMPLE
Add-EnvPath 'Foo', 'Bar' -Target User
Add directories Foo and Bar into the PATH environment variable (under User target).
#>

#Requires -PSEdition Core
#Requires -RunAsAdministrator
#Requires -Version 7.3

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [ValidateScript({Test-Path $_ -PathType Container}, ErrorMessage = "Directory not found: {0}")]
    [string[]] $Path,

    [ValidateSet('Machine', 'User', 'Process')]
    [string] $Target = 'Machine'
)

begin {
    Set-StrictMode -Version Latest
    if (!$IsWindows) {
        throw 'Can only be run on Windows'
    }

    $original = [System.Environment]::GetEnvironmentVariable('Path', $Target) -split ';'
    $envList = [System.Collections.Generic.List[string]]::new($original)
}
process {
    Resolve-Path $Path | ForEach-Object {
        if ($envList.Contains($_)) {
            Write-Error "Path already exist: $_"
        } elseif ($PSCmdlet.ShouldProcess($_, "Add $Target Path")) {
            $envList.Add($_)
        }
    }
}
end {
    if ($envList.Count -gt $original.Length) {
        [System.Environment]::SetEnvironmentVariable('Path', $envList -join ';', $Target)
    }
}
