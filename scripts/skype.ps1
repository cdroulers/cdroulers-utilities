<#    
    .PARAMETER Call
    Starts a chat window with the specified username
    .PARAMETER Main
    Starts the main Communicator Window.
#>

PARAM(
    [Parameter(HelpMessage = "Start a call window with someone",
        ValueFromPipeline = $True)]
    [String]
    $Call,
    [Switch]
    $Main
)

$SkypePath = "C:\Program Files (x86)\Skype\Phone\skype.exe";

if ($Main)
{
    & $SkypePath
    Exit;
}

if ($Call)
{
    & $SkypePath /callto:$Call
    Exit;
}

Write-Warning "No command specified";