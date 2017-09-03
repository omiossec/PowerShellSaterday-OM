# nombre de cmdlet dans le module hyper-v 

Get-Command -Module hyper-v | Measure-Object | select-object Count