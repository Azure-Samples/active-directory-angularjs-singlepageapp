# This script creates the Azure AD applications needed for this sample and updates the configuration files
# for the visual Studio projects from the data in the Azure AD applications.
#
# Before running this script you need to install the AzureAD cmdlets as an administrator. 
# For this:
# 1) Run Powershell as an administrator
# 2) in the PowerShell window, type: Install-Module AzureAD
#
# Before you run this script
# 3) With the Azure portal (https://portal.azure.com), choose your active directory tenant, then go to the Properties of the tenant and copy
#    the DirectoryID. This is what we'll use in this script for the tenant ID
# 
# To configurate the applications
# 4) Run the following command:
#      $apps = ConfigureApplications -tenantId [place here the GUID representing the tenant ID]
#    You will be prompted by credentials, be sure to enter credentials for a user who can create applications
#    in the tenant
#
# To execute the samples
# 5) Build and execute the applications. This just works
#
# To cleanup
# 6) Optionnaly if you want to cleanup the applications in the Azure AD, run:
#      CleanUp $apps
#    The applications are un-registered
param([PSCredential]$Credential="", [string]$TenantId="")
Import-Module AzureAD
$ErrorActionPreference = 'Stop'

# Replace the value of an appsettings of a given key in an XML App.Config file.
Function ReplaceSetting([string] $configFilePath, [string] $key, [string] $newValue)
{
    [xml] $content = Get-Content $configFilePath
    $appSettings = $content.configuration.appSettings; 
    $keyValuePair = $appSettings.SelectSingleNode("descendant::add[@key='$key']")
    if ($keyValuePair)
    {
        $keyValuePair.value = $newValue;
    }
    else
    {
        Throw "Key '$key' not found in file '$configFilePath'"
    }
   $content.save($configFilePath)
}

# Updates the config file for a client application
Function UpdateTodoListServiceConfigFile([string] $configFilePath, [string] $tenantId, [string] $clientId, [string] $appKey, [string] $audience)
{
    ReplaceSetting -configFilePath $configFilePath -key "ida:Tenant" -newValue $tenantId
    ReplaceSetting -configFilePath $configFilePath -key "ida:Audience" -newValue $audience
}

Function UpdateLine([string] $line, [string] $value)
{
	$index = $line.IndexOf(':')
	if ($index -ige 0)
	{
		$line = $line.Substring(0, $index+1) + " """+$value + ""","
	}
	return $line
}

Function UpdateTodoListSPAClientConfig([string] $configFilePath, [string] $tenantId, [string] $clientId)
{
	$lines = Get-Content $configFilePath
	$index = 0
	while($index -lt $lines.Length)
	{
		$line = $lines[$index]
		if ($line.Contains("tenant:"))
		{
			$lines[$index] = UpdateLine $line $tenantId
		}
		if ($line.Contains("clientId:"))
		{
			$lines[$index] = UpdateLine $line $clientId
		}
		$index++
	}
	
	Set-Content -Path $configFilePath -Value $lines -Force
}


Function ConfigureApplications
{
<#
.Description
This function creates the Azure AD applications for the sample in the provided Azure AD tenant and updates the
configuration files in the client and service project  of the visual studio solution (App.Config and Web.Config)
so that they are consistent with the Applications parameters
#>
    [CmdletBinding()]
    param(
        [PSCredential] $Credential,
        [Parameter(HelpMessage='Tenant ID (This is a GUID which represents the "Directory ID" of the AzureAD tenant into which you want to create the apps')]
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
        $creds = Connect-AzureAD -TenantId $tenantId
    }
    else
    {
        if (!$TenantId)
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

	# Create the SPA Active Directory Application and it's service principal 
    Write-Host "Creating the AAD appplication ($spaName)"
    $spaClientAadApplication = New-AzureADApplication -DisplayName $spaName `
											 -Homepage $spaRedirectUri `
                                             -ReplyUrls $spaRedirectUri `
                                             -PublicClient $spaIsPublicClient `
	                                         -IdentifierUris $spaAppIdURI `
											 -Oauth2AllowImplicitFlow $true
	$spaClientServicePrincipal = New-AzureADServicePrincipal -AppId $spaClientAadApplication.AppId
	Write-Host "Created."

    # Update the config files in the application
    $configFile = $pwd.Path + "\..\TodoSPA\Web.Config"
    Write-Host "Updating the sample code ($configFile)"
    UpdateTodoListServiceConfigFile -configFilePath $configFile `
                            -tenantId $tenantName `
                            -audience $spaClientAadApplication.AppId

    $configFile = $pwd.Path + "\..\TodoSPA\App\Scripts\app.js"
    Write-Host "Updating the sample code ($configFile)"
	UpdateTodoListSPAClientConfig -configFilePath $configFile `
								  -tenantId $tenantName `
								  -clientId $spaClientAadApplication.AppId
	   
    # Completes
    Write-Host "Done."
   }
}

# Run interactively (will ask you for the tenant ID)
ConfigureApplications -Credential $Credential -tenantId $TenantId


# you can also provide the tenant ID and the credentials
# $tenantId = "ID of your AAD directory"
# $apps = ConfigureApplications -tenantId $tenantId 


# When you have built your Visual Studio solution and ran the code, if you want to clean up the Azure AD applications, just 
# run the following command in the same PowerShell window as you ran ConfigureApplications
# . .\CleanUp -Credentials $Credentials