$NinjaURL = 'https://app.ninjarmm.com'
$AuthHeader = $null

function Connect-NinjaOne {
    param ( $clientId, $clientSecret)

    if(($clientId -eq $null) -or ($clientSecret -eq $null)) { 
        Write-Output 'Failed to pull API credentials.'
        exit
    }

    $AuthBody = @{
        'grant_type'    = 'client_credentials'
        'client_id'     = $clientId
        'client_secret' = $clientSecret
        'scope'         = 'monitoring management control'
    }

    $token = Invoke-WebRequest -uri "$($NinjaURL)/ws/oauth/token" -Method POST -Body $AuthBody -ContentType 'application/x-www-form-urlencoded'

    $global:AuthHeader = @{
        'Authorization' = "Bearer $(($token.content | ConvertFrom-Json).access_token)"
    }
}

#Returns array of organizations in Ninja.
function Get-Organizations {
  $organizations = (Invoke-WebRequest -uri "$($NinjaURL)/api/v2/organizations" -Method GET -Headers $AuthHeader -ContentType 'application/json').content | ConvertFrom-Json
  $organizations = $organizations | Sort-Object name
  return $organizations
}

#Returns array of documents for the organization ID provided.
function Get-Documents {
  param ( $orgId )
  return (Invoke-WebRequest -uri "$($NinjaURL)/api/v2/organization/$($orgId)/documents" -Method GET -Headers $AuthHeader -ContentType 'application/json').content | ConvertFrom-Json
}

#Returns field from a single-page document for an organization.
function Get-Doc-Field {
  param ( $orgId, $docName, $fieldName )
  
  $docs = Get-Documents $orgId
  $document = $docs | Where { $_.documentName -eq $docName }
  $fieldValue = ""
  if($document){
    $field = $document.fields | Where {$_.name -eq $fieldName}
    $fieldValue = $field.value
  }
  return $fieldValue
}

#Returns array of devices for the organization ID provided.
function Get-Devices {
  param ( $orgId )
  return (Invoke-WebRequest -uri "$($NinjaURL)/api/v2/organization/$($orgId)/devices" -Method GET -Headers $AuthHeader -ContentType 'application/json').content | ConvertFrom-Json
}

#Returns array of all Windows devices.
function Get-Devices-Windows {
    return (Invoke-WebRequest -uri "$($NinjaURL)/api/v2/devices?df=class%20in%20%28WINDOWS_SERVER%2C%20WINDOWS_WORKSTATION%29" -Method GET -Headers $AuthHeader -ContentType 'application/json').content | ConvertFrom-Json
}

#Returns AV status for a device ID provided.
function Get-Device-AV-Status {
    param ( $id )

    return (Invoke-WebRequest -uri "$($NinjaURL)/api/v2/queries/antivirus-status?df=id%3D$($id)" -Method GET -Headers $AuthHeader -ContentType 'application/json').content | ConvertFrom-Json
}

#Updates custom fields on a device.
function Set-Device-Fields {
  param ( $id, $fields )
  
  $body = ConvertTo-Json $fields

  $code = (Invoke-WebRequest -uri "$($NinjaURL)/api/v2/device/$($id)/custom-fields" -Method PATCH -Headers $AuthHeader -Body $body -ContentType 'application/json').content | ConvertFrom-Json
  return $code.StatusCode
}

#Updates custom fields for an organization.
function Set-Org-Fields {
  param ( $id, $fields )
  
  $body = ConvertTo-Json $fields

  $code = (Invoke-WebRequest -uri "$($NinjaURL)/api/v2/organization/$($id)/custom-fields" -Method PATCH -Headers $AuthHeader -Body $body -ContentType 'application/json').content | ConvertFrom-Json
  return $code.StatusCode
}

#Returns array of custom fields for the organization ID provided.
function Get-Org-Fields {
  param ( $orgId )
  return (Invoke-WebRequest -uri "$($NinjaURL)/api/v2/organization/$($orgId)/custom-fields" -Method GET -Headers $AuthHeader -ContentType 'application/json').content | ConvertFrom-Json
}

#Returns custom field from an organization based on ID and field name.
function Get-Org-Field {
  param ( $orgID, $fieldName )
  
  $customFields = Get-Org-Fields $orgId
  $customField = $customFields.$fieldName
  if( $customField -ne $null ){ $customField = $customField.Trim() }
  return $customField
}

#Patch KB article based on document ID and HTML
function Patch-KB-Article {
    param ( $docId, $html )

    $body = @"
    [
      {
        "id":$docId,
        "content": {
          "html": "$html"
        }
      }
    ]
"@
    return (Invoke-WebRequest -uri "$($NinjaURL)/api/v2/knowledgebase/articles" -Method PATCH -ContentType 'application/json' -Headers $AuthHeader -Body $body).content | ConvertFrom-Json
}