## Enable TLS 2.0
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[CmdletBinding()]

## Path to install Sysmon
$path = 'C:\Program Files\Sysmon'

## check if sysmon is running
if ( get-process "sysmon" ) {
		If(test-path $path) {
			Write-Host "OK: Sysmon appears to be running from $path";
			Exit;
		} else {
			Write-Host "WARN: Sysmon is running but not from $path"
			Exit;
		}	
}

If(!(test-path $path))
{
	Write-Information -MessageData "INFO: Path does not exist.  Creating Path..." -InformationAction Continue;
	New-Item -ItemType Directory -Force -Path $path | Out-Null;
	Write-Information -MessageData "INFO: ...Complete" -InformationAction Continue
} else {
	Write-Host "ERROR: C:\Program Files\Sysmon directory already exists, manual cleanup required"
	Write-Host "ERROR: Sysmon was not installed"
	Exit
}

Set-Location $path
if ($?) {
	Write-Host "OK: Successfully entered directory $path"
} else {
	Write-Host "ERROR: Failed to enter directory $path"
	Exit
}
Invoke-WebRequest -Uri https://download.sysinternals.com/files/Sysmon.zip -Outfile Sysmon.zip
if ($?) {
	Write-Host "OK: Successfully downloaded sysmon to $path"
} else {
	Write-Host "ERROR: Failed to download sysmon"
	Exit
}

Expand-Archive Sysmon.zip -DestinationPath $path
if ($?) {
	Write-Host "OK: Successfully unzipped Sysmon"
} else {
	Write-Host "ERROR: Failed to unzip Sysmon"
	Exit
}

Invoke-WebRequest -Uri https://raw.githubusercontent.com/olafhartong/sysmon-modular/master/sysmonconfig.xml -Outfile sysmon-olaf.xml
if ($?) {
	Write-Host "OK: Successfully downloaded olaf configuration to $path"
} else {
	Write-Host "ERROR: Failed to download olaf configuration"
	Exit
}

.\Sysmon.exe -accepteula -i sysmon-olaf.xml
if ($?) {
	Write-Host "OK: Successfully Installed Sysmon"
} else {
	Write-Host "ERROR: Cannot install Sysmon"
}
