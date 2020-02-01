#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'WVDToolbox'
$PathToManifest = [System.IO.Path]::Combine('..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
    #if the module is already in memory, remove it
    Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------
$WarningPreference = "SilentlyContinue"
#-------------------------------------------------------------------------
#Import-Module $moduleNamePath -Force

InModuleScope 'WVDToolbox' {
    #-------------------------------------------------------------------------
    $WarningPreference = "SilentlyContinue"
    #-------------------------------------------------------------------------
    Describe 'WVDToolbox Private Function Tests' -Tag Unit {
        Context 'FunctionName' {
            <#
            It 'should ...' {

            }#it
            #>
        }#context_FunctionName
    }#describe_PrivateFunctions
    Describe 'WVDToolbox Public Function Tests' -Tag Unit {
        Context 'FunctionName' {
            <#
                It 'should ...' {

                }#it
                #>
        }#context_FunctionName
    }#describe_testFunctions
    Describe 'New-WVDEnvironment' -Tag Unit {
        Context 'Configuration' {

                It "Adds new environment configuration json file to local profile." {
                    Add-WVDEnvironment -DisplayName "UnitTest" -AzureTenantId "someguid" -SpnApplicationId "applicationid" -SpnSecret $("securestring" |ConvertTo-SecureString -AsPlainText -Force) | Should -Be $true
                }#it

        }#context_FunctionName
    }#describe_testFunctions
}#inModule
