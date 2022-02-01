$content=Get-ChildItem Cert:\LocalMachine\Root\*  | Where-Object Thumbprint -eq "3679CA35668772304D30A5FB873B0FA77BB70D54"
 
 if($content) {
	 Write-Host "Exists"
 } else {
	Write-Host "Does not exist"
 }
