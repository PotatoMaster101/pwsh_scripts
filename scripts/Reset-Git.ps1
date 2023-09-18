<#
.SYNOPSIS
Re-initialises git in the current directory.

.DESCRIPTION
The Reset-Git cmdlet re-initialises git in the current directory by removing the .git folder and adding a new commit.

.PARAMETER RemoteUrl
Specifies the remote git repository URL for this git repository.

.PARAMETER RemoteName
Specifies the name of the remote git repository, defaults to 'origin' This value can not be empty when RemoteUrl is specified.

.OUTPUTS
System.String[]
This cmdlet returns output from git.

.EXAMPLE
Reset-Git 'https://example.com'
Reset git in the current directory and set remote as 'https://example.com'.
#>

#Requires -PSEdition Core
#Requires -Version 7.3

[CmdletBinding(SupportsShouldProcess)]
param (
    [string] $RemoteUrl,

    [string] $RemoteName = 'origin'
)

Set-StrictMode -Version Latest
if (!(Get-Command 'git' -ErrorAction Ignore)) {
    throw 'Program not found: git'
}

if (Test-Path '.git' -PathType Container) {
    Remove-Item '.git' -Force -Recurse -Verbose:$VerbosePreference -WhatIf:$WhatIfPreference
}
if ($PSCmdlet.ShouldProcess((Resolve-Path '.'), 'Initialise Git')) {
    git init
    git add -A
    git commit -am 'Initial commit'
    if ($RemoteUrl) {
        if (!$RemoteName) {
            Write-Error 'RemoteName can not be empty when using RemoteUrl'
        } else {
            git remote add $RemoteName $RemoteUrl
        }
    }
}
