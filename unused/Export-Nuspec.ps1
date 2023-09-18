<#
.SYNOPSIS
Exports '.nuspec' files from Nuget packages.

.DESCRIPTION
The Export-Nuspec cmdlet exports '.nuspec' files from Nuget packages.

.PARAMETER Path
Specifies the paths to Nuget packages.

.PARAMETER DestinationPath
Specifies the destination path to place the '.nuspec' files, defaults to current path.

.INPUTS
System.String[]
You can pipe strings that contain paths to this cmdlet.

.EXAMPLE
Export-Nuspec 'xunit.2.4.1.nupkg'
Exports '.nuspec' file from Nuget package 'xunit.2.4.1.nupkg' to the current directory.

.EXAMPLE
Get-ChildItem '~/.nuget' -Recurse -Filter *.nupkg | Export-Nuspec -DestinationPath 'C:\TEMP\'
Exports '.nuspec' files from all of the Nuget packages under '~/.nuget' to 'C:\TEMP' directory.
#>

#Requires -PSEdition Core
#Requires -Version 7.3

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [ValidateScript({Test-Path $_ -PathType Leaf}, ErrorMessage = "File not found: {0}")]
    [string[]] $Path,

    [ValidateScript({Test-Path $_ -PathType Container}, ErrorMessage = "Directory not found: {0}")]
    [string] $DestinationPath = (Resolve-Path '.')
)

begin {
    Set-StrictMode -Version Latest
}
process {
    Resolve-Path $Path | ForEach-Object {
        if (!($_.Path.EndsWith('.nupkg'))) {
            Write-Error "Not a Nuget package: $_"
            return
        }

        if ($PSCmdlet.ShouldProcess($_.Path, 'Export Nuspec')) {
            $zip = [System.IO.Compression.ZipFile]::OpenRead($_.Path)
            foreach ($entry in $zip.Entries.Where({$_.Name.EndsWith('.nuspec')})) {
                [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entry, "$DestinationPath/$($entry)", $true)
            }
            $zip.Dispose()
        }
    }
}
