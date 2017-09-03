# Certaine fonctionnalité ne sont disponible qu'avec powershell 


get-vm -name TrunkDemo | Set-VMNetworkAdapterVlan -Trunk -NativeVlanId 1 -AllowedVlanIdList 10-20



new-vm -Name Vm1 -Path m:\vm -MemoryStartupBytes 2GB -VHDPath x:\vm\vmname.vhdx -Generation 2 

Get-VMNetworkAdapter -VMName vmname | Connect-VMNetworkAdapter -SwitchName VmSwitch

new-vhd –path x:\vmname\vname-data.vhdx -SizeBytes 20GB -Dynamic

Add-VMHardDiskDrive  -VMName vmname -Path x:\vmname\vname-data.vhdx