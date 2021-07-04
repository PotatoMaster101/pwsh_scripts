<#
.SYNOPSIS
Re-initialises git in the current directory.

.DESCRIPTION
The Reset-Git.ps1 script re-initialises git in the current directory by removing the .git folder and adding a new commit.

.PARAMETER Path
Specifies the path that contains the .git folder, defaults to current path.

.PARAMETER RemoteURL
Specifies the remote git repository URL for this git repository.

.PARAMETER RemoteName
Specifies the name of the remote git repository, defaults to 'origin' This value can not be empty when `RemoteURL` is specified.

.PARAMETER Force
Specifies to ignore any prompts and proceed.

.INPUTS
System.String.
You can pipe a string that contain a path to Reset-Git.ps1.

.OUTPUTS
None.
Reset-Git.ps1 does not generate any output.
#>

#Requires -PSEdition Core
#Requires -Version 7.1

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(ValueFromPipeline = $true)]
    [ValidateScript({ Test-Path $_ -PathType Container }, ErrorMessage = "Directory not found: {0}")]
    [string] $Path = (Resolve-Path '.'),

    [string] $RemoteURL,

    [string] $RemoteName = 'origin',

    [switch] $Force
)

if (!(Get-Command 'git' -ErrorAction SilentlyContinue)) {
    throw 'Program not found: git'
}
if (!($Force -or $PSCmdlet.ShouldContinue('Would you like to reset the git repository?', 'Reset Git'))) {
    return      # user chose 'N'
}

Push-Location $Path
Remove-Item '.\.git\' -Force -Recurse -ErrorAction SilentlyContinue
git init | Out-Null
git add -A | Out-Null
git commit -am 'Initial commit' | Out-Null
if ($RemoteURL) {
    if (!$RemoteName) {
        Write-Warning 'RemoteName can not be empty when specifying RemoteURL'
    } else {
        git remote add $RemoteName $RemoteURL | Out-Null
    }
}
Pop-Location
