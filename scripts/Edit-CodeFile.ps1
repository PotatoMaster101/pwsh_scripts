<#
.SYNOPSIS
Edits a file or directory using VSCode.

.DESCRIPTION
The Edit-CodeFile.ps1 script opens the specified file or directory using VSCode. The file or directory can be located anywhere in the current directory or subdirectories. A prompt will be given when more than 3 files are found (or the max limit specified from `Limit`).

.PARAMETER Path
Specifies the path to the file or directory to open.

.PARAMETER Limit
Specifies the limit of the files/directories to open. Defaults to 3.
If the number of files/directories are more than the limit, then prompt.

.PARAMETER Directory
Specifies to search for directories instead of files.

.PARAMETER Force
Specifies to not prompt when the number of files/directories exceed the limit.

.INPUTS
System.String.
You can pipe a string that contains a path to Edit-CodeFile.ps1.

.OUTPUTS
None.
Edit-CodeFile.ps1 does not generate any output.
#>

#Requires -PSEdition Core
#Requires -Version 7.1

[CmdletBinding(SupportsShouldProcess = $true)]
param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string] $Path,

    [uint32] $Limit = 3,

    [switch] $Directory,

    [switch] $Force
)

if (!(Get-Command 'code' -ErrorAction SilentlyContinue)) {
    throw 'Program not found: VSCode'
}

$pathMode = @{ PathType = ($Directory ? 'Container' : 'Leaf') }
if (Test-Path $Path @pathMode) {
    code $Path      # open the file/directory directly if full path provided
    exit
}

if ($Directory) {
    $files = Get-ChildItem -Filter $Path -Recurse -Directory -ErrorAction SilentlyContinue
} else {
    $files = Get-ChildItem -Filter $Path -Recurse -File -ErrorAction SilentlyContinue
}

if ($files.Count -eq 0) {
    Write-Error "Path does not match any $($Directory ? 'directory' : 'file'): '$Path'"
} elseif ($files.Count -gt $Limit) {
    if ($Force) {
        code $files
    }
    elseif ($PSCmdlet.ShouldContinue("$($files.Count) files found, open them all?", 'Multiple Files Found')) {
        code $files
    }
} else {
    code $files
}
