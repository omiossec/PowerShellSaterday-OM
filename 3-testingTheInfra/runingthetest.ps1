# how to collect the data from Pester and use them in a good looking webpage for the boos

# simple test 

invoke-pester -Script simple.test.ps1


# function 

.\integration.function.test.ps1


# parameter 

$Date = Get-Date -Format ddMMyyyHHmmss
$reportFolder = 'c:\report\'
if (!(test-path $reportFolder))
{
    mkdir $reportFolder
}


Push-Location $reportFolder
$pesterxml = $reportFolder + "deploiresult_$Date.xml"
 

invoke-pester -Script integration.test.ps1 -OutputFile $pesterxml -OutputFormat NUnitXml


& C:\scripts\reportunit.exe $reportFolder

