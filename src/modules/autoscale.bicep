targetScope = 'resourceGroup'

@description('Namnprefix, t.ex. myAppPlan-prod.')
param namePrefix string
param appServicePlanId string

@description('Min/Default/Max instanser')
param minCapacity string
param defaultCapacity string
param maxCapacity string

@description('CPU-trösklar (%)')
param cpuScaleOutThreshold int
param cpuScaleInThreshold int

param timeWindow string
param timeGrain string
param cooldown string

var autoscaleName = '${namePrefix}-autoscale-${uniqueString(appServicePlanId)}'

resource autoscale 'Microsoft.Insights/autoscaleSettings@2022-10-01' = {
  name: autoscaleName
  location: resourceGroup().location
  properties: {
    enabled: true
    targetResourceUri: appServicePlanId
    profiles: [
      {
        name: 'defaultProfile'
        capacity: {
          minimum: minCapacity
          maximum: maxCapacity
          default: defaultCapacity
        }
        rules: [
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricNamespace: 'Microsoft.Web/serverfarms'
              metricResourceUri: appServicePlanId
              timeGrain: timeGrain
              statistic: 'Average'
              timeWindow: timeWindow
              timeAggregation: 'Average'
              operator: 'GreaterThan'
              threshold: cpuScaleOutThreshold
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
              cooldown: cooldown
            }
          }
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricResourceUri: appServicePlanId
              timeGrain: timeGrain
              statistic: 'Average'
              timeWindow: timeWindow
              timeAggregation: 'Average'
              operator: 'LessThan'
              threshold: cpuScaleInThreshold
            }
            scaleAction: {
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
              cooldown: cooldown
            }
          }
        ]
      }
    ]
  }
}
