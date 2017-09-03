<#
.SYNOPSIS 
POWERSHELL SATURDAY DEMO, CREATE VM AVEC DSC, Olivier Miossec, Powershell & Hyper-v
Le but est de pouvoir déployer une VM directement depuis DSC sans passer par un module ou un script
Prend un fichier psd1 pour les data en paramêtre 

.EXAMPLE
.\createVMbtDSC -DataFile .\MyConfig.psd1

.NOTES 
Author : Olivier Miosssec 
Demo Hyper-V et DSC de la présention PowerShell et Hyper-V 

#>

[CmdletBinding()]
    param(
        [Parameter(mandatory=$true)]
        [String] $DataFile
    )


Configuration DeployVMs
{
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'xHyper-v'

    write-verbose "passage sur tous les noeuds du fichier de data"

    Node $AllNodes.Where{$_.Role -eq "HyperVHost"}.NodeName
    {

        write-verbose "passons sur toutes les VM du node"
        foreach ($vm in $node.VMs) {
            write-verbose "Creation du dossier pour $($vm.VMName)"  

            File "CreateVMFolder_$($vm.VMName)"
            {
                Type = "Directory"
                Ensure = "Present"
                Force = $True
                DestinationPath = $node.path+"\"+$($vm.VMName)                    
            }

            write-verbose "Copy du disque system $($vm.VMName)"

            File "CopyOSTemplate_$($vm.VMName)"
            {
                Type = "File"
                Ensure = "Present"
                Force = $True
                SourcePath = $node.TemplateVHDX
                DestinationPath = $node.path+"\"+$($vm.VMName)+"\"+$vm.VMName+".vhdx"
            }

            Script "MountImage_$($vm.VMName)"
            {                                      
                SetScript = {
                    $imagepath = $using:node.path+"\"+$using:vm.VMName+"\"+$using:vm.VMName+".vhdx"
                    $mountpath = $using:node.MountDir+"\"+$($using:vm.VMName)

                    Write-verbose "Mounting image [$imagepath] to [$mountpath]"
                    Mount-WindowsImage -ImagePath $imagepath -Index 1 -path $mountpath


                }
                TestScript = {
                    if ((get-vm | where {$_.Name -eq $($using:vm.VMName)}) -ne $null) {
                        return $true
                    }

                    return ((Test-Path (($using:node.MountDir+"\"+$($using:VMInfo.VMName)) + "\Windows")))
                }
                GetScript = {
                    return @{ result = Test-Path (($using:node.MountDir+"\"+$using:vminfo.vmname) + "\Windows") }
                }
            }


            Script "SetUnatendFile_$($vm.VMName)"
            {

                SetScript = {

                    $unattendfile = @"
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
<settings pass="windowsPE">
<component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<SetupUILanguage>
<UILanguage>en-US</UILanguage>
</SetupUILanguage>
<InputLocale>0c09:00000409</InputLocale>
<SystemLocale>en-US</SystemLocale>
<UILanguage>en-US</UILanguage>
<UILanguageFallback>en-US</UILanguageFallback>
<UserLocale>en-US</UserLocale>
</component>
<component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<UserData>
<AcceptEula>true</AcceptEula>
<FullName>--USERNAME--</FullName>
<Organization>--ORGA666</Organization>
<ProductKey>
<Key>WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY</Key>
</ProductKey>
</UserData>
<EnableFirewall>false</EnableFirewall>
</component>
</settings>
<settings pass="offlineServicing">
<component name="Microsoft-Windows-LUA-Settings" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<EnableLUA>false</EnableLUA>
</component>
</settings>
<settings pass="generalize">
<component name="Microsoft-Windows-Security-SPP" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<SkipRearm>1</SkipRearm>
</component>
</settings>
<settings pass="specialize">
<component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<InputLocale>040c:0000040c</InputLocale>
<SystemLocale>fr-FR</SystemLocale>
<UILanguage>fr-FR</UILanguage>
<UILanguageFallback>fr-FR</UILanguageFallback>
<UserLocale>fr-FR</UserLocale>
</component>
<component name="Microsoft-Windows-Security-SPP-UX" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<SkipAutoActivation>true</SkipAutoActivation>
</component>
<component name="Microsoft-Windows-SQMApi" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<CEIPEnabled>0</CEIPEnabled>
</component>
<component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<ComputerName>--SERVERNAME--</ComputerName>
</component>
</settings>
<settings pass="oobeSystem">
<component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<AutoLogon>
<Password>
<Value>--PASSWORD--</Value>
<PlainText>true</PlainText>
</Password>
<Enabled>true</Enabled>
<Username>--USERNAME--</Username>
</AutoLogon>
<OOBE>
<HideEULAPage>true</HideEULAPage>
<HideLocalAccountScreen>true</HideLocalAccountScreen>
<HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
<HideOnlineAccountScreens>true</HideOnlineAccountScreens>
<HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
<NetworkLocation>Work</NetworkLocation>
<ProtectYourPC>1</ProtectYourPC>
<SkipMachineOOBE>true</SkipMachineOOBE>
<SkipUserOOBE>true</SkipUserOOBE>
</OOBE>
<UserAccounts>
<AdministratorPassword>
<Value>--PASSWORD--</Value>
<PlainText>true</PlainText>
</AdministratorPassword>
<LocalAccounts>
<LocalAccount wcm:action="add">
<Description>--USERNAME--</Description>
<DisplayName>--USERNAME--</DisplayName>
<Group>Administrators</Group>
<Name>--USERNAME--</Name>
</LocalAccount>
</LocalAccounts>
</UserAccounts>
<RegisteredOrganization>--ORGA666</RegisteredOrganization>
<RegisteredOwner>--USERNAME--</RegisteredOwner>
<DisableAutoDaylightTimeSet>false</DisableAutoDaylightTimeSet>
<TimeZone>Romance Standard Time</TimeZone>
</component>
</settings>
</unattend>
"@



                }





            }



        }
    }



}



function Initialize-DSC
{
    DeployVM -ConfigurationData $ConfigData -verbose

}




# Chargement des données 
$configdata = [hashtable] (Invoke-Expression (Get-Content $DataFile | out-string))

# start the process 

try {


    write-verbose "Etape 1 Compilation des configurations"

    Initialize-DSC

}
 catch 
    {
            Write-Verbose "Exception: $_"
            throw
    }