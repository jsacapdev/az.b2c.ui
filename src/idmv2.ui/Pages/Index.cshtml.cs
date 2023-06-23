using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace idmv2.ui.Pages;

public class IndexModel : PageModel
{
    private readonly ILogger<IndexModel> _logger;

    [BindProperty]
    public IEnumerable<Claim> Claims { get; set; } = Enumerable.Empty<Claim>();

    public IndexModel(ILogger<IndexModel> logger)
    {
        _logger = logger;
    }

    public void OnGet()
    {
        Claims = User.Claims;
    }
}
