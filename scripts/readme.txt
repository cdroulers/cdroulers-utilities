rps.ps1

To enable remote management of a computer, you must start the Windows Remote Management service (and put it to automatic start)

View this Stack Overflow for help: http://stackoverflow.com/questions/1469791/powershell-v2-remoting-how-do-you-enable-unecrypted-traffic
Also this: http://technet.microsoft.com/en-us/magazine/ff700227.aspx

On the remote server, execute the following commands as an administrator:
- set-item -force WSMan:\localhost\Service\AllowUnencrypted $true

On the client, run a PowerShell as the actual Administrator (maybe needs to be enable in user management).
Everything that has to be done on the client should be run as the Administrator user!
- Set-Item -Force WSMan:\localhost\Client\AllowUnencrypted $true