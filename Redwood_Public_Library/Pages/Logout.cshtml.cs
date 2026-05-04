using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;

namespace Redwood_Public_Library.Pages
{
    [Authorize(Roles = "Admin, Librarian, Member")]
    public class LogoutModel : PageModel
    {   //Clear the user's authentication cookie and redirect to the login page
        public async Task<IActionResult> OnGetAsync()
        {
        await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
        HttpContext.User = new System.Security.Claims.ClaimsPrincipal(new System.Security.Claims.ClaimsIdentity());
        Response.Cookies.Delete(".AspNetCore.Cookies");
        return RedirectToPage("/Login");
        }
    }
}
    