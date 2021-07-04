<#
.SYNOPSIS
Gets the size of a specified directory.

.DESCRIPTION
The Get-DirSize.ps1 script gets the size of a specified directory. The size is determined by the sum of all file sizes in the specified directory.

.PARAMETER Path
Specifies the path of the directory to get the size. Defaults to the current directory.

.PARAMETER Unit
Specifies the unit for the size, defaults to GB. Possible units are B, KB, MB and GB.

.PARAMETER Force
Specifies whether to also include hidden files and system files.

.INPUTS
System.String.
You can pipe a string that contains a path to Get-DirSize.ps1.

.OUTPUTS
System.Management.Automation.PSCustomObject.
Get-DirSize.ps1 returns an object which contains the size information of the specified directory.
#>

#Requires -PSEdition Core
#Requires -Version 7.1

[CmdletBinding()]
param (
    [Parameter(ValueFromPipeline = $true)]
    [ValidateScript({ Test-Path $_ -PathType Container }, ErrorMessage = "Directory not found: {0}")]
    [string] $Path = '.',

    [ValidateSet('B', 'KB', 'MB', 'GB')]
    [string] $Unit = 'GB',

    [switch] $Force
)

$files = ($Force ? (Get-ChildItem $Path -Recurse -File -Force) : (Get-ChildItem $Path -Recurse -File))
$measure = ($files | Measure-Object -Property Length -Sum -Maximum -Minimum -Average)
switch ($Unit) {
    'B' {
        $sum, $ave = $measure.Sum, $measure.Average
        $min, $max = $measure.Minimum, $measure.Maximum
    }
    'KB' {
        $sum, $ave = ($measure.Sum / 1KB), ($measure.Average / 1KB)
        $min, $max = ($measure.Minimum / 1KB), ($measure.Maximum / 1KB)
    }
    'MB' {
        $sum, $ave = ($measure.Sum / 1MB), ($measure.Average / 1MB)
        $min, $max = ($measure.Minimum / 1MB), ($measure.Maximum / 1MB)
    }
    'GB' {
        $sum, $ave = ($measure.Sum / 1GB), ($measure.Average / 1GB)
        $min, $max = ($measure.Minimum / 1GB), ($measure.Maximum / 1GB)
    }
}

[PSCustomObject]@{
    Directory = (Resolve-Path $Path)
    FileCount = $files.Length
    Total     = "$sum$Unit"
    Minimum   = "$min$Unit"
    Maximum   = "$max$Unit"
    Average   = "$ave$Unit"
}
