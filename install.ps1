# Useful variables
$tools = 'D:\Tools'
$win10 = "$HOME\Documents"

# Disable Windows Defender
Add-MpPreference -exclusionpath "$tools\dControl"
timeout 10 /nobreak
cmd /c "$tools\dControl\dControl.exe" /D

# Change Time Zone
cmd /c tzutil /s "India Standard Time"

# Install Drivers
cmd /c D:\DoubleDriver\ddc.exe r /source:"D:\Windows 10 Drivers\H61MLV2 30-06-2021 21-27-44\MEDIA"

# Better way to install winget
# GUI Specs
Write-Host "Checking winget..."
# Check if winget is installed
if (Test-Path ~\AppData\Local\Microsoft\WindowsApps\winget.exe){
    'Winget Already Installed'
}  
else{
    # Installing winget from the Microsoft Store
	Write-Host "Winget not found, installing it now."
    Start-Process "ms-appinstaller:?source=https://aka.ms/getwinget"
    $nid = (Get-Process AppInstaller).Id
	Wait-Process -Id $nid
    Write-Host Winget Installed
}

# Windows Auto Logon
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$DefaultUsername = "Catharsis"
$DefaultPassword = "2005"
Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String
Set-ItemProperty $RegPath "DefaultUsername" -Value "$DefaultUsername" -type String
Set-ItemProperty $RegPath "DefaultPassword" -Value "$DefaultPassword" -type String

$scoopapps = @(
	"7zip",
	"adb",
	"aria2",
	"atomicparsley",
	"busybox",
	"fd",
	"fzf",
	"gallery-dl",
	"go",
	"ffmpeg",
	"youtube-dl",
	"neovim",
	"nodejs",
	"poppler",
	"rclone",
	"scrcpy",
	"speedtest-cli",
	"python",
	"gsudo",
	"wget",
	"adoptopenjdk-hotspot-jre")
	
$scoopbuckets = @(
	"java")

$chocoapps = @(
	"qbittorrent",
	"airexplorer",
	"mkvtoolnix")
	
$wingetapps = @(
	"7zip",
	"ditto",
	"irfanview",
	"musicbrainz.picard",
	"microsoft.edgewebview2runtime",
	"microsoft.windowsterminal",
	"mp3tag.mp3tag",
	"Notepad++",
	"ShareX",
	"megasync",
	"OBSProject.OBSStudio",
	"ProtonTechnologies.ProtonVPN",
	"SpeedCrunch.SpeedCrunch",
	"imagemagick",
	"Valve.Steam",
	"SumatraPDF.SumatraPDF",
	"erengy.Taiga",
	"dev47apps.DroidCam",
	"Microsoft.Teams",
	"PeterPawlowski.foobar2000",
	"Powershell",
	"subhra74.XtremeDownloadManager",
	"Microsoft.visualstudiocode",
	"Zoom.Zoom",
	"voidtools.Everything",
	"WinFsp.WinFsp",
	"Microsoft.VC++2010Redist-x86",
	"calibre.calibre",
	"Microsoft.VC++2015Redist-x64",
	"Microsoft.VC++2015Redist-x86",
	"hexchat",
	"Github Desktop")

# Scoop
Invoke-WebRequest -useb get.scoop.sh | Invoke-Expression
scoop install git
git clone https://github.com/Sourav2005/win10scripts.git $HOME\Documents
foreach ($bucket in $scoopbuckets) {
	scoop bucket add $bucket
}
foreach ($scoopapp in $scoopapps) {
	scoop install $scoopapp
}

# Chocolatey
choco feature enable -n allowGlobalConfirmation
foreach ($chocoapp in $chocoapps) {
	choco install -y $chocoapp
}

# Winget
foreach ($wingetapp in $wingetapps) {
	winget install $wingetapp
}

