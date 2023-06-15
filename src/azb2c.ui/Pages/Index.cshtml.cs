using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace azb2c.ui.Pages;

public class IndexModel : PageModel
{
    [BindProperty]
    public IEnumerable<Claim> Claims { get; set; } = Enumerable.Empty<Claim>();

    public void OnGet()
    {
        Claims = User.Claims;
    }
}

