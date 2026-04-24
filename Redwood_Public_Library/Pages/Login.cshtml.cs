using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;
using System.Diagnostics.Eventing.Reader;

namespace Redwood_Public_Library.Pages
{
    public class LoginModel : PageModel
    {
        [BindProperty]
        public string Username { get; set; }

        [BindProperty]
        public string Password { get; set; }

        [BindProperty]
        public bool IsStaff { get; set; }

        public string Message { get; set; }

        public void OnGet()
        {

        }

        public void OnPost()
        {
            if (string.IsNullOrWhiteSpace(Username) || string.IsNullOrWhiteSpace(Password))
            {
                Message = "Please enter both username and password.";
                return;
            }

            var role = IsStaff ? "Staff" : "User";
            Message = $"Login submitted for {Username} as {role}.";

            
        }
    }

    public class User
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Role { get; set; }
    }
}