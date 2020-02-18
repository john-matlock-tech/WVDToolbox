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
function New-AzureSnapshot
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Resource Group Name.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Azure Location name.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$AzureLocation = 'EastUS',

        [Parameter(Mandatory = $true,
            HelpMessage = 'Name of the VM to create snapshot from.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$VMName,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Name for the new snapshot.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$SnapshotName
    )

    try
    {
        $vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -ErrorAction Stop
    }
    catch
    {
        Write-Error "Failed to look up VM by name $VMName in ResourceGroup $ResourceGroupName`. $($_.Exception.Message.ToString())"
    }

    if ($null -notlike $vm)
    {
        try
        {
            $snapshotConfig =  New-AzSnapshotConfig -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id -Location $AzureLocation -CreateOption copy

            New-AzSnapshot -Snapshot $snapshotConfig -SnapshotName $SnapshotName -ResourceGroupName $resourceGroupName
        }
        catch
        {
            Write-Error "Failed to create snapshot from disk $($vm.StorageProfile.OsDisk.ManagedDisk.Id) from $VMName in ResourceGroup $ResourceGroupName`. $($_.Exception.Message.ToString())"
        }
    }
}

Function New-WVDImagingVM
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [Switch]
        $FromSnapshot,

        [Parameter()]
        [Switch]
        $FromGallery
    )


}

Function New-WVDImagingVMFromSnapshot
{

}

Function New-WVDImagingVMFromGallery
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Resource Group Name.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Azure Location name.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$AzureLocation = 'EastUS',

        [Parameter(Mandatory = $true,
            HelpMessage = 'Name of the new VM.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$VMName,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Name of the Virtual Network.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$VNetName,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Name of the subnet.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$SubnetName,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Security Group name.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$SecurityGroupName,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Local administrator account for imaging.')]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [PSCredential]
        $VMCreds,

        [Parameter()]
        [string]
        $Publisher = "MicrosoftWindowsDesktop",

        [Parameter()]
        [string]
        $Offer = "windows-10",

        [Parameter()]
        [string]
        $Sku = "19h2-evd"
    )

    $vmConfig = New-AzVMConfig -VMName $VMName -VMSize Standard_D1 | `
    Set-AzVMOperatingSystem -Windows -ComputerName $VMName -Credential $VMCreds | `
    Set-AzVMSourceImage -PublisherName $Publisher -Offer $Offer -Skus $sku -Version latest

    New-AzVm -ResourceGroupName $ResourceGroupName -VM $vmConfig -Location $AzureLocation -VirtualNetworkName $VNetName `
    -SubnetName $SubnetName -SecurityGroupName $SecurityGroupName
}