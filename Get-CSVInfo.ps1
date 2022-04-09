[CmdletBinding()]
param(
    # The CSV file(s) to process.
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
    # The Header Row, used to validate the CSV file being processed.
    [Parameter(HelpMessage="The expected Header Row")]
    [string]$hdrRow=$null,
    # The Regular Expression used to read each line from the CSV file.
    [Parameter(HelpMessage="The Regular Expression used to read each CSV file line.")]
    [string]$RELinePtrn="(?imx-sn:)((,|\n|^)([^,\r\n^])*)+",
    # Specify weather there's a header row or not
    [Parameter(HelpMessage="Determines if there's a header row.")]
    [switch]$HasHeaderRow
)

begin {
    if($hdrRow) { $HasHeaderRow = $true}     # if none is specified assume it's there

    [int]$cnt=0;
}

Process {
    $cnt++;

    if ($HasHeaderRow -and $hdrRow) {
        [string]$FirstLine = (Get-Content $CSVFiles -First 1).Replace(" ","").ToUpper()
        $hdrRow=$hdrRow.Replace(" ","").ToUpper()
        $HeaderMatch = [bool]($hdrRow -clike $FirstLine)
    }

    # Start getting information about the file.
    $Results = @{}
    $fileContent = Get-Content $CSVFiles
    $Lines = [int]($fileContent | Measure-Object -Line).Lines
    $NonBlankLines = [int]($fileContent | Select-String . | Measure-Object).Count
    $BlankLines = $Lines - $NonBlankLines
    $HdrCnt = if($HasHeaderRow) {1} else {0}
    $ValidRecords = [int]($fileContent | Select-String $RELinePtrn | Measure-Object).Count
    [bool]$VerifiedRecordsExist = ($ValidRecords -ge 1)

    $Results.Add("FileName", $CSVFiles.FullName)

    $Results.Add("HasHeader", $HasHeaderRow)
    $Results.Add("LineCount", $Lines)
    
}