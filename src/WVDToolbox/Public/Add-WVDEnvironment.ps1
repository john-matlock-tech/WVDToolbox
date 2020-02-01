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
            HelpMessage = 'Enviroment Display Name.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$DisplayName = "My WVD Environment",

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
        [securestring]$SpnSecret
    )

    $result = $false

    $ApplicationDataFolder = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::ApplicationData);
    $myStorageFolder = ($ApplicationDataFolder | Join-Path -ChildPath "WVDToolbox");
    New-Item -ItemType Directory $myStorageFolder -ErrorAction SilentlyContinue | Out-Null
    $environmentConfigurationFile = "$myStorageFolder`\$($displayName.Replace(' ',''))`.json"
    $environmentConfiguration = New-Object -TypeName WVDEnvironment
    $environmentConfiguration.DisplayName = $DisplayName
    $environmentConfiguration.AzureTenantId = $AzureTenantId
    $environmentConfiguration.WVDDeploymentUrl = $DeploymentUrl
    $environmentConfiguration.Secret = ConvertFrom-SecureString $SpnSecret
    $environmentConfiguration.UserName = $UserName

    try
    {
        $environmentConfiguration | ConvertTo-Json | Set-Content $environmentConfigurationFile -Encoding UTF8 -ErrorAction Stop
        Test-Path $environmentConfigurationFile
    }
    catch
    {
        $false
    }
}#Add-WVDEnvironment

class WVDEnvironment
{
    [ValidateNotNullOrEmpty()][string]$AzureTenantId
    [ValidateNotNullOrEmpty()][string]$DisplayName
    [ValidateNotNullOrEmpty()][string]$WVDDeploymentUrl
    [string]$UserName
    [ValidateNotNullOrEmpty()][string]$Secret

    WVDEnvironment($AzureTenantId, $DisplayName, $WVDDeploymentUrl, $Secret, $UserName) {
       $this.AzureTenantId = $AzureTenantId
       $this.WVDDeploymentUrl = $WVDDeploymentUrl
       $this.Secret = $Secret
       $this.UserName = $UserName
       $this.DisplayName = $DisplayName
    }

    WVDEnvironment()
    {
    }
}