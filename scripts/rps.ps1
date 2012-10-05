<#    
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
    [Parameter(HelpMessage = "Exchange server to import from")]
    [String]
    $Exchange,
    [Parameter(HelpMessage = "Remove a PS session (Exchange)")]
    [Switch]
    $Remove,
    [Parameter(HelpMessage = "SharePoint server to connect to")]
    [String]
    $SharePoint,
    [Parameter(HelpMessage = "Lync server to import from")]
    [String]
    $Lync,
    [Parameter(HelpMessage = "Credentials to use")]
    [PSCredential]
    $Credential
)

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
        $global:ExchangeSession = New-PSSession -ConfigurationName $namespace -ConnectionUri $uri -Credential $Credential;
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

if ($Lync)
{
    if ($Remove)
    {
        if (!$global:LyncSession -or $global:LyncSession.State -ne "Opened")
        {
            Write-Warning "No Lync session to remove.";
            Exit;
        }
        Write-Host "Exiting '$($global:LyncSession.ComputerName)' Lync connection";
        Remove-PSSession $global:LyncSession;
        Exit;
    }
    if (!$global:LyncSession -or $global:LyncSession.State -eq "Closed")
    {
        $uri = "https://$Lync/OcsPowerShell";
        Write-Host "Connecting to $uri";
        $skipOptions = New-PSSessionOption -SkipCACheck -SkipRevocationCheck -SkipCNCheck;
        $global:LyncSession = New-PSSession -ConnectionUri $uri -Credential $Credential -SessionOption $skipOptions;
        Import-PSSession $global:LyncSession;
    }
    else
    {
        Write-Warning "You are already connected to '$($global:LyncSession.ComputerName)' for Lync";
    }
    Exit;
}

Write-Warning "No connection specified."