# Example of creating a module and exporting it as a variable.

$Urls = New-Module {            
    [string]$BitBucket = "https://bitbucket.org/";
        
    Export-ModuleMember -Variable * -Function *
} -asCustomObject