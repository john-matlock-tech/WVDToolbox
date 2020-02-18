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
function Register-WVDHostPool
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Environment Display Name.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$Environment,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Host Pool Name.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Select the image source type for the session host VMs.  Only CustomImage supported today.')]
        [ValidateSet("CustomImage")]
        [string]$ImageSource = "CustomImage",

        [Parameter(Mandatory = $true,
            HelpMessage = 'Name of the image to use as a source for the host VMs.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$ImageSourceName,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Name of the resource group the image is in.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$ImageResourceGroup,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Azure VM size for host VMs.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$HostSize = 'Standard_D4s_v3',

        [Parameter(Mandatory = $true,
            HelpMessage = 'Prefix for new names for WVD Hosts.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
         [string]$HostNamePrefix,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Number of host VMs in the host pool.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [int]$HostCount = 1,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Domain for the VM Hosts to join, in FQDN format.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$DomainToJoin,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Domain Join Credentials username in distinguished name format.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$DomainJoinUserDN,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Domain Join Credentials password.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [securestring]$DomainJoinPassword,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Specifiy an organizational unit (OU) to place the new virtual machines when joining the domain. Example OU: OU=testOU,DC=domain,DC=Domain,DC=com')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$HostParentOU,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Name of the VNET the virtual hosts will connect to.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$VNetName,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Name of the Resource group to create WVD hosts in.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroup,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Name of the VNET resource group.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$VNETResourceGroup,

        [Parameter(Mandatory = $true,
            HelpMessage = 'The subnet the VMs will be placed in.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$SubnetName,

        [Parameter(Mandatory = $true,
            HelpMessage = 'The name of the WVD Tenant to deploy to.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$WVDTenant,

        [Parameter(Mandatory = $false,
            HelpMessage = 'The name of the WVD Tenant Group to deploy to.  Defaults to: Default Tenant Group')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$WVDTenantGroupName = 'Default Tenant Group',

        [bool] $EnablePersistentDesktop = $false
    )

    New-Item -ItemType Directory $Script:moduleRoot -ErrorAction SilentlyContinue | Out-Null
    $hostPoolConfigurationFile = "$($Script:moduleRoot)`\$($Environment.Replace(' ',''))_$($Name.Replace(' ',''))`.json"

    try
    {
        $hostPoolConfiguration = "" | Select-Object Name, Environment, ImageSource, ImageSourceName, HostSize, HostCount, `
        DomainToJoin, DomainJoinUsername, DomainJoinPassword, HostParentOU, VNetName, VNETResourceGroup, SubnetName, WVDTenant, `
        WVDTenantGroupName, EnablePersistentDesktop, ResourceGroup, ImageResourceGroup

        $hostPoolConfiguration.Name = $Name
        $hostPoolConfiguration.Environment = $Environment
        $hostPoolConfiguration.ImageSource = $ImageSource
        $hostPoolConfiguration.ImageSourceName = $ImageSourceName
        $hostPoolConfiguration.ImageResourceGroup = $ImageResourceGroup
        $hostPoolConfiguration.HostSize = $HostSize
        $hostPoolConfiguration.HostCount = $HostCount
        $hostPoolConfiguration.DomainToJoin = $DomainToJoin
        $hostPoolConfiguration.DomainJoinUsername = $DomainJoinUserDN
        $hostPoolConfiguration.DomainJoinPassword = $DomainJoinPassword | ConvertFrom-SecureString
        $hostPoolConfiguration.HostParentOU = $HostParentOU
        $hostPoolConfiguration.VNetName = $VNetName
        $hostPoolConfiguration.VNetResourceGroup = $VNETResourceGroup
        $hostPoolConfiguration.SubnetName = $SubnetName
        $hostPoolConfiguration.WVDTenant = $WVDTenant
        $hostPoolConfiguration.WVDTenantGroupName = $WVDTenantGroupName
        $hostPoolConfiguration.EnablePersistentDesktop = $EnablePersistentDesktop
        $hostPoolConfiguration.ResourceGroup = $ResourceGroup

        $hostPoolConfiguration | ConvertTo-Json | Set-Content $hostPoolConfigurationFile -Encoding UTF8 -ErrorAction Stop
        Test-Path $hostPoolConfigurationFile
    }
    catch
    {
        Write-Error $_
        $false
    }
}#Add-WVDEnvironment
