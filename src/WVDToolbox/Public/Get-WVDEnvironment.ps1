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
function Get-WVDEnvironment
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false,
            HelpMessage = 'Enviroment Display Name.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$DisplayName = "My WVD Environment"
    )

    $ApplicationDataFolder = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::ApplicationData);
    $myStorageFolder = ($ApplicationDataFolder | Join-Path -ChildPath "WVDToolbox");
    $environmentConfigurationFile = "$myStorageFolder`\$($displayName.Replace(' ',''))`.json"

    try
    {
        Get-Content $environmentConfigurationFile -Encoding UTF8 -Raw -ErrorAction Stop | ConvertFrom-Json
    }
    catch
    {
        $false
    }
}#Get-WVDEnvironment
