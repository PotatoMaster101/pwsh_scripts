<#
.SYNOPSIS
Converts the input string to base64 encoding.

.DESCRIPTION
The ConvertTo-Base64.ps1 script converts the input string to base64 encoding.

.PARAMETER InputString
Specifies the input string to convert.

.INPUTS
System.String.
You can pipe a string to ConvertTo-Base64.ps1.

.OUTPUTS
System.Management.Automation.PSCustomObject.
ConvertTo-Base64.ps1 returns an object that contains the base64 encoded string.
#>

#Requires -PSEdition Core
#Requires -Version 7.1

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string] $InputString
)

$bytes = [System.Text.Encoding]::Unicode.GetBytes($InputString)
[PSCustomObject]@{
    Original = $InputString
    Encoded  = [System.Convert]::ToBase64String($bytes)
}
