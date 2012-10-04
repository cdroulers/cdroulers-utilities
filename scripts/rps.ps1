<#    
    .PARAMETER Basic
    Enter a PS Session on a basic server (needs some configuration! see readme.txt for info.)
    .PARAMETER Exchange
    Import a PowerShell session from that Exchange server (CAS or Front-End)
    .PARAMETER Remove
    Remove the imported PowerShell session from an Exchange Server
    .PARAMETER SharePoint
    Enter a PS Session on the SharePoint server and add SharePoint snap-in.
    .PARAMETER Credential
    Credentials to use when connecting.
#>

PARAM(
    [Parameter(HelpMessage = "Server to connect to with no specific module or anything.")]
    [String]
    $Basic,
    [Parameter(HelpMessage = "Exchange server to import from")]
    [String]
    $Exchange,
    [Parameter(HelpMessage = "Remove a PS session (Exchange)")]
    [Switch]
    $Remove,
    [Parameter(HelpMessage = "SharePoint server to connect to")]
    [String]
    $SharePoint,
    [Parameter(HelpMessage = "Credentials to use")]
    [PSCredential]
    $Credential
)

if ($Basic)
{    
    Write-Host "Entering PS Session for Server '$Basic'";
    $global:BasicSession = New-PSSession $Basic -Credential $Credential;
    Enter-PSSession $global:BasicSession;
    Exit;
}

if ($Exchange)
{
    if ($Remove)
    {
        if (!$global:ExchangeSession -or $global:ExchangeSession.State -ne "Opened")
        {
            Write-Warning "No Exchange session to remove.";
            Exit;
        }
        Write-Host "Exiting '$($global:ExchangeSession.ComputerName)' Exchange connection";
        Remove-PSSession $global:ExchangeSession;
        Exit;
    }
    if (!$global:ExchangeSession -or $global:ExchangeSession.State -eq "Closed")
    {
        $uri = "http://$Exchange/powershell";
        $namespace = "Microsoft.Exchange";
        Write-Host "Connecting to $uri/$namespace";
        $global:ExchangeSession = New-PSSession -ConfigurationName $namespace -ConnectionUri $uri -Credential $Credential
        Import-PSSession $global:ExchangeSession;
    }
    else
    {
        Write-Warning "You are already connected to '$($global:ExchangeSession.ComputerName)' for Exchange";
    }
    Exit;
}

if ($SharePoint)
{    
    Write-Host "Entering PS Session for SharePoint server '$SharePoint'";
    $global:SharePointSession = New-PSSession $SharePoint -Authentication Credssp -Credential $Credential;
    Invoke-Command -Session $global:SharePointSession { Add-PSSnapin "Microsoft.SharePoint.PowerShell" }
    Enter-PSSession $global:SharePointSession;
    Exit;
}

Write-Warning "No connection specified."