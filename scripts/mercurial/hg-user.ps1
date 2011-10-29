<#
	.SYNOPSIS
	Adds a mercurial username to a repository.
	
	.PARAMETER Summary
	What you want the popup notification to say!
#>

PARAM(
	[Parameter(Mandatory = $true,
		HelpMessage = "What do you want to be nagged about?",
		ValueFromPipeline = $true)]
	[string]
	$Summary,
	[Parameter()]
	[string]
	$Start = "08:00",
	[Parameter()]
	[string]
	$End = "18:00",
	[Parameter()]
	[int]
	$Step = 60,
	[Parameter()]
	[string]
	$Location = "",
	[Parameter()]
	[string]
	$Description = "",
	[Parameter()]
	[string]
	$Source = "Nagging.ics",
	[Parameter()]
	[string]
	$Destination = "Nagging.ics"
)

$template = "BEGIN:VEVENT
DTSTAMP:{TIMESTAMP}
TRANSP:OPAQUE
UID:{UID}
SUMMARY:{SUMMARY}
LOCATION:{LOCATION}
DESCRIPTION:{DESCRIPTION}
CLASS:PRIVATE
LAST-MODIFIED:{TIMESTAMP}
RRULE:FREQ=DAILY
DTSTART:{DTSTART}
BEGIN:VALARM
ACTION:AUDIO
TRIGGER;VALUE=DURATION:-PT1M
END:VALARM
END:VEVENT"

Function FormatLongLine($line)
{
	$firstLineLength = 63;
	$index = $firstLineLength;
	while ($index -lt $line.Length)
	{
		$line = $line.Insert($index, "`n ");
		$index += 72;
	}
	return $line.Replace(",", "\,");
}

$startStamp = [TimeSpan]::Parse($Start);
$endStamp = [TimeSpan]::Parse($End);

$result = "";

while ($startStamp -le $endStamp)
{
	$diff = [DateTime]::UtcNow - [DateTime]::Now;
	$dtstart = ([DateTime]::UtcNow.Date + ($startStamp + $diff)).ToString("yyyyMMddTHHmmssZ");
	$longSummary = FormatLongLine($Summary);
	$longLocation = FormatLongLine($Location);
	$longDescription = FormatLongLine($Description);
	$result += $template.Replace("{TIMESTAMP}", [DateTime]::UtcNow.ToString("yyyyMMddThhmmssZ")).Replace("{UID}", [Guid]::NewGuid().ToString()).Replace("{SUMMARY}", $longSummary).Replace("{LOCATION}", $longLocation).Replace("{DESCRIPTION}", $longDescription).Replace("{DTSTART}", $dtstart) + [Environment]::NewLine;
		
	$startStamp = $startStamp + [TimeSpan]::FromMinutes($Step);
}

$location = (Get-Location).Path;
$content = [System.IO.File]::ReadAllText([System.IO.Path]::Combine($location, $Source));
$indexOf = $content.LastIndexOf("END:VCALENDAR");
$content = $content.Insert($indexOf, $result);

[System.IO.File]::WriteAllText([System.IO.Path]::Combine($location, $Destination), $content);