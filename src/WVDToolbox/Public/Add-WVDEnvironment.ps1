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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
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
            HelpMessage = 'Application ID of the Service Principal Name used for WVD automation.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$SpnApplicationId,

        [Parameter(Mandatory = $false,
            HelpMessage = 'User Password, client secret or certificate thumprint of the Service Principal Name used for WVD automation.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [securestring]$CredentialSecret
    )

    $ApplicationDataFolder = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::ApplicationData);
    $myStorageFolder = ($ApplicationDataFolder | Join-Path -ChildPath "WVDToolbox");
    New-Item -ItemType Directory $myStorageFolder -ErrorAction SilentlyContinue | Out-Null
    $environmentConfigurationFile = "$myStorageFolder`\$($displayName.Replace(' ',''))`.json"
    if ($UserName -like $null -and $SpnApplicationId -notlike $null)
    {
        #Write-Output "Using SPN Authentication for this environment."
        $UserName = $SpnApplicationId
    }
    else
    {
        #Write-Output "Using AAD User Authentcation for this environment."
    }

    try
    {
        $environmentConfiguration = New-Object -TypeName WVDEnvironment -ArgumentList $AzureTenantId,$DisplayName,$DeploymentUrl,(ConvertFrom-SecureString $CredentialSecret),$UserName
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
    WVDEnvironment($AzureTenantId, $DisplayName, $WVDDeploymentUrl, $Secret, $UserName)
    {
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