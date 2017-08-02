# Variables for the registration of the AAD applications

# Registeration for the SinglePageApp-DotNet JavaScript app
# ---------------------------------------------
	# friendly name for the application, for example 'SinglePageApp-DotNet' 
	# Apllication Type is 'Web app / API' (that is private application). 
	# For the redirect URL, this is https://localhost:44326/
	# App ID URI, is https://<your_tenant_name>/SinglePageApp-DotNet
	$spaName = "SinglePageApp-DotNet"
	$spaIsPublicClient = $false
	$spaRedirectUri= "https://localhost:44326/"
	$spaAppIdURI = "https://$tenantName/$todoListSPAClientName"
