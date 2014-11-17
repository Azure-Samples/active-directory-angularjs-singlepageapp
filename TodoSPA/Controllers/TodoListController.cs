using System;
using System.Collections.Generic;
using System.Collections.Concurrent;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Security.Claims;
using TodoSPA.DAL;

namespace TodoSPA.Controllers
{

    [Authorize]
    public class TodoListController : ApiController
    {
        private TodoListServiceContext db = new TodoListServiceContext();

        // GET: api/TodoList
        public IEnumerable<Todo> Get()
        {
            string owner = ClaimsPrincipal.Current.FindFirst(ClaimTypes.NameIdentifier).Value;
            IEnumerable<Todo> currentUserToDos = db.Todoes.Where(a => a.Owner == owner);
            return currentUserToDos;
        }

        // GET: api/TodoList/5
        public Todo Get(int id)
        {
            string owner = ClaimsPrincipal.Current.FindFirst(ClaimTypes.NameIdentifier).Value;
            Todo todo = db.Todoes.First(a => a.Owner == owner && a.ID == id);             
            return todo;
        }

        // POST: api/TodoList
        public void Post(Todo todo)
        {
            string owner = ClaimsPrincipal.Current.FindFirst(ClaimTypes.NameIdentifier).Value;            
            todo.Owner = owner;
            db.Todoes.Add(todo);
            db.SaveChanges();            
        }

        public void Put(Todo todo)
        {
            string owner = ClaimsPrincipal.Current.FindFirst(ClaimTypes.NameIdentifier).Value;
            Todo xtodo = db.Todoes.First(a => a.Owner == owner && a.ID == todo.ID);
            if (todo != null)
            {
                xtodo.Description = todo.Description;
                db.SaveChanges();
            }
        }

        // DELETE: api/TodoList/5
        public void Delete(int id)
        {
            string owner = ClaimsPrincipal.Current.FindFirst(ClaimTypes.NameIdentifier).Value;
            Todo todo = db.Todoes.First(a => a.Owner == owner && a.ID == id);
            if (todo != null)
            {
                db.Todoes.Remove(todo);
                db.SaveChanges();
            }
        }        
    }
}
