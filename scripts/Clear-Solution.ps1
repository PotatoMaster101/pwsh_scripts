<#
.SYNOPSIS
Clears the specified Visual Studio solution, removing all built files.

.DESCRIPTION
The Clear-Solution cmdlet removes all built files from a Visual Studio solution.

.PARAMETER Path
Specifies the solution paths, defaults to current path.

.INPUTS
System.String[]
You can pipe strings that contain paths to this cmdlet.

.EXAMPLE
Clear-Solution
Clear all built files under the current directory.

.EXAMPLE
Clear-Solution 'Foo', 'Bar'
Clear all built files under the directories Foo and Bar.
#>

#Requires -PSEdition Core
#Requires -Version 7.3

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [ValidateScript({Test-Path $_ -PathType Container}, ErrorMessage = "Directory not found: {0}")]
    [string[]] $Path = (Resolve-Path '.')
)

begin {
    Set-StrictMode -Version Latest
    $binDir = @(    # folder with generated files
        'bin',
        'build',
        'builds',
        'debug',
        'FakesAssemblies',
        'log',
        'logs',
        'obj',
        'release',
        'TestResults',
        'x64',
        'x86'
    )
}
process {
    Get-ChildItem $Path -Recurse -Directory -Include $binDir -ErrorAction Ignore | ForEach-Object {
        Remove-Item $_ -Recurse -Force -ErrorAction Ignore -Verbose:$VerbosePreference -WhatIf:$WhatIfPreference
    }
}
