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
function Publish-WVDHostPool
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
        [string]$Name,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Indicates that the update template should be used.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [switch]$Update
    )


    $config = Get-WVDHostPool -environment $Environment -Name $Name
    $envConf = Get-WVDEnvironment $Environment
    Connect-AzAccount
    Connect-WVDEnvironment -DisplayName $Environment



    if ($Update -like $false)
    {
        $paramObject = @{
            'rdshImageSource' = $config.ImageSource
            'rdshCustomImageSourceName'  = $config.ImageSourceName
            'rdshCustomImageSourceResourceGroup' = $config.ImageResourceGroup
            'rdshNamePrefix' = $config.HostNamePrefix
            'rdshNumberOfInstances' = $config.HostCount
            'rdshVMDiskType' = 'Premium_LRS'
            'rdshVmSize' = $config.HostSize
            'domainToJoin' = $config.DomainToJoin
            'existingDomainUPN' = $config.DomainJoinUsername
            'existingDomainPassword' = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR(($config.DomainJoinPassword | ConvertTo-SecureString)))
            'ouPath' = $config.HostParentOU
            'existingVnetName' = $config.VNetName
            'newOrExistingVnet' = 'existing'
            'existingSubnetName' = $config.SubnetName
            'virtualNetworkResourceGroupName' = $config.VNETResourceGroup
            'existingTenantGroupName' = $config.WVDTenantGroupName
            'existingTenantName' = $config.WVDTenant
            'hostPoolName' = $config.Name
            'enablePersistentDesktop' = $config.EnablePersistentDesktop
            'tenantAdminUpnOrApplicationId' = $envConf.UserName
            'tenantAdminPassword' = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR(($envConf.Secret | ConvertTo-SecureString)))
            'isServicePrincipal' = $true
            'aadTenantId' = $envConf.AzureTenantId
            'location' = 'westus2'
        }
        $params = @{
            'ResourceGroupName' = $config.ResourceGroup
            'TemplateFile' = "$PSScriptRoot\..\Private\WVD\DeployHostPoolTemplate.json"
            'TemplateParameterObject'    = $paramObject
        }
    }
    else
    {
        $paramObject = @{
            'rdshImageSource' = $config.ImageSource
            'rdshCustomImageSourceName'  = $config.ImageSourceName
            'rdshCustomImageSourceResourceGroup' = $config.ImageResourceGroup
            'rdshNamePrefix' = $config.HostNamePrefix
            'rdshNumberOfInstances' = $config.HostCount
            'rdshVMDiskType' = 'Premium_LRS'
            'rdshVmSize' = $config.HostSize
            'domainToJoin' = $config.DomainToJoin
            'existingDomainUPN' = $config.DomainJoinUsername
            'existingDomainPassword' = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR(($config.DomainJoinPassword | ConvertTo-SecureString)))
            'ouPath' = $config.HostParentOU
            'existingVnetName' = $config.VNetName
            'newOrExistingVnet' = 'existing'
            'existingSubnetName' = $config.SubnetName
            'virtualNetworkResourceGroupName' = $config.VNETResourceGroup
            'existingTenantGroupName' = $config.WVDTenantGroupName
            'existingTenantName' = $config.WVDTenant
            'existingHostPoolName' = $config.Name
            'enablePersistentDesktop' = $config.EnablePersistentDesktop
            'tenantAdminUpnOrApplicationId' = $envConf.UserName
            'tenantAdminPassword' = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR(($envConf.Secret | ConvertTo-SecureString)))
            'isServicePrincipal' = $true
            'aadTenantId' = $envConf.AzureTenantId
            'location' = 'westus2'
            'userLogoffDelayInMinutes' = 0
            'userNotificationMessage' = 'Scheduled maintenance, please save your work and logoff as soon as possible'
        }

        $params = @{
            'ResourceGroupName' = $config.ResourceGroup
            'TemplateFile' = "$PSScriptRoot\..\Private\WVD\UpdateHostPoolTemplate.json"
            'TemplateParameterObject'    = $paramObject
        }
    }

        New-AzResourceGroupDeployment @params -verbose
}