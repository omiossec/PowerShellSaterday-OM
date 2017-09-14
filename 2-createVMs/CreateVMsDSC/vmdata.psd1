@{

    AllNodes = 
    @(

        @{ 
            NodeName="*"  
            TemplateVHDX="m:\template\win2016.vhdx"                                         
            MountDir="m:\Temp\"                                                                
            ToolsLocation = "m:\Tools\"
        },
        @{ 
            
            NodeName="lab-node01"                                   
            Role="HyperV"
            path="m:\vm\" 
            VMs=@(
            @{ 
                VMName="vm-front01"                                     
                VMMemory=2GB
                VMCpu=2        
                comment="Vm PowerShell Saterday" 
                user="MonAdmin"
                Pass="Pa33w0rD1"
                generation=2
                path="vm-front01"
                Type="win2016"
                role="web" 
                NICs=@(
                    @{
                        Name="eth0"
                        IPAddress="10.184.108.5"                   
                        MacAddress="00-1D-C8-00-00-01"    
                        gateway="10.184.108.1"
                        prefixLenght="24"    
                        vlan="10"               
                    }
                )
                CONTROLERs=@(
                     @{
                        ID="1"
                        type="ISCI"
                        VHDs =@{
                            Name="web.vhdx"
                            Size=20GB
                            BlockSizeBytes=1MB
                            },    
                            @{
                            Name="log.vhdx"
                            Size=20GB
                            BlockSizeBytes=1MB
                            }            
                    }
                )
              },
              @{    
                VMName="vm-db01"                                                                          
                VMMemory=4GB
                VMCpu=2        
                comment="Vm PowerShell Saterday" 
                user="MonAdmin"
                Pass="Pa33w0rD1"
                generation=2
                path="vm-front01"
                Type="win2016"
                role="web"                                        
                NICs=@(
                    @{
                        Name="eth0"
                        IPAddress="10.184.108.6"                   
                        MacAddress="00-1D-C8-00-00-02"    
                        gateway="10.184.108.1"
                        prefixLenght="24"  
                    }
                )
                CONTROLERs=@(
                     @{
                        ID="1"
                        type="ISCI"
                        VHDs =@{
                            Name="web.vhdx"
                            Size=10GB
                            BlockSizeBytes=1MB
                            },    
                            @{
                            Name="backup.vhdx"
                            Size=40GB
                            BlockSizeBytes=1MB
                            }            
                    }
                )
              }
            )
        }
    )
}