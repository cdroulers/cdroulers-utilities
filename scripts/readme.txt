rps.ps1

INSTALL POWERSHELL 3!
http://www.microsoft.com/en-us/download/details.aspx?id=34595

To enable remote management of a computer, you must start the Windows Remote Management service (and put it to automatic start)

View this Stack Overflow for help: http://stackoverflow.com/questions/1469791/powershell-v2-remoting-how-do-you-enable-unecrypted-traffic
Also this: http://technet.microsoft.com/en-us/magazine/ff700227.aspx

On the remote server, execute the following commands as an administrator:
- set-item -force WSMan:\localhost\Service\AllowUnencrypted $true
- Enable-PSRemoting -Force

On the client, run a PowerShell as the actual Administrator (maybe needs to be enable in user management).
Everything that has to be done on the client should be run as the Administrator user!
- Set-Item -Force WSMan:\localhost\Client\AllowUnencrypted $true


Enabling ping via PowerShell: http://msmvps.com/blogs/richardsiddaway/archive/2009/08/30/enable-ping.aspx

$fw = New-Object -ComObject HNetCfg.FWPolicy2
$fw.Rules | where {$_.Name -like "File and Printer Sharing (Echo Request - ICMPv4-In)"} |  foreach { $_.Enabled = $true }
$fw.Rules | where {$_.Name -like "File and Printer Sharing (Echo Request - ICMPv4-In)"} |  Format-Table Name, Direction, Protocol, Profiles, Enabled -AutoSize

Enable getting password via the command line instead of GUI : (http://blogs.msdn.com/b/powershell/archive/2008/06/20/getting-credentials-from-the-command-line.aspx)
$key = "HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds"
Set-ItemProperty $key ConsolePrompting True

List listeners : (http://blogs.msdn.com/b/wmi/archive/2009/07/22/new-default-ports-for-ws-management-and-powershell-remoting.aspx)
winrm e winrm/config/listener