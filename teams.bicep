param username string

@secure()
param password string

@secure()
param clientSecret string

param location string = resourceGroup().location

resource test_script 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'testScript'
  location: location
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '5.1'
    retentionInterval: 'P1D'
    arguments: '-username \'${username}\' -password \'${password}\' -clientSecret \'${clientSecret}\''
    scriptContent: '''param($username, $password, $clientSecret)
      Install-Module -Name PowerShellGet -Force -AllowClobber
      Install-Module -Name MicrosoftTeams -Force -AllowClobber
      Import-Module MicrosoftTeams

      $tenantName = "mondagoteams.onmicrosoft.com"  
      $clientId = "5f038925-e641-441e-974f-e2f077e153b2"

      $uri = "https://login.microsoftonline.com/$tenantName/oauth2/v2.0/token"

      $body = @{  
        Grant_Type    = "password";
        #Grant_Type    = "client_credentials";
        Scope         = "https://graph.microsoft.com/.default"  
        Client_Id     = $clientId;
        Client_Secret = $clientSecret;
        Username      = $username; 
        Password      = $password;
      }   
      $graphTokenResponse = Invoke-RestMethod -Method POST -Uri $uri -Body $body
      $graphToken = $graphTokenResponse.access_token

      $body = @{  
        Grant_Type    = "password"  # client_credentials
        #Grant_Type    = "client_credentials"
        Scope         = "48ac35b8-9aa8-4d74-927d-1f4a14a0b239/.default"
        Client_Id     = $clientId  
        Client_Secret = $clientSecret  
        Username      = $username  
        Password      = $password  
      }   
      $teamsTokenResponse = Invoke-RestMethod -Method POST -Uri $uri -Body $body
      $teamsToken = $teamsTokenResponse.access_token

      Connect-MicrosoftTeams -AccessTokens @($graphToken, $teamsToken)
      Get-CsTeamsComplianceRecordingPolicy
      Disconnect-MicrosoftTeams
    '''
  }
}
