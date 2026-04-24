using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Collections.Generic;
using Microsoft.Data.SqlClient;
using Microsoft.AspNetCore.Authorization;

namespace Redwood_Public_Library.Pages
{
    [Authorize(Roles = "Member")]
    public class MemberCheckedOurModel : PageModel
    {
        public List<Book>
    }

}