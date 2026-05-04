using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;
using Microsoft.AspNetCore.Authorization;


namespace Redwood_Public_Library.Pages
{
    [Authorize(Roles = "Member")]
    public class MemberCheckedOutModel : PageModel
    {
        public List<UserBook> CheckedOutBooks { get; set; }

        public string MemberName { get; set; }

        public void OnGet()
        {
            PullCheckedOutBooks();
            GetMemberName();
        }
        public void GetMemberName()
        {
            MemberName = User.Identity.Name;
        }

        public void PullCheckedOutBooks()
        {
            string username = User.Identity.Name;
            CheckedOutBooks = new List<UserBook>();
            //DBconnection string
            string connectionString = "Server=localhost;Database=Redwood_Public_Library;User Id=sa;Password=P@ssw0rd;TrustServerCertificate=True;";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                //Sql query to search for books by title
                string sql = @"SELECT b.BK_Title, b.ISBN,
                             a.A_First_Name+ ' ' + ISNULL(a.A_Middle_Name, '') + ' ' + a.A_Last_Name AS Author,
                             bc.BC_Price,
                             bl.Loan_Date, bl.Due_Date
                             FROM Books b  
                             JOIN Book_Copies bc
                                ON b.Book_ID = bc.Book_ID 
                             JOIN Book_Authors ba  
                                ON b.Book_ID = ba.Book_ID
                             JOIN Authors a    
                                ON ba.Author_ID = a.Author_ID
                             JOIN Book_Lending bl  
                                ON bc.BC_ID = bl.BC_ID
                             JOIN Members m 
                                ON bl.Member_ID = m.Member_ID
                             JOIN Member_Logins ml 
                                ON m.M_Login_ID = ml.M_Login_ID
                             WHERE ml.M_Username = @username;";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    //Parameterized query
                    command.Parameters.AddWithValue("@username", username);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            //Adds Retrived books to BookList
                            CheckedOutBooks.Add(new UserBook
                            {
                                Title = reader["BK_Title"].ToString(),
                                ISBN = reader["ISBN"].ToString(),
                                Author = reader["Author"].ToString(),
                                Price = Convert.ToDecimal(reader["BC_Price"]),
                                LoanDate = Convert.ToDateTime(reader["Loan_Date"]),
                                DueDate = Convert.ToDateTime(reader["Due_Date"])
                            });
                        }
                    }
                }
            }
        }
    }
    
    public class UserBook
    {
        public string Title { get; set; }
        public string ISBN { get; set; }
        public string Author { get; set; }
        public decimal Price { get; set; }
        public DateTime LoanDate { get; set; }
        public DateTime DueDate { get; set; }
    }
}