function Find-History(
    <#
        .SYNOPSIS
            Finds a command in the history.
        .DESCRIPTION
            Finds a command in the history.
        .EXAMPLE
            Find-History -Pattern 'Get-ChildItem*'
        .NOTES
            The default limit is 10.
        .PARAMETER Name
            The name of the command to find.
        .PARAMETER Limit
            The number of lines to return.
    #>
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()][string] $Pattern,
    [Int32] $Limit = 10) {
    Get-Content (Get-PSReadlineOption).HistorySavePath `
    | Where-Object { $_ -like $name } `
    | Select-Object -Last $Limit
}