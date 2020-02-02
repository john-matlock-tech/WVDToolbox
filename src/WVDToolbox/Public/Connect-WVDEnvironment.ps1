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
function Connect-WVDEnvironment
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false,
            HelpMessage = 'Environment Display Name.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$DisplayName = "My WVD Environment"
    )

    try
    {
        $environmentConfiguration = Get-WVDEnvironment -DisplayName $DisplayName
        $cred = New-Object -TypeName PSCredential $environmentConfiguration.UserName,(ConvertTo-SecureString $environmentConfiguration.Secret)
        Add-RdsAccount -DeploymentUrl $environmentConfiguration.WVDDeploymentUrl -Credential $cred -ServicePrincipal -AadTenantId $environmentConfiguration.AzureTenantId
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
    [ValidateNotNullOrEmpty()][string]$UserName
    [ValidateNotNullOrEmpty()][string]$Secret

    WVDEnvironment($AzureTenantId, $DisplayName, $WVDDeploymentUrl, $Secret, $UserName)
    {
        $this.AzureTenantId = $AzureTenantId
        $this.WVDDeploymentUrl = $WVDDeploymentUrl
        $this.Secret = $Secret
        $this.UserName = $UserName
        $this.DisplayName = $DisplayName
    }
}