using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;

namespace Redwood_Public_Library.Pages
{
    public class SearchCatalogModel : PageModel
    {
        public List<Book> BookList { get; set; }

        [BindProperty]
        public string SearchType { get; set; }
        [BindProperty]
        public string? SearchTerm { get; set; } = string.Empty;

        public string Message { get; set; } = string.Empty;

        public void Onget()
        {
        }

        public void OnPost()
        {
            if (string.IsNullOrEmpty(SearchTerm))
            {
                Message = "Please enter a search term.";
                return;
            }

            switch (SearchType)
            {
                case "Title":
                    SearchByName(SearchTerm);
                    break;
                case "ISBN":
                    SearchByISBN(SearchTerm);
                    break;
                case "Author":
                    SearchByAuthor(SearchTerm);
                    break;
                case "Genre":
                    SearchByGenre(SearchTerm);
                    break;
            }
        }
        //Helper method to search by book title
        public void SearchByName(string searchterm)
        {
            BookList = new List<Book>();
            //DBconnection string
            string connectionString = "Server=localhost;Database=Redwood_Public_Library;User Id=sa;Password=P@ssw0rd;TrustServerCertificate=True;";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                //Sql query to search for books by title
                string sql = @"SELECT b.BK_Title, b.ISBN,
                             a.A_First_Name+ ' ' + ISNULL(a.A_Middle_Name, '') + ' ' + a.A_Last_Name AS Author,
                             bl.Language,
                             ba2.Condition
                             FROM Books b
                             JOIN Book_Authors ba
                                ON b.Book_ID = ba.Book_ID
                             JOIN Authors a 
                                ON ba.Author_ID = a.Author_ID
                             JOIN Book_Genres bg
                                ON b.Book_ID = bg.Book_ID
                             JOIN Genres g
                                ON bg.Genre_ID = g.Genre_ID
                             JOIN Book_Copies bc
                                ON b.Book_ID = bc.Book_ID
                             JOIN Book_Availability ba2
                                ON bc.BA_ID = ba2.BA_ID
                             JOIN Book_Language bl 
                                ON bc.BL_ID = bl.BL_ID
                             WHERE b.BK_Title = @SearchTerm;";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    //Parameterized query
                    command.Parameters.AddWithValue("@SearchTerm", searchterm);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            //Adds Retrived books to BookList
                            BookList.Add(new Book
                            {
                                Title = reader["BK_Title"].ToString(),
                                ISBN = reader["ISBN"].ToString(),
                                Author = reader["Author"].ToString(),
                                Language = reader["Language"].ToString(),
                                Availability = reader["Condition"].ToString()
                            });
                        }
                    }
                }
            }
        }
        
        //Helper method to search by book ISBN
        public void SearchByISBN(string searchterm)
        {
            BookList = new List<Book>();
            //DBconnection string
            string connectionString = "Server=localhost;Database=Redwood_Public_Library;User Id=sa;Password=P@ssw0rd;TrustServerCertificate=True;";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                //Sql query to search for books by title
                string sql = @"SELECT b.BK_Title, b.ISBN,
                             a.A_First_Name+ ' ' + ISNULL(a.A_Middle_Name, '') + ' ' + a.A_Last_Name AS Author,
                             bl.Language,
                             ba2.Condition
                             FROM Books b
                             JOIN Book_Authors ba
                                ON b.Book_ID = ba.Book_ID
                             JOIN Authors a 
                                ON ba.Author_ID = a.Author_ID
                             JOIN Book_Genres bg
                                ON b.Book_ID = bg.Book_ID
                             JOIN Genres g
                                ON bg.Genre_ID = g.Genre_ID
                             JOIN Book_Copies bc
                                ON b.Book_ID = bc.Book_ID
                             JOIN Book_Availability ba2
                                ON bc.BA_ID = ba2.BA_ID
                             JOIN Book_Language bl 
                                ON bc.BL_ID = bl.BL_ID
                             WHERE b.ISBN = @SearchTerm;";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    //Parameterized query
                    command.Parameters.AddWithValue("@SearchTerm", searchterm);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            //Adds Retrived books to BookList
                            BookList.Add(new Book
                            {
                                Title = reader["BK_Title"].ToString(),
                                ISBN = reader["ISBN"].ToString(),
                                Author = reader["Author"].ToString(),
                                Language = reader["Language"].ToString(),
                                Availability = reader["Condition"].ToString()
                            });
                        }
                    }
                }
            }
        }
        //Helper method to search by book Author
        public void SearchByAuthor(string searchterm)
        {
            BookList = new List<Book>();
            //DBconnection string
            string connectionString = "Server=localhost;Database=Redwood_Public_Library;User Id=sa;Password=P@ssw0rd;TrustServerCertificate=True;";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                //Sql query to search for books by title
                string sql = @"SELECT b.BK_Title, b.ISBN,
                             a.A_First_Name+ ' ' + ISNULL(a.A_Middle_Name, '') + ' ' + a.A_Last_Name AS Author,
                             bl.Language,
                             ba2.Condition
                             FROM Books b
                             JOIN Book_Authors ba
                                ON b.Book_ID = ba.Book_ID
                             JOIN Authors a 
                                ON ba.Author_ID = a.Author_ID
                             JOIN Book_Genres bg
                                ON b.Book_ID = bg.Book_ID
                             JOIN Genres g
                                ON bg.Genre_ID = g.Genre_ID
                             JOIN Book_Copies bc
                                ON b.Book_ID = bc.Book_ID
                             JOIN Book_Availability ba2
                                ON bc.BA_ID = ba2.BA_ID
                             JOIN Book_Language bl 
                                ON bc.BL_ID = bl.BL_ID
                             WHERE a.A_First_Name = @SearchTerm OR a.A_Last_Name = @SearchTerm;";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    //Parameterized query
                    command.Parameters.AddWithValue("@SearchTerm", searchterm);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            //Adds Retrived books to BookList
                            BookList.Add(new Book
                            {
                                Title = reader["BK_Title"].ToString(),
                                ISBN = reader["ISBN"].ToString(),
                                Author = reader["Author"].ToString(),
                                Language = reader["Language"].ToString(),
                                Availability = reader["Condition"].ToString()
                            });
                        }
                    }
                }
            }
        }

        public void SearchByGenre(string searchterm)
        {
            BookList = new List<Book>();
            //DBconnection string
            string connectionString = "Server=localhost;Database=Redwood_Public_Library;User Id=sa;Password=P@ssw0rd;TrustServerCertificate=True;";
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                //Sql query to search for books by title
                string sql = @"SELECT b.BK_Title, b.ISBN,
                             a.A_First_Name+ ' ' + ISNULL(a.A_Middle_Name, '') + ' ' + a.A_Last_Name AS Author,
                             bl.Language,
                             ba2.Condition
                             FROM Books b
                             JOIN Book_Authors ba
                                ON b.Book_ID = ba.Book_ID
                             JOIN Authors a 
                                ON ba.Author_ID = a.Author_ID
                             JOIN Book_Genres bg
                                ON b.Book_ID = bg.Book_ID
                             JOIN Genres g
                                ON bg.Genre_ID = g.Genre_ID
                             JOIN Book_Copies bc
                                ON b.Book_ID = bc.Book_ID
                             JOIN Book_Availability ba2
                                ON bc.BA_ID = ba2.BA_ID
                             JOIN Book_Language bl 
                                ON bc.BL_ID = bl.BL_ID
                             WHERE g.Genre = @SearchTerm;";
                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    //Parameterized query
                    command.Parameters.AddWithValue("@SearchTerm", searchterm);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            //Adds Retrived books to BookList
                            BookList.Add(new Book
                            {
                                Title = reader["BK_Title"].ToString(),
                                ISBN = reader["ISBN"].ToString(),
                                Author = reader["Author"].ToString(),
                                Language = reader["Language"].ToString(),
                                Availability = reader["Condition"].ToString()
                            });
                        }
                    }
                }
            }
        }
    }
    public class Book
    {
        public string? Title { get; set; } = string.Empty;
        public string? ISBN { get; set; } = string.Empty;
        public string? Author { get; set; } = string.Empty;
        public string? Language { get; set; } = string.Empty;
        public string? Availability { get; set; } = string.Empty;
    }
}