[CmdletBinding()]
param(
    [Parameter(Mandatory, 
        ValueFromPipeline,
        HelpMessage="One or more CSV files to be evaluated."
    )]
    [Alias('Path')]
    [ValidateScript({
        if(-not ($_ | Test-Path ))                { throw "File or folder does not exist!" }
        if(-not ($_ | Test-Path -PathType Leaf))  { throw "The Path argument must be a file, not a folder!" }
        if($_.Attributes -match "Hidden")         { throw "The file cannot be hidden, indication it was already processed." }
        return $true
    })]
    [System.IO.FileInfo[]]$CSVFiles,

    [Parameter(HelpMessage="The sample of the expected Header Row")]
    [string]$hdrRow=$null,
    # The Regular Expression used to read each line from the CSV file.
    [Parameter(HelpMessage="The Regular Expression used to read each CSV file line.")]
    [string]$RELinePtrn=
