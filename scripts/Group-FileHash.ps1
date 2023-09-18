<#
.SYNOPSIS
Groups files with the same hash.

.DESCRIPTION
The Group-FileHash cmdlet groups files with the same hash.

.PARAMETER Path
Specifies the files to perform the file hash grouping.

.PARAMETER Algorithm
Specifies the hashing algorithm to use on the file. Defaults to 'SHA256'.
Posible algorithms are 'SHA1', 'SHA256', 'SHA384', 'SHA512' and 'MD5'.

.PARAMETER Lonely
Specifies to only output files that are different with no matching file.

.INPUTS
System.String[]
You can pipe strings that contain paths to this cmdlet.

.OUTPUTS
System.Management.Automation.PSCustomObject
This cmdlet returns an object which contains the grouping of the file hashes.

.EXAMPLE
Get-ChildItem -File | Group-FileHash
Compares the hash for all files under the current directory.

.EXAMPLE
Get-ChildItem -File | Group-FileHash -Lonely
Compares the hash for all files under the current directory, but only output files that do not match any other file.
#>

#Requires -PSEdition Core
#Requires -Version 7.3

[CmdletBinding()]
param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [ValidateScript({Test-Path $_ -PathType Leaf}, ErrorMessage = "File not found: {0}")]
    [string[]] $Path,

    [ValidateSet('SHA1', 'SHA256', 'SHA384', 'SHA512', 'MD5')]
    [string] $Algorithm = 'SHA256',

    [switch] $Lonely
)

begin {
    Set-StrictMode -Version Latest
    $hashes = @{}
    $group = 0

    function Out-Group([int] $group, [string] $path, [string] $hash) {
        [PSCustomObject]@{
            Group = $group
            Path  = $path
            Hash  = $hash
        }
    }
}
process {
    Get-FileHash $Path -Algorithm $Algorithm -ErrorAction Ignore | ForEach-Object {
        if (!($hashes.ContainsKey($_.Hash))) {
            $hashes[$_.Hash] = [System.Collections.Generic.HashSet[string]]::new()
        }
        [void] $hashes[$_.Hash].Add($_.Path)
    }
}
end {
    foreach ($key in $hashes.Keys) {
        if ($Lonely) {
            if ($hashes[$key].Count -eq 1) {
                Out-Group $group $hashes[$key] $key
                $group++
            }
            continue
        }

        foreach ($item in $hashes[$key]) {
            Out-Group $group $item $key
        }
        $group++
    }
}
