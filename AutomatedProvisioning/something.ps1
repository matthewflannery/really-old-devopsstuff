
# Make sure that this folder exists!!
$vmName = "PUPPET-AGENT-1"
$hyperVRootFolder = "C:\VM"
$nbProcessors = 1
$switchName = "Public"
$mbRam = 512 * 1MB
$templateVHDPath = "C:\VMs\Templates\ubuntu-agent02 - Copy.vhdx"

Write-Host "[+] Definition: $vmName Processors: $nbProcessors Switch: $switchName RAM: $mbRam" -ForegroundColor Green
$vmPath = Join-Path $hyperVRootFolder $vmName
$vhdPath = Join-Path $vmPath "Virtual Hard Disks" 

$systemVHDPath = Join-Path $vhdPath ("{0}_0.vhdx" -f $vmName)
 
#Create VM Container folder and copy template VHD
Write-Host "[+] Creating folder for VM resources: $vmPath"
New-Item -ItemType Directory -path $vmPath | Out-Null

Write-Host "[+] Creating folder for VHDX's: $vhdPath"
New-Item -ItemType Directory -path $vhdPath | Out-Null
 
Write-Host "[+] Copying Template VHD to Virtual Machine"
Write-Host "[i] Source: $templateVHDPath" 
Write-Host "[i] Destination: $systemVHDPath" 
Copy-Item $templateVHDPath $systemVHDPath | Out-Null
Write-Host "[+] Template successfully copied"
 
Write-Host "[+] Creating Virtual Machine $vmName"
$vm = New-VM  -Name $vmName -NoVHD -Path $vmPath `
              -MemoryStartupBytes $mbRam -SwitchName $switchName -Generation 1 
 
Write-Host "[+] Setting processor count to $nbProcessors"
Set-VMProcessor -VM $vm -Count $nbProcessors

Write-Host "[+] Setting MAC address to dynamic"
Set-VMNetworkAdapter -VM $vm -DynamicMacAddress

Write-Host "[+] Attaching Hard Disk $systemVHDPath"
Add-VMHardDiskDrive -Path $systemVHDPath -VM $vm -ControllerType IDE

Write-Host "[+] Bringing Virtual Machine Online"
Start-VM -VM $vm

Write-Host "[+] Waiting for VM to come online"
$isUp = $false

while (-not $isUp) {

    Write-Host "`r[+] Checking VM State on $vmName" -NoNewline
    $vm = Get-VM -Name $vmName
    Write-Host "`r[+] Checking VM State on $vmName - $($vm.State)"

    if ($vm.State -ieq "Running") {
        $isUp = $true
        break
    }

    Sleep -Seconds 1
}

Write-Host "[+] VM Creation is Complete: "

