using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Identity.Web;
using Microsoft.Identity.Web.UI;

namespace idmv2.ui;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container.
        builder.Services.AddAuthentication(OpenIdConnectDefaults.AuthenticationScheme)
                        .AddMicrosoftIdentityWebApp(options =>
                        {
                            builder.Configuration.Bind("AzureAdB2C", options);
                            options.Events ??= new OpenIdConnectEvents();

                            // set before...
                            options.Events.OnRedirectToIdentityProvider = context =>
                            {
                                context.ProtocolMessage.Parameters.Add("serviceId", builder.Configuration.GetValue<string>("AzureAdB2C:ServiceId"));

                                return Task.CompletedTask;
                            };

                            // inspect after...
                            options.Events.OnTokenResponseReceived = context =>
                            {
                                return Task.CompletedTask;
                            };
                        });

        builder.Services.AddRazorPages()
            .AddMicrosoftIdentityUI();

        builder.Services.AddHttpContextAccessor();

        var app = builder.Build();

        // Configure the HTTP request pipeline.
        if (!app.Environment.IsDevelopment())
        {
            app.UseExceptionHandler("/Error");
            // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
            app.UseHsts();
        }

        app.UseHttpsRedirection();
        app.UseStaticFiles();

        app.UseRouting();

        app.UseAuthorization();

        app.MapRazorPages();
        app.MapControllers();

        app.Run();
    }
}
