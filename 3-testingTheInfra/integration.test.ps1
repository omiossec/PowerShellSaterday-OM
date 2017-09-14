<#
##########################################################################################################################################
#                                           PowerShell Saturday Paris 2017
##########################################################################################################################################

.SYNOPSIS  
    Ce Script fait partie des démos de la présentation Hyper-V & PowerShell 
    Il permet de tester un déploiement de VM
    
.DESCRIPTION
    Ce script prend pour paramètres VMData, le chemin d'un fichier de configration psd1 contenant un hastable.
    Le même que celui utilisé pour le déploiement des VM dans la démo précédente

.PARAMETER VMDataFile
    Le chemin du fichier psd1 contenant les donnees

.EXAMPLE
    .\integration.test.ps1 -VMdata sampledata.psd1
    
.NOTES
   
    Author       : Olivier Miossec <olivier@omiossec.work>
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [String] $VMdataFile
)  


process {

   
    # Récupération des données dans une variable
    $VMData = [hashtable] (invoke-expression (get-content $vmdatafile | out-string))



    function get-vmFromDataFile
    {


        
    }


    describe 'DeployVm' {
        
        
            






        
        
        
        }



}

