---
services: active-directory
platforms: javascript
author: dstrockis
---

# Integrating Azure AD into an AngularJS single page app

This sample demonstrates the use of ADAL for JavaScript for securing an AngularJS based single page app, implemented with an ASP.NET Web API backend.

ADAL for Javascript is an open source library.  For distribution options, source code, and contributions, check out the ADAL JS repo at https://github.com/AzureAD/azure-activedirectory-library-for-js.

For more information about how the protocols work in this scenario and other scenarios, see [Authentication Scenarios for Azure AD](http://go.microsoft.com/fwlink/?LinkId=394414).

## How To Run This Sample

Getting started is simple!  To run this sample you will need:
- Visual Studio 2013
- An Internet connection
- An Azure subscription (a free trial is sufficient)

Every Azure subscription has an associated Azure Active Directory tenant.  If you don't already have an Azure subscription, you can get a free subscription by signing up at [http://www.windowsazure.com](http://www.windowsazure.com).  All of the Azure AD features used by this sample are available free of charge.

### Step 1:  Clone or download this repository

From your shell or command line:
`git clone https://github.com/Azure-Samples/SinglePageApp-DotNet.git`

### Step 2:  Register the sample with your Azure Active Directory tenant

1. Sign in to the [Azure portal](https://portal.azure.com).
2. On the top bar, click on your account and under the **Directory** list, choose the Active Directory tenant where you wish to register your application.
2. Click on **More Services** in the left hand nav, and choose **Azure Active Directory**.
3. Click on **Registered Applications** and choose **Add**.
4. Enter a friendly name for the application, for example "SinglePageApp-DotNet" and select "Web Application and/or Web API" as the Application Type. For the sign-on URL, enter the base URL for the sample, which is by default `https://localhost:44326/`. Click on **Create** to create the application.

All done!

Before moving on to the next step, you need to find the Application ID of your application.

1. While still in the Azure portal, choose your application, click on **Settings** and choose **Properties**.
2. Find the Application ID value and copy it to the clipboard.


### Step 3:  Enable the OAuth2 implicit grant for your application

By default, applications provisioned in Azure AD are not enabled to use the OAuth2 implicit grant. In order to run this sample, you need to explicitly opt in.

1. From the previous steps, your browser should still be on the Azure portal.
2. From your application page, choose **Manifest** to open the inline manifest editor.
3. Search for the `oauth2AllowImplicitFlow` property. You will find that it is set to `false`; change it to `true` and click on **Save** to save the manifest.

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

**HomeController.js**- shows how to take advantage of the login() and logOut() methods in ADAL.

**UserDataController.js** - shows how to extract user information from the cached id_token.
   
