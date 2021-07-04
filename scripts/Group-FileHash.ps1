<#
.SYNOPSIS
Groups files with the same hash.

.DESCRIPTION
The Group-FileHash.ps1 script groups files with the same hash.

.PARAMETER Path
Specifies the file(s) to perform the file hash grouping.

.PARAMETER Algorithm
Specifies the hashing algorithm to use on the file. Defaults to 'SHA256'.
Posible algorithms are 'SHA1', 'SHA256', 'SHA384', 'SHA512' and 'MD5'.

.INPUTS
System.String.
You can pipe strings that contain paths to Group-FileHash.ps1.

.OUTPUTS
System.Management.Automation.PSCustomObject.
Group-FileHash.ps1 returns an object which contains the grouping of the file hashes.
#>

#Requires -PSEdition Core
#Requires -Version 7.1

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string[]] $Path,

    [ValidateSet('SHA1', 'SHA256', 'SHA384', 'SHA512', 'MD5')]
    [string] $Algorithm = 'SHA256'
)

begin {
    $hashes = @{}
    $group = 0
}
process {
    Resolve-Path $Path | ForEach-Object {
        $hash = Get-FileHash $_ -Algorithm $Algorithm -ErrorAction SilentlyContinue || $(return)
        if (!($hashes.ContainsKey($hash.Hash))) {
            $hashes[$hash.Hash] = [System.Collections.Generic.HashSet[string]]::new()
        }
        [void] $hashes[$hash.Hash].Add($_)
    }
}
end {
    $hashes.Keys | ForEach-Object {
        $key = $_
        $hashes.Item($key) | ForEach-Object {
            [PSCustomObject]@{
                File  = $_
                Group = $group
                Hash  = $key
            }
        }
        $group++
    }
}
