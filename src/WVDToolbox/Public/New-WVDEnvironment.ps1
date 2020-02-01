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
function Add-WVDEnvironment
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false,
            HelpMessage = 'WVD Deployment URL.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$DeploymentUrl = "https://rdbroker.wvd.microsoft.com",

        [Parameter(Mandatory = $false,
            HelpMessage = 'Azure Tenant ID, should be in string GUID format.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$AzureTenantId,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Azure Tenant ID, should be in string GUID format.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$UserName,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Application ID of the Service Principal Name used for WVD automation.',
            ParameterSetName = 'SPN')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$SpnApplicationId,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Client secret or Certificate thumprint of the Service Principal Name used for WVD automation.',
            ParameterSetName = 'SPN')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$SpnSecret
    )

    $result = $false

    return $result
}#Initialize-WVDToolbox
