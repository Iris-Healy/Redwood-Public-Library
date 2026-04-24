using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;
using System.Security.Claims;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;

namespace Redwood_Public_Library.Pages
{
    public class LoginModel : PageModel
    {
        [BindProperty]
        public string Username { get; set; } = string.Empty;

        [BindProperty]
        public string Password { get; set; } = string.Empty;

        private UserLogin? UserToLogin { get; set; }

        private AppUser UserInfo { get; set; } = new AppUser();

        [BindProperty]
        public bool IsStaff { get; set; }

        public string Message { get; set; } = string.Empty;

        public void OnGet()
        {

        }

        public async Task<IActionResult> OnPost()
        {
            if (string.IsNullOrWhiteSpace(Username) || string.IsNullOrWhiteSpace(Password))
            {
                Message = "Please enter both username and password.";
                return Page();
            }

            var role = IsStaff ? "Librarian" : "Member";
            Message = $"Login submitted for {Username} as {role}.";

            if (IsStaff)
            {
                StaffLoginPull(Username);
                if (UserToLogin != null && UserToLogin.Password == Password)
                {
                    StaffUserInfoPull(Username);
                    // Create a list of claims to represent the authenticated user's identity and permissions
                    var claims = new List<Claim>
                    {
                        // Claim for the user's name, used for displaying the user's identity
                        new Claim(ClaimTypes.Name, Username),
                        // Claim for the user's role (e.g., Member, Librarian, or Admin), used for authorization
                        new Claim(ClaimTypes.Role, UserInfo.Role)
                    };
                    // Create a ClaimsIdentity with the claims, using the cookie authentication scheme
                    var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                    // Sign in the user by creating a ClaimsPrincipal and storing it in the HttpContext
                    // This establishes the user's authenticated session
                    await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(identity));
                    Message = $"Welcome, {UserInfo.Name}! You have successfully logged in as {UserInfo.Role}.";
                    return RedirectToPage("/Index");
                }
                else
                {
                    Message = "Invalid staff username or password.";
                    return Page();
                }
            }
            else
            {
                MemberLoginPull(Username);
                if (UserToLogin != null && UserToLogin.Password == Password)
                {
                    MemberUserInfoPull(Username);
                    // Create a list of claims to represent the authenticated user's identity and permissions
                    var claims = new List<Claim>
                    {
                        // Claim for the user's name, used for displaying the user's identity
                        new Claim(ClaimTypes.Name, Username),
                        // Claim for the user's role (e.g., Member, Librarian, or Admin), used for authorization
                        new Claim(ClaimTypes.Role, UserInfo.Role)
                    };
                    // Create a ClaimsIdentity with the claims, using the cookie authentication scheme
                    var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                    // Sign in the user by creating a ClaimsPrincipal and storing it in the HttpContext
                    // This establishes the user's authenticated session
                    await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, new ClaimsPrincipal(identity));
                    Message = $"Welcome, {UserInfo.Name}! You have successfully logged in as {UserInfo.Role}.";
                    return RedirectToPage("/Index");
                }
                else
                {
                    Message = "Invalid member username or password.";
                    return Page();
                }
            }
        }
        public void MemberLoginPull(string username)
        {
            UserToLogin = new UserLogin();

            string connectionString = "Server=localhost;Database=Redwood_Public_Library;User Id=sa;Password=P@ssw0rd;TrustServerCertificate=True;";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                //Sql Query retrieving book information based on selected author
                string sql = @"SELECT ml.M_Username, ml.M_Password
                               FROM Member_Logins ml
                               WHERE ml.M_Username = @Username;";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    command.Parameters.AddWithValue("@Username", username);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            UserToLogin = new UserLogin
                            {
                                Username = reader.GetString(0),
                                Password = reader.GetString(1)
                            };
                        }
                    }
                }
            }
        }

        public void StaffLoginPull(string username)
        {
            UserToLogin = new UserLogin();

            string connectionString = "Server=localhost;Database=Redwood_Public_Library;User Id=sa;Password=P@ssw0rd;TrustServerCertificate=True;";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                //Sql Query retriving username and password information based on selected username
                string sql = @"SELECT sl.S_Username, sl.S_Password
                               FROM Staff_Logins sl
                               WHERE sl.S_Username = @Username;";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    command.Parameters.AddWithValue("@Username", username);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            UserToLogin = new UserLogin
                            {
                                Username = reader.GetString(0),
                                Password = reader.GetString(1)
                            };
                        }
                    }
                }
            }
        }

        public void MemberUserInfoPull(string username)
        {
            UserInfo = new AppUser();
            string connectionString = "Server=localhost;Database=Redwood_Public_Library;User Id=sa;Password=P@ssw0rd;TrustServerCertificate=True;";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                string sql = @"SELECT m.M_First_Name + ' ' + ISNULL(m.M_Middle_Name, '') + ' ' + m.M_Last_Name AS Member_Name,
                               ml.M_Username,
                               ml.M_Password,
                               r.Role
                               FROM Member_Logins ml
                               JOIN Members m
                                ON ml.M_Login_ID = m.M_Login_ID
                               JOIN Roles r
                                ON m.Role_ID = r.Role_ID
                               WHERE ml.M_Username = @Username;";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    command.Parameters.AddWithValue("@Username", username);
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            UserInfo = new AppUser
                            {
                                Name = reader.GetString(0),
                                Username = reader.GetString(1),
                                Password = reader.GetString(2),
                                Role = reader.GetString(3)
                            };
                        }
                    }
                }
            }
        }

        public void StaffUserInfoPull(string username)
        {
            UserInfo = new AppUser();
            string connectionString = "Server=localhost;Database=Redwood_Public_Library;User Id=sa;Password=P@ssw0rd;TrustServerCertificate=True;";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                string sql = @"SELECT s.S_First_Name + ' ' + ISNULL(s.S_Middle_Name, '') + ' ' + s.S_Last_Name AS Staff_Name,
                               sl.S_Username,
                               sl.S_Password,
                               r.Role
                               FROM Staff_Logins sl
                               JOIN Staff s
                                ON sl.S_Login_ID = s.S_Login_ID
                               JOIN Roles r
                                ON s.Role_ID = r.Role_ID
                               WHERE sl.S_Username = @Username;";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    command.Parameters.AddWithValue("@Username", username);
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            UserInfo = new AppUser
                            {
                                Name = reader.GetString(0),
                                Username = reader.GetString(1),
                                Password = reader.GetString(2),
                                Role = reader.GetString(3)
                            };
                        }
                    }
                }
            }
        }
    }
public class UserLogin
    {
        public string Username { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
    }
    public class AppUser
    {
        public string Name { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public string Role { get; set; } = string.Empty;
    }
}