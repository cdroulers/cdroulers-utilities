<#    
    .PARAMETER Chat
    Starts a chat window with the specified username @$Domain parameter
    .PARAMETER Domain
    The domain of the user to start whatever with. Default is "sherweb.com"
    .PARAMETER Main
    Starts the main Communicator Window.
#>

PARAM(
    [Parameter(HelpMessage = "Start chat window with someone",
        ValueFromPipeline = $True)]
    [String]
    $Chat,
    [String]
    $Domain = "sherweb.com",
    [Switch]
    $Main
)

$CommPath = "C:\Program Files (x86)\Microsoft Lync\communicator.exe";

if ($Main)
{
    & $CommPath
    Exit;
}

if ($Chat)
{
    $user = $Chat + "@" + $Domain;
    & $CommPath sip:$user
    Exit;
}

Write-Warning "No command specified";