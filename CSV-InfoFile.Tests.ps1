Import-Module Pester
#. .\Get-CSVInfo.ps1

Describe "CSV-Info Tests" {
    It 'Test Pester' -Tag 'OnlyOne' {
        2 | Should -Be 2
    }
    It 'Counts Blank Lines' {
        $csvData = 
@"
H1,H2,H3

a,b,c
1,2,3

"@
        $csvData | out-file "TestDrive:\test.csv"
        (.\Get-CSVInfo -CSVFiles (Get-ChildItem "TestDrive:\test.csv")).EmptyRows | Should -Be 2
    }
}