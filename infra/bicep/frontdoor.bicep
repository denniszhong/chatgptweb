param location string = 'eastus'
param frontDoorName string = 'fd-chatgptweb'
param backendAddress string
param backendHttpsPort int = 443

resource frontDoor 'Microsoft.Network/frontDoors@2020-01-01' = {
  name: frontDoorName
  location: location
  properties: {
    routingRules: [
      {
        name: 'exampleRoutingRule'
        properties: {
          frontendEndpoints: [
            {
              id: resourceId('Microsoft.Network/frontDoors/frontendEndpoints', frontDoorName, 'exampleFrontendEndpoint')
            }
          ]
          acceptedProtocols: [
            'Https'
          ]
          patternsToMatch: [
            '/*'
          ]
          enabledState: 'Enabled'
          routeConfiguration: {
            '@type': 'Microsoft.Network/frontDoorRouteConfiguration'
            backendPool: {
              id: resourceId('Microsoft.Network/frontDoors/backendPools', frontDoorName, 'exampleBackendPool')
            }
            forwardingProtocol: 'HttpsOnly'
            customForwardingPath: ''
            queryStringCachingBehavior: 'IgnoreQueryString'
          }
        }
      }
    ]
    backendPools: [
      {
        name: 'exampleBackendPool'
        properties: {
          backends: [
            {
              address: backendAddress
              httpPort: 80
              httpsPort: backendHttpsPort
              enabledState: 'Enabled'
              weight: 50
              priority: 1
            }
          ]
          loadBalancingSettings: {
            id: resourceId('Microsoft.Network/frontDoors/loadBalancingSettings', frontDoorName, 'exampleLoadBalancingSettings')
          }
          healthProbeSettings: {
            id: resourceId('Microsoft.Network/frontDoors/healthProbeSettings', frontDoorName, 'exampleHealthProbeSettings')
          }
        }
      }
    ]
    frontendEndpoints: [
      {
        name: 'exampleFrontendEndpoint'
        properties: {
          hostName: '${frontDoorName}.azurefd.net'
          sessionAffinityEnabledState: 'Disabled'
          webApplicationFirewallPolicyLink: null
        }
      }
    ]
    healthProbeSettings: [
      {
        name: 'exampleHealthProbeSettings'
        properties: {
          path: '/'
          protocol: 'Https'
          intervalInSeconds: 120
          healthProbeMethod: 'Head'
          enabledState: 'Enabled'
        }
      }
    ]
    loadBalancingSettings: [
      {
        name: 'exampleLoadBalancingSettings'
        properties: {
          sampleSize: 4
          successfulSamplesRequired: 2
          additionalLatencyMilliseconds: 0
        }
      }
    ]
  }
}
