Function Convert-Audio{
    [CmdletBinding()]
    Param(  [Parameter(Mandatory=$True,Position=1)] [string]$path,
            [string]$Source = '.flac', #The source or input file format
            $rate = '320k', #The encoding bit rate
            $DeleteOriginal)

$results = @()
#This script was derived from Scott Wood's post at this site http://blog.abstractlabs.net/2013/01/batch-converting-wma-or-wav-to-mp3.html
#Thanks Scott.
Get-ChildItem -Path:$path -Include:"*$Source" -Recurse | ForEach-Object -Process: {
        $file = $_.Name.Replace($_.Extension,'.mp3')
        $input = $_.FullName
        $output = $_.DirectoryName
        $output = "$output\$file"
#-i Input file path
#-id3v2_version Force id3 version so windows can see id3 tags
#-f Format is MP3
#-ab Bit rate
#-ar Frequency
# Output file path
#-y Overwrite the destination file without confirmation
        $arguments = "-i `"$input`" -id3v2_version 3 -f mp3 -ab $rate -ar 44100 `"$output`" -y"
        $ffmpeg = "ffmpeg"
       
        #Hide the output
        $Status = Invoke-Expression "$ffmpeg $arguments 2>&1"
        $t = $Status[$Status.Length-2].ToString() + " " + $Status[$Status.Length-1].ToString()
        $results += $t.Replace("`n","")
       
        #Delete the old file when finished if so requested
        if($DeleteOriginal -and $t.Replace("`n","").contains("%")) {
            Remove-Item -Path:$_
        }
    }
    if ($results) {
        return $results
    }
    else {
        return "No file found"
    }
}

function Convert-Opus {
	fd -e flac --exec opusenc --bitrate 256 "{}" "{.}.opus"
}

function rps {
	rclone -vP copy $HOME\Documents\ShareX\Screenshots photos:album
}

$amv = "D:\Anime Music Videos"

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

function Remove-EnvPath {
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
        if ($persistedPaths -contains $Path) {
            $persistedPaths = $persistedPaths | Where-Object { $_ -and $_ -ne $Path }
            [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
        }
    }

    $envPaths = $env:Path -split ';'
    if ($envPaths -contains $Path) {
        $envPaths = $envPaths | Where-Object { $_ -and $_ -ne $Path }
        $env:Path = $envPaths -join ';'
    }
}

function Get-EnvPath {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('Machine', 'User')]
        [string] $Container
    )

    $containerMapping = @{
        Machine = [EnvironmentVariableTarget]::Machine
        User = [EnvironmentVariableTarget]::User
    }
    $containerType = $containerMapping[$Container]

    [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';' |
        Where-Object { $_ }
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