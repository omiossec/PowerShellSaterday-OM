


# Lire le fichier Json 

 

$jsonPath =    (Split-Path $script:MyInvocation.MyCommand.Path).ToString() + "\vmlist.json"



$VmValues = Get-Content $jsonPath -Raw | ConvertFrom-Json 


$VmValues.Allnodes

foreach ($vm in $VmValues.Allnodes.vms)
{


    write-host $vm.Vmname

}