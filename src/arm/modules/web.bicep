param location string

param webAppPlanName string

param webAppName string

param applicationInsightsInstrumentationKey string

param applicationInsightsConnectionString string

param webAppPlanSku string = 'P1v2'

param webAppPlanTier string = 'PremiumV2'

param tags object

resource plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  location: location
  name: webAppPlanName
  tags: tags
  sku: {
    name: webAppPlanSku
    tier: webAppPlanTier
    size: webAppPlanSku
    family: webAppPlanSku
    capacity: 3
  }
  kind: 'app'
  properties: {}
}

resource webApiApp 'Microsoft.Web/sites@2022-09-01' = {
  location: location
  name: webAppName
  tags: tags
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      alwaysOn: true
      vnetRouteAllEnabled: true
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsightsInstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsightsConnectionString
        }
        {
          name: 'AzureAdB2C__Instance'
          value: '???'
        }
        {
          name: 'AzureAdB2C__ClientId'
          value: '???'
        }
        {
          name: 'AzureAdB2C__TenantId'
          value: '???'
        }
        {
          name: 'AzureAdB2C__Domain'
          value: '???'
        }
        {
          name: 'AzureAdB2C__CallbackPath'
          value: '/signin-oidc'
        }
        {
          name: 'AzureAdB2C__SignedOutCallbackPath'
          value: '/signout-callback-oidc'
        }
        {
          name: 'AzureAdB2C__SignUpSignInPolicyId'
          value: 'B2C_1_susi1'
        }
      ]
    }
  }
}
