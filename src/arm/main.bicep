param environment string = 'dev'

param productName string = 'susi'

param location string

var applicationInsightsName = 'appi-${productName}-${environment}-001'

var planName = 'plan-${productName}-${environment}-001'

var webAppName = 'web-${productName}-${environment}-001'

//////////////////////
// global variables 
//////////////////////

param tags object = {
  productOwner: 'jas.atwal@capgemini.com'
  application: 'assurance'
  environment: 'dev'
  projectCode: 'nonbillable'
}

module insights './modules/insights.bicep' = {
  name: 'insights'
  params: {
    location: location
    tags: tags
    applicationInsightsName: applicationInsightsName
  }
}

module web './modules/web.bicep' = {
  name: 'web'
  dependsOn: [
    insights
  ]
  params: {
    location: location
    webAppPlanName: planName
    webAppName: webAppName
    tags: tags
    applicationInsightsConnectionString: insights.outputs.applicationInsightsConnectionString
    applicationInsightsInstrumentationKey: insights.outputs.applicationInsightsInstrumentationKey
  }
}
