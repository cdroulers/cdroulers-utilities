<#
	.SYNOPSIS
	Adds a mercurial username to a repository.
	Since Mercurial config only allows multiple credentials and not usernames, this
	script makes it easy to add the username to the hgrc file after a clone.
	
	.PARAMETER RepositoryPath
	The path of the repository to set the username for.
	.PARAMETER Username
	Username to set for the repository
#>

PARAM(
	[Parameter(HelpMessage = "Path of repo",
		ValueFromPipeline = $true)]
	[string]
	$RepositoryPath = ".",
	[Parameter(HelpMessage = "Username to set")]
	[string]
	$Username = [string]::Empty
)

Function ImportIni (
    [string]
	$Path
)
{
    $ini = @{};
    if (Test-Path -Path $Path)
    {
        switch -regex -file $Path
        {
            "^\[(.+)\]$"
            {
                $Category = $matches[1];
                $ini.$Category = @{};
            }
            "(.+)=(.+)"
            {
                $Key = $matches[1].TrimEnd();
				$Value = $matches[2].TrimStart();
                $ini.$Category.$Key = $Value;
            }
        }
    }
    else
    {
        Write-Host "File not found - $Path";
    }
    return $ini;
}

Function ExportIni (
    [hashtable]
	$inputObject,
    [string]
	$Path
)
{
    $Content = @();
    ForEach ($Category in $inputObject.Keys)
    {
        $Content += "[$Category]";
        ForEach ($Key in $inputObject.$Category.Keys)
        {
            $Content += "$Key = $($inputObject.$Category.$Key)";
        }
		$content[$content.Length - 1] += [Environment]::NewLine;
    }
    $Content | Set-Content $Path -Force;
}

Function GetUsernameFromConfig([string]$repoPath, [string]$directory)
{
	$configfile = Join-Path $directory "_hg-user.cfg";
	
	Switch -Regex -File $configfile
	{
		"(.+)=(.+)"
		{
			$key = $matches[1].TrimEnd();
			$value = $matches[2].TrimStart();
			if ($repoPath -match $key)
			{
				return $value;
			}
		}
	}
	Write-Error "No username provided and no configuration found for repository $repoPath";
}

if (!(Test-Path -Path $RepositoryPath))
{
	Write-Error "Specified folder does not exist!";
	exit 1;
}
if (!(Test-Path -Path (Join-Path $RepositoryPath ".hg")))
{
	Write-Error "Specified folder is not a Mercurial Repository!";
	exit 1;
}
if (!(Test-Path -Path (Join-Path $RepositoryPath ".hg\hgrc")))
{
	Write-Error "Specified folder does not contain an hgrc file!";
	exit 1;
}

$hgrc = ImportIni (Join-Path $RepositoryPath ".hg\hgrc");
$currentDir = Split-Path $MyInvocation.MyCommand.Path;

if ([string]::IsNullOrEmpty($Username))
{
	$Username = GetUsernameFromConfig $hgrc.paths.default $currentDir;
}

if ($hgrc.ui -eq $null)
{
	$hgrc.ui = @{}
}
$hgrc.ui.username = $Username;
ExportIni $hgrc (Join-Path $RepositoryPath ".hg\hgrc");