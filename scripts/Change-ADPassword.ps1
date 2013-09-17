<#    
    .PARAMETER User
    Which UserName to reset the password for
#>

PARAM(
    [Parameter(HelpMessage = "Which UserName to reset the password for",
        ValueFromPipeline = $True,
        Mandatory = $True)]
    $UserName
)

Import-Module ActiveDirectory -ErrorAction SilentlyContinue;

$userToReset = Get-ADUser $UserName -ErrorAction Stop;

if ($userToReset)
{
    Set-ADAccountPassword $userToReset;
}