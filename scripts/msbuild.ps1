PARAM(
    [String]
    $Version = "4.0"
)

$regKey = "HKLM:\software\Microsoft\MSBuild\ToolsVersions\$Version"
$regProperty = "MSBuildToolsPath"

$msbuildExe = join-path -path (Get-ItemProperty $regKey).$regProperty -childpath "msbuild.exe"

& $msbuildExe $args