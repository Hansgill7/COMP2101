$Computer=hostname

$Connection = Test-Connection $Computer -Count 1 -Quiet

if ($Connection -eq "True") {

    $SystemHW = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $Computer |
        select Manufacturer,Model | Format-List 

    $SystemCPU = Get-WmiObject win32_processor -ComputerName $Computer |
        select Description,Name,CurrentClockSpeed, NumberOfCores, L1CacheSize,L2CacheSize,L3CacheSize | Format-List 

    $SystemRam_Total = Get-WmiObject Win32_PhysicalMemoryArray |
        select MemoryDevices,MaxCapacity | FT -AutoSize

    $SystemRAM = Get-WmiObject Win32_PhysicalMemory |
        foreach {
 new-object -TypeName psobject -Property @{
 Manufacturer = $_.model
 "Speed(MHz)" = $_.speed
 "Size(MB)" = $_.capacity/1mb
 Bank = $_.banklabel
 Slot = $_.devicelocator
 }
 $totalcapacity += $_.capacity/1mb
} |
ft -auto Manufacturer, "Size(MB)", "Speed(MHz)", Bank, Slot

    $SystemDisks = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $Computer |
        select Name,Size,FreeSpace | FT -AutoSize

 $adapters = get-ciminstance win32_networkadapterconfiguration
$filteredadapters = $adapters | Where-Object {$_.IPEnabled}


    $SystemOS = (Get-WmiObject Win32_OperatingSystem -ComputerName $Computer).Version

    switch -Wildcard ($SystemOS) {
        "6.1.7600" {$OS = "Windows 7"; break}
        "6.1.7601" {$OS = "Windows 7 SP1"; break}
        "6.2.9200" {$OS = "Windows 8"; break}
        "6.3.9600" {$OS = "Windows 8.1"; break}
        "10.0.*" {$OS = "Windows 10"; break}
        default {$OS = "Unknown Operating System"; break}
    }
    
    Write-Host "Computer Name: $Computer"

    Write-Host "Operating System: $OS, Version:$SystemOS"

    "System Hardware Info"

    Write-Output $SystemHW

    "Processor Info"

    Write-Output $SystemCPU

    "RAM Info"

    Write-Output $SystemRam_Total

    Write-Output $SystemRAM

"Total RAM: ${totalcapacity}MB "


"Video Card Info"

 Get-wmiObject win32_videocontroller |
        foreach {
 new-object -TypeName psobject -Property @{
 "Vendor" = $_.adaptercompatibility
 "Description" = $_.description
 "Screen resolution" = $_.currenthorizontalresolution, $_.Currentverticalresolution
 }
 }

"Network Adapter config"

$filteredadapters | format-table -autosize description,index,ipsubnet,dnsserversearchorder,dnsdomain,ipaddress

"Disks Info"

    Write-Output $SystemDisks
$diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
  foreach ($name in $partitions) {
                new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Location=$name.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                              
                                                               }
           }
      }

}
else {

    Write-Host -ForegroundColor Red @"
Computer is not reachable or does not exists.
"@
}