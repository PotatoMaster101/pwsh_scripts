<#
.SYNOPSIS
Spawns a new PowerShell core session with administrator privileges.

.DESCRIPTION
The Spawn-AsAdmin cmdlet starts a new PowerShell core session with administrator privileges. This cmdlet can only be run on Windows.

.PARAMETER WorkingDirectory
Specifies the initial working directory, defaults to current directory.

.PARAMETER WindowStyle
Specifies the window style for the session, defaults to 'Normal'.
Possible options are 'Normal', 'Minimized', 'Maximized' and 'Hidden'.

.PARAMETER NoLogo
Specifies to hide the copyright banner at startup.

.INPUTS
System.String
You can pipe a string that contains a path to this cmdlet.

.EXAMPLE
Spawn-AsAdmin
Spawn an admin PowerShell session under the current directory.

.EXAMPLE
Spawn-AsAdmin ../
Spawn an admin PowerShell session under the parent directory.
#>

#Requires -PSEdition Core
#Requires -Version 7.3

[CmdletBinding()]
param (
    [Parameter(ValueFromPipeline)]
    [ValidateScript({Test-Path $_ -PathType Container}, ErrorMessage = "Directory not found: {0}")]
    [string] $WorkingDirectory = (Resolve-Path '.'),

    [ValidateSet('Normal', 'Minimized', 'Maximized', 'Hidden')]
    [string] $WindowStyle = 'Normal',

    [switch] $NoLogo
)

Set-StrictMode -Version Latest
if (!$IsWindows) {
    throw 'Can only be run on Windows'
}
if (!(Test-Path "$PSHOME/pwsh.exe" -PathType Leaf)) {
    throw 'Program not found: pwsh'
}

$argList = [System.Collections.Generic.List[string]]@(
    "-WorkingDirectory `"$WorkingDirectory`"",
    "-WindowStyle $WindowStyle"
)
if ($NoLogo) {
    $argList.Add('-NoLogo')
}

Start-Process "$PSHOME/pwsh.exe" -Verb RunAs -ArgumentList $argList
