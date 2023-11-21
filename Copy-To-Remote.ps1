function Copy-To-Remote {
    <#
        .SYNOPSIS
            Copies a file or directory to a remote computer using scp and ssh.
        .DESCRIPTION
            It compresses the source if it is a directory or if the Compress switch is specified.
        .EXAMPLE
            Copy-To-Remote -Source C:\Temp\MyFile.zip -Destination C:\Temp -RemoteSSH username@MyRemotePC
        .NOTES
            The source will be compressed before copying and deleted after copying.
        .PARAMETER Source
            The source file or directory to copy.
        .PARAMETER Destination
            The destination directory to copy to.
        .PARAMETER RemoteSSH
            The remote user@computer to copy to.
    #>
    [CmdletBinding()]
    param ([Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][ValidateDrive('C')][string]$Source,
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$Destination,
        [string]$RemoteSSH = $env:HOME_PC)

    $ErrorActionPreference = "Stop"
    $Start = [DateTime]::Now
    $TempFile = $null

    # Remove trailing slashes
    $Source = $Source.TrimEnd('/', '\')

    if ($Source -notlike '*.zip') {
        $TempFile = "$([System.IO.Path]::GetTempFileName()).zip"
        Compress-Archive -Path $Source -DestinationPath $TempFile -Verbose -Force
        $Source = $TempFile
    }

    # Add the remote path
    $FullDestination = $([string]::Concat($RemoteSSH, ':/', $Destination))
    Write-Host "Copying $Source to $FullDestination"

    # Copy the file or directory
    scp $Source $FullDestination

    # If the source was a directory or zip file, expand it
    if ($null -ne $TempFile) {
        Remove-Item $TempFile -Verbose -Force -ErrorAction SilentlyContinue
        $FileToExpand = "$Destination$([System.IO.Path]::GetFileName($TempFile))"
        ssh $RemoteSSH Expand-Archive -Path  $FileToExpand -DestinationPath $Destination -Verbose -Force
        ssh $RemoteSSH Remove-Item  $FileToExpand -Verbose -Force -ErrorAction SilentlyContinue
    }

    Write-Host "Copy took $([string]::Format('{0:hh\:mm\:ss}', [DateTime]::Now - $Start))"
}