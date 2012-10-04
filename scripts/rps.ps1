<#    
    .PARAMETER Chat
    dsafdsf
#>

PARAM(
    [Parameter(HelpMessage = "Exchange server to connect to")]
    [String]
    $Exchange,
    [Parameter(HelpMessage = "Remove a PS session for a server")]
    [Switch]
    $Remove,
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
            Write-Warning "No Exchange session to exit from.";
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

Write-Warning "No connection specified."