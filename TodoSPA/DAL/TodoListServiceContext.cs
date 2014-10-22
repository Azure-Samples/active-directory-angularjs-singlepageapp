using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;
using System.Linq;
using System.Web;
using TodoSPA.Controllers;

namespace TodoSPA.DAL
{
    public class TodoListServiceContext: DbContext
    {
        public TodoListServiceContext()
            : base("TodoListServiceContext")
        { }
        public DbSet<Todo> Todoes { get; set; }
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
    }
}