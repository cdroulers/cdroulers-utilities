<#    
    .PARAMETER Chat
	Starts a chat window with the specified username @$Domain parameter
	.PARAMETER Domain
	The domain of the user to start whatever with. Default is "sherweb.com"
#>

PARAM(
    [Parameter(HelpMessage = "Start chat window with someone",
		ValueFromPipeline = $True)]
    [String]
    $Chat,
	[String]
	$Domain = "sherweb.com"
)

if ($Chat)
{
	$user = $Chat + "@" + $Domain;
	& "C:\Program Files (x86)\Microsoft Lync\communicator.exe" sip:$user
	Exit;
}

Write-Warning "No command specified";