#Useful Functions:
function Add-EnvPath {
    param(
        [Parameter(Mandatory=$true)]
        [string] $Path,

        [ValidateSet('Machine', 'User', 'Session')]
        [string] $Container = 'Session'
    )

    if ($Container -ne 'Session') {
        $containerMapping = @{
            Machine = [EnvironmentVariableTarget]::Machine
            User = [EnvironmentVariableTarget]::User
        }
        $containerType = $containerMapping[$Container]

        $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
        if ($persistedPaths -notcontains $Path) {
            $persistedPaths = $persistedPaths + $Path | Where-Object { $_ }
            [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
        }
    }

    $envPaths = $env:Path -split ';'
    if ($envPaths -notcontains $Path) {
        $envPaths = $envPaths + $Path | Where-Object { $_ }
        $env:Path = $envPaths -join ';'
    }
}

Function Set-AssociateFileExtensions {
    Param
    (
        [Parameter(Mandatory = $true)]
        [String[]] $FileExtensions,
        
        [Parameter(Mandatory = $true)]
        [String] $OpenAppPath
    ) 

    if (-not (Test-Path $OpenAppPath)) {
        throw "$OpenAppPath does not exist."
    }   
    foreach ($extension in $FileExtensions) {
        $fileType = (cmd /c "assoc $extension")
        $fileType = $fileType.Split("=")[-1] 
        cmd /c "ftype $fileType=""$OpenAppPath"" ""%1"""
    }
}

# Privacy
cmd /c copy $env:windir\System32\drivers\etc\hosts+$win10\scripts\hosts $env:windir\System32\drivers\etc\hosts
Invoke-WebRequest "https://wpd.app/get/latest.zip" -Outfile $env:TEMP\wpd.zip
Expand-Archive -Path $env:TEMP\wpd.zip -DestinationPath $env:TEMP\wpd
Start-Process -FilePath $env:TEMP\wpd\WPD.exe -ArgumentList "-recommended -close" -Wait
New-Item -Path $Profile -Type File –Force
mkdir -Path $HOME\Documents\Powershell -Force ; Copy-Item $win10\scripts\Microsoft.PowerShell_profile.ps1 $HOME\Documents\Powershell\
Copy-Item $win10\scripts\Microsoft.PowerShell_profile.ps1 $profile
Invoke-Expression $win10\scripts\Sophia\install.ps1

# Setting up
reg import $HOME\scoop\apps\python\current\install-pep-514.reg
Copy-Item "$win10\scripts\Hotkeys.ahk" "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
start-process -filepath D:\mpv-x86_64-20210404-git-dd86f19\installer\mpv-install.bat -verb runas
start-process -FilePath "$tools\jarfix.exe" -argumentlist "/S" -wait
mkdir $HOME\.config\rclone -Force ; Copy-Item $win10\scripts\rclone.conf $HOME\.config\rclone\rclone.conf -Force
Copy-Item -R "D:\qbitbal\local\qBittorrent" $HOME\AppData\Local\
Copy-Item -R "D:\qbitbal\roaming\qBittorrent" $HOME\AppData\Roaming\
Start-Process -FilePath D:\ADVANCED_64bitCodecs\Launcher64.exe
Start-Process -FilePath $tools\winaerotweaker\SilentSetup.cmd
Add-EnvPath -Path "D:\mpv-x86_64-20210404-git-dd86f19" -Container Machine
Copy-Item -R .\QTfiles64\* "C:\Program Files (x86)\foobar2000\encoders"
cmd /c assoc .py=PythonFile
cmd /c assoc .json=jsonfile
Set-AssociateFileExtensions -FileExtensions .py,.txt,.ps1,.json -OpenAppPath 'C:\Program Files\Notepad++\notepad++.exe'
Start-Process -FilePath $tools\Free_Encoder_Pack-2021-01-26.exe -ArgumentList "/S" -wait
Start-Process -Filepath "$tools\soulseek-2019-7-22.exe" -ArgumentList "/Silent" -wait
Start-Process -FilePath $tools\JDownloader2Setup_win_x64_incl_jre11.exe -argumentlist "-q" -wait
Copy-Item -R $tools\pix\* $HOME\Pictures\ -Force
Copy-Item -R "$tools\copytodocuments\*" $HOME\Documents\ -Force
start-process -filepath "$tools\WFDownloaderApp-BETA-64bit.exe"
mkdir -Force "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Games"
Copy-Item "D:\Games\Project_IGI_RIP\PC\IGI.exe.lnk" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Games\IGI.lnk"
Copy-Item "D:\Games\Max Payne duology\Max Payne\MaxPayne.exe.lnk" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Games\Max Payne.lnk"
Copy-Item "D:\Games\Max Payne duology\Max Payne 2 The Fall of Max Payne\MaxPayne2.exe.lnk" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Games\Max Payne 2.lnk"
Copy-Item "D:\Games\The House of the Dead 2\House of the Dead 2.lnk" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Games\House of the Dead 2.lnk"
reg import "$tools\irc.reg"
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
$restart = Read-Host "Do you want to restart your pc?"
if($restart -eq 'yes'){
   Restart-Computer -Force
   wsl --update
   wsl --set-default-version 2
}else {
  exit
}