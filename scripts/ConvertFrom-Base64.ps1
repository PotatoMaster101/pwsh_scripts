<#
.SYNOPSIS
Decodes the input base64 string.

.DESCRIPTION
The ConvertFrom-Base64.ps1 script decodes the given base64 string.

.PARAMETER InputString
Specifies the input string to decode.

.INPUTS
System.String.
You can pipe a string to ConvertFrom-Base64.ps1.

.OUTPUTS
System.Management.Automation.PSCustomObject.
ConvertFrom-Base64.ps1 returns an object that contains the base64 decoded string.
#>

#Requires -PSEdition Core
#Requires -Version 7.1

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string] $InputString
)

try {
    $bytes = [System.Convert]::FromBase64String($InputString)
    [PSCustomObject]@{
        Original = $InputString
        Decoded  = [System.Text.Encoding]::UTF8.GetString($bytes)
    }
} catch {
    throw 'Input string is not a base64 encoded string'
}
