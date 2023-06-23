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

Two different implementations of connecting to B2C. Both use [Microsoft.Identity.Web](https://www.nuget.org/packages/Microsoft.Identity.Web) and [Microsoft.Identity.Web.UI](https://www.nuget.org/packages/Microsoft.Identity.Web.UI). The first configures middleware as follows:

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

With the associated the application configuration looks something like this:

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

The second is similar, but sends a custom query string parameter that is expected by B2C as part of the sign in:

``` C#
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
```

And uses the following configuration:

``` json
  "AzureAdB2C": {
    "Instance": "https://susi2b2cdev.b2clogin.com",
    "TenantId": "a2e8fe65-6a4d-4a53-8d7c-30f491597160",
    "ClientId": "7fa4a319-dbc5-447a-a116-c740e24b10b6",
    "ClientSecret": "somethingreallysecure",
    "Domain": "susi2b2cdev.onmicrosoft.com",
    "ResponseType": "code",
    "Scope": [ "openid", "offline_access", "7fa4a319-dbc5-447a-a116-c740e24b10b6" ],
    "SignedOutCallbackPath": "/signout-callback-oidc",
    "SignUpSignInPolicyId": "B2C_1_susi2",
    "SaveTokens": true,
    "ServiceId": "df89ea63-d5ba-4faa-92b6-ed563e901360"
  },
```
