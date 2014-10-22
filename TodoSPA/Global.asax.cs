using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Routing;
using TodoSPA.DAL;

namespace TodoSPA
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            Database.SetInitializer<TodoListServiceContext>(new TodoListServiceInitializer());
            GlobalConfiguration.Configure(WebApiConfig.Register);
        }
    }
}
