SinglePageApp-DotNet
====================
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/AzureADSamples/SinglePageApp-DotNet?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This sample demonstrates the use of ADAL for JavaScript for securing an AngularJS based single page app, implemented with an ASP.NET Web API backend.

For more information about how the protocols work in this scenario and other scenarios, see [Authentication Scenarios for Azure AD](http://go.microsoft.com/fwlink/?LinkId=394414).

## How To Run This Sample

Getting started is simple!  To run this sample you will need:
- Visual Studio 2013
- An Internet connection
- An Azure subscription (a free trial is sufficient)

Every Azure subscription has an associated Azure Active Directory tenant.  If you don't already have an Azure subscription, you can get a free subscription by signing up at [http://wwww.windowsazure.com](http://www.windowsazure.com).  All of the Azure AD features used by this sample are available free of charge.

### Step 1:  Clone or download this repository

From your shell or command line:
`git clone https://github.com/AzureADSamples/SinglePageApp-DotNet.git`

### Step 2:  Register the sample with your Azure Active Directory tenant

1. Sign in to the [Azure management portal](https://manage.windowsazure.com).
2. Click on Active Directory in the left hand nav.
3. Click the directory tenant where you wish to register the sample application.
4. Click the Applications tab.
5. In the drawer, click Add.
6. Click "Add an application my organization is developing".
7. Enter a friendly name for the application, for example "SinglePageApp-DotNet", select "Web Application and/or Web API", and click next.
8. For the sign-on URL, enter the base URL for the sample, which is by default `https://localhost:44326/`.
9. For the App ID URI, enter `https://<your_tenant_name>/SinglePageApp-DotNet`, replacing `<your_tenant_name>` with the name of your Azure AD tenant.

All done!  Before moving on to the next step, you need to find the Client ID of your application.

1. While still in the Azure portal, click the Configure tab of your application.
2. Find the Client ID value and copy it to the clipboard.


### Step 3:  Enable the OAuth2 implicit grant preview feature for your application

By default, applications provisioned in Azure AD are not enabled to use the OAuth2 implicit grant. In order to run this sample, you need to explicitly opt in.
In the current developer preview the process unfolds as in the following.

1. From the former steps, your browser should still be on the Azure management portal - and specifically, displaying the Configure tab of your application's entry.
2. Using the Manage Manifest button in the drawer, download the manifest file for the application and save it to disk.
3. Open the manifest file with a text editor. Search for the `oauth2AllowImplicitFlow` property. You will find that it is set to `false`; change it to `true` and save the file.
4. Using the Manage Manifest button, upload the updated manifest file. Save the configuration of the app.

### Step 4:  Configure the sample to use your Azure Active Directory tenant

1. Open the solution in Visual Studio 2013.
2. Open the `web.config` file.
3. Find the app key `ida:Tenant` and replace the value with your AAD tenant name.
4. Find the app key `ida:Audience` and replace the value with the Client ID from the Azure portal.
5. Open the file `App/Scripts/App.js` and locate the line `adalAuthenticationServiceProvider.init(`.
6. Replace the value of `tenant` with your AAD tenant name.
7. Replace the value of `clientId` with the Client ID from the Azure portal.

### Step 5:  Run the sample

Clean the solution, rebuild the solution, and run it. 

You can trigger the sign in experience by either clicking on the sign in link on the top right corner, or by clicking directly on the Todo List tab.
Explore the sample by signing in, adding items to the To Do list, removing the user account, and starting again. 
Notice that you can close and reopen the browser without losing your session. ADAL JS saves tokens in localStorage and keeps them there until you sign out.

## How To Deploy This Sample to Azure

Coming soon.

## About the Code

The key files containing authentication logic are the following:

**App.js** - injects the ADAL module dependency, provides the app configuration values used by ADAL for driving protocol interactions with AAD and indicates whihc routes should not be accessed without previous authentication.
**index.html** - contains a reference to adal.js
**HomeController.js **- shows how to take advantage of the login() and logOut() methods in ADAL.
**UserDataController.js** - shows how to extract user information from the cached id_token.
   
