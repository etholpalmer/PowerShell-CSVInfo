[CmdletBinding()]
param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [Alias('Path')]
    [ValidateScript({
        if(-not ($_ | Test-Path ))              { throw "File or folder does not exist!" }
        if(-not ($_ | Test-Path -PathType Leaf  { throw "The Path argument must be a file, not a folder!" }
        if($_.Attributes -match "Hidden"        { throw "The file cannot be hidden, indication it was already processed." }
        return $true
    })]
    [System.IO.FileInfo[]]$CSVFiles,
    [string]$hdrRow=$null,
    [string]$RELinePtrn=
