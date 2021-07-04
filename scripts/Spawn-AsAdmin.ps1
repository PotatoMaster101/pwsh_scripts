<#
.SYNOPSIS
Spawns a new PowerShell core session with administrator privileges.

.DESCRIPTION
The Spawn-AsAdmin.ps1 script starts a new PowerShell core session with administrator privileges. This script can only be run on Windows.

.PARAMETER WorkingDirectory
Specifies the initial working directory. Defaults to current directory.

.PARAMETER WindowStyle
Specifies the window style for the session. Defaults to 'Normal'.
Possible options are 'Normal', 'Minimized', 'Maximized' and 'Hidden'.

.PARAMETER NoLogo
Specifies to hide the copyright banner at startup.

.INPUTS
System.String.
You can pipe a string that contains the working directory path to Spawn-AsAdmin.ps1.

.OUTPUTS
None.
Spawn-AsAdmin.ps1 does not generate any output.
#>

#Requires -PSEdition Core
#Requires -Version 7.1

[CmdletBinding()]
param (
    [Parameter(ValueFromPipeline = $true)]
    [ValidateScript({ Test-Path $_ -PathType Container }, ErrorMessage = "Directory not found: {0}")]
    [string] $WorkingDirectory = (Resolve-Path '.'),

    [ValidateSet('Normal', 'Minimized', 'Maximized', 'Hidden')]
    [string] $WindowStyle = 'Normal',

    [switch] $NoLogo
)

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
