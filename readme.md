# Azure B2C User Interface

A simple ASP.NET Core web application (user interface) that integrates with Azure B2C. Once a user has successfully signed in, it will present back the claims received on the home page.

## Project Template Creation

The following command can be run to scaffold the web app:

``` pwsh
dotnet new webapp `
-n azb2c.ui `
--auth IndividualB2C `
--aad-b2c-instance https://susi2b2cdev.b2clogin.com  `
-ssp B2C_1_susi1 `
--client-id 7c30ffab-6f31-4433-b104-84da440b5605 `
--domain susi2b2cdev.onmicrosoft.com `
--tenant-id cadf99e7-c1ed-4239-b0d1-197b95355ae4 `
--callback-path /signout/B2C_1_susi1 `
--use-program-main `
--framework net7.0
```

## Configuration

The application uses [Microsoft.Identity.Web](https://www.nuget.org/packages/Microsoft.Identity.Web) and [Microsoft.Identity.Web.UI](https://www.nuget.org/packages/Microsoft.Identity.Web.UI). Middleware is configured as follows:

``` C#
        builder.Services.AddAuthentication(OpenIdConnectDefaults.AuthenticationScheme)
            .AddMicrosoftIdentityWebApp(builder.Configuration.GetSection("AzureAdB2C"));

        builder.Services.AddAuthorization(options =>
        {
            options.FallbackPolicy = options.DefaultPolicy;
        });

        builder.Services.AddRazorPages()
            .AddMicrosoftIdentityUI();
```

Finally, the application configuration looks something like this:

``` json
  "AzureAdB2C": {
    "Instance": "https://susi2b2cdev.b2clogin.com",
    "ClientId": "370d6eeb-7caa-41bc-98d2-1ee97ecb9c75",
    "TenantId": "0506b1a6-d159-4ef2-bdc4-49d9edf6ca74",
    "Domain": "susi2b2cdev.onmicrosoft.com",
    "CallbackPath": "/signin-oidc",
    "SignedOutCallbackPath": "/signout-callback-oidc",
    "SignUpSignInPolicyId": "B2C_1_susi2"
  },
```

In summary, leverage the policies of the ASP.NET Core middleware to for native B2C integration.
