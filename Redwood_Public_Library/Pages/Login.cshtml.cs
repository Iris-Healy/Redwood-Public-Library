using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;
using System.Diagnostics.Eventing.Reader;
using System.Runtime.CompilerServices;
using System.Security.AccessControl;
using Microsoft.AspNetCore.Identity;

namespace Redwood_Public_Library.Pages
{
    public class LoginModel : PageModel
    {
        [BindProperty]
        public string Username { get; set; }

        [BindProperty]
        public string Password { get; set; }

        [BindProperty]

        private UserLogin UserToLogin { get; set;}

        private User UserInfo { get; set; }
        
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

            if (IsStaff)
            {
                StaffLoginPull(Username);
                if (UserToLogin != null && UserToLogin.Password == Password)
                {
                    StaffUserInfoPull(Username);
                    Message = $"Welcome, {Username}! You have successfully logged in as staff.";
                }
                else
                {
                    Message = "Invalid staff username or password.";
                }
            }
            else
            {
                MemberLoginPull(Username);
                if (UserToLogin != null && UserToLogin.Password == Password)
                {
                    MemberUserInfoPull(Username);
                    Message = $"Welcome, {Username}! You have successfully logged in as a member.";
                }
                else
                {
                    Message = "Invalid member username or password.";
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
                string sql = @"SELECT ml.M_Username, ml.M_Username
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
                                Username = reader.GetString(1),
                                Password = reader.GetString(2)
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
                                Username = reader.GetString(1),
                                Password = reader.GetString(2)
                            };
                        }
                    }
                }
            }
        }

        public void MemberUserInfoPull(string username)
        {
            UserInfo = new User();
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
                            UserInfo = new User
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
            UserInfo = new User();
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
                            UserInfo = new User
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


        public class UserLogin
        {
            public string Username { get; set; }
            public string Password { get; set; }
        }
        public class User
        {
            public string Name { get; set; }
            public string Username { get; set; }
            public string Password { get; set; }
            public string Role { get; set; }
        }
    }
}