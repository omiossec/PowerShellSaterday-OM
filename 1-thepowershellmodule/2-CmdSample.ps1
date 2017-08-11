# Certaine fonctionnalité ne sont disponible qu'avec powershell 


get-vm -name TrunkDemo | Set-VMNetworkAdapterVlan -Trunk -NativeVlanId 1 -AllowedVlanIdList 10-20