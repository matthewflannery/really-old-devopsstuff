$urlList = "http://first.example.com", "http://second.example.com"

while ($true) {
	
	foreach ($url in $urlList) {
	
		Write-Host "[+] Checking: " + $url
		$result = Invoke-WebRequest -Uri $url -Method GET
		Write-Host $result.Content
		Start-Sleep -Seconds 3
	}
}