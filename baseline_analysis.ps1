
function baseline{

write-host "------------------------------------------------------"
write-host""							                          
write-host""							                          
write-host "	1. Gather baseline prior to"			          
write-host "	2. Gather system info after"			          
write-host "	3. Compare the two output files"		          
write-host "	4. Exit"					                      
write-host ""							                          
write-host ""							                          
write-host "------------------------------------------------------"

$answer = read-host "Choose an option"
$path = "$env:USERPROFILE\Desktop"

if ($answer -eq 1){

Get-Date | out-file -append -filepath $path/before_baseline.txt

get-localuser | Select-Object name | out-file -append -filepath $path/before_baseline.txt

Get-LocalGroup | Select-Object name | out-file -append -filepath $path/before_baseline.txt

query user | out-file -append -filepath $path/before_baseline.txt

Get-Process | select-object processname | out-file -append -filepath $path/before_baseline.txt

Get-Service | Select-Object displayname | out-file -append -filepath $path/before_baseline.txt

Get-NetIPConfiguration | out-file -append -filepath $path/before_baseline.txt

Get-NetTCPConnection | format-table state,localport,localaddress,remoteport,remoteaddress | out-file -append -filepath $path/before_baseline.txt

Get-SmbShare | out-file -append -filepath $path/before_baseline.txt

Get-PnpDevice | Select-Object class, friendlyname | out-file -append -filepath $path/before_baseline.txt

get-ciminstance win32_operatingsystem | format-list * | out-file -append -filepath $path/before_baseline.txt

Get-WmiObject -class win32_share | out-file -append -filepath $path/before_baseline.txt

Get-ScheduledTask | out-file -append -filepath $path/before_baseline.txt

}

if ($answer -eq 2){

Get-Date | out-file -append -filepath $path/after_baseline.txt

get-localuser | Select-Object name | out-file -append -filepath $path/after_baseline.txt

Get-LocalGroup | Select-Object name | out-file -append -filepath $path/after_baseline.txt

query user | out-file -append -filepath $path/before_baseline.txt

Get-Process | select-object processname | out-file -append -filepath $path/after_baseline.txt

Get-Service | Select-Object displayname | out-file -append -filepath $path/after_baseline.txt

Get-NetIPConfiguration | out-file -append -filepath $path/after_baseline.txt

Get-NetTCPConnection | format-table state,localport,localaddress,remoteport,remoteaddress | out-file -append -filepath $path/after_baseline.txt

Get-SmbShare | out-file -append -filepath $path/after_baseline.txt

Get-PnpDevice | Select-Object class, friendlyname | out-file -append -filepath $path/after_baseline.txt

get-ciminstance win32_operatingsystem | format-list * | out-file -append -filepath $path/after_baseline.txt

Get-WmiObject -class win32_share | out-file -append -filepath $path/after_baseline.txt

Get-ScheduledTask | out-file -append -filepath $path/after_baseline.txt

}

if ($answer -eq 3){

compare-object -ReferenceObject (gc $path/before_baseline.txt) -DifferenceObject (gc $path/after_baseline.txt) > $path/baseline_difference.txt ; gc $path/baseline_difference.txt
}

if ($answer -eq 4){exit}
$check = $answer -match '^[1234]'
if (-not $check) {write-host "Invalid Selection"}
}

baseline
