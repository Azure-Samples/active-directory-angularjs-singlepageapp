param([PSCredential]$Credential, [string]$TenantId)
Import-Module AzureAD
$ErrorActionPreference = 'Stop'

Function RemoveUser([string]$alias)
{
    $userPrincipal = "$appName-$alias@$tenantName"
    $user = Get-AzureADUser -Filter "UserPrincipalName eq '$userPrincipal'"
    if ($user)
    {
        Write-Host "Removing User '($userPrincipal)'"
        Remove-AzureADUser -ObjectId $user.ObjectId
    }
}

Function Cleanup
{
<#
.Description
This function removes the Azure AD applications for the sample. These applications were created by the Configure.ps1 script
#>
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage='Tenant ID (This is a GUID which represents the "Directory ID" of the AzureAD tenant into which you want to create the apps')]
        [PSCredential] $Credential,
        [string] $tenantId
    )

   process
   {
    # $tenantId is the Active Directory Tenant. This is a GUID which represents the "Directory ID" of the AzureAD tenant 
    # into which you want to create the apps. Look it up in the Azure portal in the "Properties" of the Azure AD. 

    # Login to Azure PowerShell (interactive if credentials are not already provided: 
    # you'll need to sign-in with creds enabling your to create apps in the tenant)
    if (!$Credential)
    {
        if (!$tenantId)
        {
            $creds = Connect-AzureAD
        }
        else
        {
          $creds = Connect-AzureAD -TenantId $tenantId
        }

    }
    else
    {
        if (!$tenantId)
        {
            $creds = Connect-AzureAD -Credential $Credential
        }
        else
        {
            $creds = Connect-AzureAD -TenantId $tenantId -Credential $Credential
        }
    }

    if (!$tenantId)
    {
        $tenantId = $creds.Tenant.Id
    }
    $tenant = Get-AzureADTenantDetail
    $tenantName =  $tenant.VerifiedDomains[0].Name

    . .\Config.ps1

    # Removes the applications
    Write-Host "Removing Applications"	
	$app=Get-AzureADApplication -Filter "DisplayName eq '$spaName'"  
    if ($app)
    {
        Write-Host "Removing Application '$spaName'"
        Remove-AzureADApplication -ObjectId $app.ObjectId
    }

    Write-Host "Done."
   }
}

Cleanup -Credential $Credential -tenantId $TenantId
