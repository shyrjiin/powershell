
function analysis{
write-host "------------------------------------------------------"
write-host""
write-host""
write-host "	1. Analyze before malware"
write-host "	2. Analyze after malware"
write-host "	3. Compare the two output files"
write-host "	4. Exit"
write-host ""
write-host ""
write-host "------------------------------------------------------"
$answer = read-host "Choose an option"

if ($answer -eq 1){

Get-ItemProperty -path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU >> c:\users\user\desktop\before_analysis.txt

Get-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" >> c:\users\user\desktop\before_analysis.txt

Gci -path HKLM:\SYSTEM\CurrentControlSet\Services\ | Select-Object -ExpandProperty name >> c:\users\user\desktop\before_analysis.txt

Get-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" >> c:\users\user\before_analysis.txt

Get-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" >> c:\users\user\desktop\before_analysis.txt

Get-ItemProperty -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" >> c:\users\user\desktop\before_analysis.txt

gci -path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\' >> c:\users\user\desktop\before_analysis.txt

Get-ItemProperty -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce" >> c:\users\user\desktop\before_analysis.txt

gci 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles'>> c:\users\user\desktop\before_analysis.txt

gci -path HKLM:\SYSTEM\CurrentControlSet\Enum\USB\ | format-list * >> c:\users\user\desktop\before_analysis.txt

}

if ($answer -eq 2){

Get-ItemProperty -path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU >> c:\users\user\desktop\after_analysis.txt

Get-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" >> c:\users\user\desktop\after_analysis.txt

Gci -path HKLM:\SYSTEM\CurrentControlSet\Services\ | Select-Object -ExpandProperty name >> c:\users\user\desktop\after_analysis.txt

Get-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" >> c:\users\user\desktop\after_analysis.txt

Get-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" >> c:\users\user\desktop\after_analysis.txt

Get-ItemProperty -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" >> c:\users\user\desktop\after_analysis.txt

gci -path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\' >> c:\users\user\desktop\after_analysis.txt

Get-ItemProperty -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce" >> c:\users\user\desktop\after_analysis.txt

gci -path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles' >> c:\users\user\desktop\after_analysis.txt

gci -path HKLM:\SYSTEM\CurrentControlSet\Enum\USB\ | format-list *  >> c:\users\user\desktop\after_analysis.txt

}

if ($answer -eq 3){

compare-object -ReferenceObject (gc c:\users\user\desktop\before_analysis.txt) -DifferenceObject (gc c:\users\user\desktop\after_analysis.txt) > C:\users\user\Desktop\analysis_difference.txt ; gc C:\Users\user\Desktop\analysis_difference.txt
}

if ($answer -eq 4){exit}

}

analysis
