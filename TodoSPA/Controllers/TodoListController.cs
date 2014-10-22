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
    //[Authorize]
    //public class TodoListController : ApiController
    //{
    //    private static List<Todo> todos = new List<Todo>();

    //    // GET: api/TodoList
    //    public IEnumerable<Todo> Get()
    //    {
    //        //todos.Add(new Todo { Description = "aa", ID = 1, Owner = "mario" });
    //        //todos.Add(new Todo { Description = "bb", ID = 2, Owner = "luigi" });
    //        string owner = ClaimsPrincipal.Current.FindFirst(ClaimTypes.NameIdentifier).Value;
    //        return todos;
            
    //        //IEnumerable<Todo> currentUserToDos = todos.Where(a => a.Owner == owner);
    //        //return currentUserToDos;
    //    }

    //    // GET: api/TodoList/5
    //    public Todo Get(int id)
    //    {
    //        //string owner = ClaimsPrincipal.Current.FindFirst(ClaimTypes.NameIdentifier).Value;
    //        //Todo todo = todos.First(a => a.Owner == owner && a.ID == id); 
    //        Todo todo = todos.First(a => a.ID == id); 
           
    //        return todo;
    //    }

    //    // POST: api/TodoList
    //    public void Post(Todo todo)
    //    {
    //        //string owner = ClaimsPrincipal.Current.FindFirst(ClaimTypes.NameIdentifier).Value;
    //        //todo.Owner = owner;
    //        lock (todos)
    //        {
    //            todo.ID = new Random().Next(10000000);
    //            todos.Add(todo);
    //        }
    //    }

    //    public void Put(Todo todo)
    //    {
    //        Todo xtodo = todos.First(a => a.ID == todo.ID);
    //        if (todo != null)
    //        {
    //            todos.Remove(xtodo);
    //            todos.Add(todo);
    //        }
    //    }

    //    // DELETE: api/TodoList/5
    //    public void Delete(int id)
    //    {
    //        //string owner = ClaimsPrincipal.Current.FindFirst(ClaimTypes.NameIdentifier).Value;
    //        lock (todos)
    //        {                
    //            //Todo todo = todos.First(a => a.Owner == owner && a.ID == id);
    //            Todo todo = todos.First(a => a.ID == id);
    //            if (todo != null)
    //            {
    //                todos.Remove(todo);
    //            }
    //        }
    //    }
    //}

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
