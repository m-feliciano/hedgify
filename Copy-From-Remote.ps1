function Copy-From-Remote {
    <#
        .SYNOPSIS
            Copies a file or directory from a remote computer using scp and ssh.
        .DESCRIPTION
            It expands the source if it is a zip file or if the Expand switch is specified.
        .EXAMPLE
            Copy-From-Remote -Source C:\Temp\MyFile.zip -Destination C:\Temp -Server username@MyRemotePC
        .NOTES
            The source will be compressed before copying and deleted after copying.
        .PARAMETER Source
            The source file or directory to copy.
        .PARAMETER Destination
            The destination directory to copy to.
        .PARAMETER Server
            The remote user@computer to copy to.
    #>
    [CmdletBinding()]
    param ([Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][string]$Source,
            [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][ValidateDrive('C')][string]$Destination,
            [string]$Server = $env:HOME_PC)

    $ErrorActionPreference = "Stop"
    $Start = [DateTime]::Now
    $TempFile = $null
    $TempFileName = $null

    # If the source is a directory, zip it up
    if ($Source -notlike '*.zip') {
        $TempFileName = "$([System.IO.Path]::GetRandomFileName()).zip"
        $TempFile = "$([System.IO.Path]::GetDirectoryName($Source))\$TempFileName"
        Write-Host "Creating the temp path: $TempFile on $Server"
        ssh $Server Compress-Archive -Path $Source -DestinationPath $TempFile -Verbose -Force
        $Source = $TempFile
    }


    $Source = $Source.Replace('\', '/')
    $Destination = $Destination.Replace('\', '/')
    # add a slash to the end of the destination if it doesn't have one
    $Destination = $Destination.TrimEnd('/') + '/'

    # Add the remote path
    $FullSource = $([string]::Concat($Server, ':/', $Source))

    Write-Host "Copying $FullSource to $Destination"

    # Copy the file or directory
    scp $FullSource $Destination

    # If the source was a directory or zip file, expand it
    if ($null -ne $TempFile) {
        ssh $Server Remove-Item $TempFile -Verbose -Force -ErrorAction SilentlyContinue
        $fileToExpand = "$Destination\$TempFileName"
        Expand-Archive -Path $fileToExpand -DestinationPath $Destination -Verbose -Force
        Remove-Item $fileToExpand -Verbose -Force -ErrorAction SilentlyContinue
    }

    Write-Host "Copy took $([string]::Format('{0:hh\:mm\:ss}', [DateTime]::Now - $Start))"
}
