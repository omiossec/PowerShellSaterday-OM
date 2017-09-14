script "Sample"
{
    SetScript {
        # Script configurant la ressource
        # l'utilisation des variables est possible
        # en utilisant $using:VarName
    }
    GetScript {
        # Get ressource
        # retourne un hash avec le mot clé result
        return @{ result = "Something" }  
    }
    TestScript {
        # Test la ressource 
        # retourne $true ou $false 
        Return $true
    }
}