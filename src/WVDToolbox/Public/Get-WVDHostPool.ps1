<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    C:\PS>
    Example of how to use this cmdlet
.EXAMPLE
    C:\PS>
    Another example of how to use this cmdlet
.PARAMETER InputObject
    Specifies the object to be processed.  You can also pipe the objects to this command.
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    WVDToolbox
#>
function Get-WVDHostPool
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Environment name.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$Environment,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Host Pool name.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

    $hostPoolConfigurationFile = "$($Script:moduleRoot)`\$($Environment.Replace(' ',''))_$($Name.Replace(' ',''))`.json"

    try
    {
        Get-Content $hostPoolConfigurationFile -Encoding UTF8 -Raw -ErrorAction Stop | ConvertFrom-Json
    }
    catch
    {
        Write-Error $_
        $false
    }
}#Get-WVDHostPool
