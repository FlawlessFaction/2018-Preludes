class systeminfo {
    ##class properties
    [string] $ComputerName
    [string] $BIOSmanufacturer
    [string] $BIOSVersion
    [String] $Domain
    [int] $NumberOfProcessors
    [int] $NumberofCores
    [double] $TotalPhysicalMemory
    [string] $OperatingSystemName
    [string] $OperatingSystemArchitecture
    [string] $TimeZone
    [double] $SizeOfCdrive
    [double] $CdriveFreeSpace

    ## default constructor
    SystemInfo(){}

    ## constructor with arguments
    systemInfo([string]$ComputerName,[string]$Domain){
        if(($ComputerName -eq '') -or ($ComputerName -eq $null)) {
            throw [System.InvalidOperationException]::new(
                "ComputerName is empty or null")
        }
        if(($Domain -eq '') -or ($Domain -eq $null)) {
            throw [System.InvalidOperationException]::new(
                "Domain is empty or null")
        }

        $this.ComputerName = $ComputerName
        $this.Domain = $Domain
    }

    ## Constructor to also populate properties
    SystemInfo([string] $ComputerName){
        if(($ComputerName -eq '') -or ($ComputerName -eq $null)) {
            throw [System.InvalidOperationException]::new(
                "ComputerName is empty or null")
        }

        if($ComputerName -ne $env:COMPUTERNAME) {
            throw "$ComputerName NOT equl to loacl machine name"
        }

        $this.GetAllInfo()
    }

    [void] GetComputerInfo() {
        $compsys = Get-CimInstance -ClassName win32_ComputerSystem

        $this.ComputerName = $compsys.Name
        $this.TotalPhysicalMemory = [math]::Ceiling($compsys.TotalPhysicalMemory / 1Gb)
        $this.Domain = $compsys.Domain
        $this.NumberOfProcessors = $compsys.NumberOfLogicalProcessors
    }
    [void] GetCoresInfo() {
        $proc = Get-CimInstance -ClassName Win32_Processor
        $this.NumberofCores = $proc.NumberOfCores
    }

    [void] GetBIOSINFO() {
        $bios = Get-CimInstance -ClassName Win32_BIOS

        $this.BIOSmanufacturer = $bios.Manufacturer
        $this.BIOSVersion = $bios.Version
    }

    [void] GetOSINFO(){
        $os = Get-CimInstance -ClassName Win32_OperatingSystem

        $this.OperatingSystemName = $os.Caption
        $this.OperatingSystemArchitecture = $os.OSArchitecture
    }

    [void] GetTimeZoneInfo(){
        $this.TimeZone = (Get-TimeZone).DisplayName
    }

    [void] GetDiskInfo(){
        $disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"

        $this.SizeOfCdrive = [math]::Round(($disk.Size / 1Gb), 2)
        $this.CdriveFreeSpace = [math]::Round(($disk.FreeSpace /1Gb), 2)
    }

    [void] GetAllInfo () {
        $this.GetComputerInfo()
        $this.GetCoresInfo()
        $this.GetBIOSINFO()
        $this.GetOSINFO()
        $this.GetTimeZoneInfo()
        $this.GetDiskInfo()
    }

    [double] CalcFreeSpacePerc() {
        if(($this.SizeOfCdrive -eq 0) -or ($this.CdriveFreeSpace -eq 0)){
            $this.GetDiskInfo()
        }
        $perc = ($this.CdriveFreeSpace / $this.SizeOfCdrive) * 100

        return [math]::round($perc, 1)
    }
}
##
## create class instance
##
$sysinfo = [systemInfo]::new($env:COMPUTERNAME)

##
## run pester tests
## data derived by different method
## wherever possible though maybe
## the same under the hood
##