using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace Redwood_Public_Library.Pages;

public class IndexModel : PageModel
{
    public void OnGet()
    {
    }
    //Method to redirect to login page upon post request, such as when a user clicks a "Login" button on the homepage
    public async Task<IActionResult> OnPost()
    {
        return RedirectToPage("/Login");
    }
}
