<#
.SYNOPSIS
Clears the specified Visual Studio solution, removing all built files.

.DESCRIPTION
The Clear-Solution.ps1 script removes all built files from a Visual Studio solution.

.PARAMETER Path
Specifies the solution path, defaults to current path.

.PARAMETER Force
Specifies to ignore any prompts and proceed.

.INPUTS
System.String.
You can pipe a string that contains a path to Clear-Solution.ps1.

.OUTPUTS
None.
Clear-Solution.ps1 does not generate any output.
#>

#Requires -PSEdition Core
#Requires -Version 7.1

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(ValueFromPipeline = $true)]
    [ValidateScript({ Test-Path $_ -PathType Container }, ErrorMessage = "Directory not found: {0}")]
    [string] $Path = (Resolve-Path '.'),

    [switch] $Force
)

if (!($Force -or $PSCmdlet.ShouldContinue('Would you like to clear solution?', 'Clear Solution'))) {
    return      # user chose 'N'
}

$binDir = @(    # folder with generated files
    'bin',
    'bin64',
    'build',
    'builds',
    'debug',
    'log',
    'logs',
    'obj',
    'release',
    'x64',
    'x86'
)
Get-ChildItem -Force -Recurse -Directory -Include $binDir | ForEach-Object {
    Remove-Item -Recurse -Force $_ -ErrorAction SilentlyContinue
}
