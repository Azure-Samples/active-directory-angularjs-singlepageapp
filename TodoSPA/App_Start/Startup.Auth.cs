using System;
using System.Threading.Tasks;
using Microsoft.Owin;
using Owin;
using Microsoft.Owin.Security.ActiveDirectory;
using System.Configuration;

namespace TodoSPA
{
    public partial class Startup
    {
        public void ConfigureAuth(IAppBuilder app)
        {
            app.UseWindowsAzureActiveDirectoryBearerAuthentication(
                new WindowsAzureActiveDirectoryBearerAuthenticationOptions
                {
                    Audience = ConfigurationManager.AppSettings["ida:Audience"],
                    //Tenant = ConfigurationManager.AppSettings["ida:Tenant"],
                    MetadataAddress = "https://login.windows-ppe.net/52d4b072-9470-49fb-8721-bc3a1c9912a1/federationmetadata/2007-06/federationmetadata.xml"
                });
        }

    }
}
