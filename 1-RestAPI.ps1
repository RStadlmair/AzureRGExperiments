#region authenticate

$loginurl = 'https://login.microsoftonline.com'

$tokenbody = @{
    grant_type = 'client_credentials'
    client_id = $appid
    client_secret = $appkeyplain
    resource = 'https://management.azure.com/'
}

$iwparam = @{
    uri = "$loginurl" + "/$tenantid/oauth2/token"
    method = 'POST'
    body = $tokenbody
}

invoke-webrequest @iwparam -Outvariable oAuth2
$token = $oauth2.content|convertfrom-JSON

#endregion

#region List all resources Subscription Big-MAS
$listUri = "https://management.azure.com/subscriptions/$subscriptionid/resources?api-version=2018-05-01"
$body = @{
    ts = [System.DateTime]::UtcNow.ToString('o')
}
$header = @{
    'Authorization' = "$($Token.token_type) $($Token.access_token)"
    "Content-Type"  = "application/json"
}
$listparam = @{
    method = 'GET'
    uri = $listUri
    headers = $header
    body = $body
}
invoke-webrequest @listparam -OutVariable Rawrestresults

# Prepare output
$RESTResults = $RawRestResults.Content|ConvertFrom-Json |select -ExpandProperty value
#endregion

#region List all resources Subscription Small-VSE
$subscriptionSMALLid = 'fdfb69f2-ef24-4f8f-9e63-785c9f1ef5ea'
$listUri = "https://management.azure.com/subscriptions/$subscriptionSMALLid/resources?api-version=2018-05-01"
$body = @{
    ts = [System.DateTime]::UtcNow.ToString('o')
}
$header = @{
    'Authorization' = "$($Token.token_type) $($Token.access_token)"
    "Content-Type"  = "application/json"
}
$listparam = @{
    method = 'GET'
    uri = $listUri
    headers = $header
    body = $body
}
invoke-webrequest @listparam -OutVariable Rawrestresults

$RESTResults += $RawRestResults.Content|ConvertFrom-Json|select -ExpandProperty value
#endregion

#region One VM
$vmrgname = 'p-rg-vms'
$vmname = 'UbuntuJumpBox'
$vmGetUri = "https://management.azure.com/subscriptions/$($subscriptionId)/resourceGroups/$($vmrgname)/providers/Microsoft.Compute/virtualMachines/$($vmname)?api-version=2018-06-01"
$body = @{
    ts = [System.DateTime]::UtcNow.ToString('o')
}
$header = @{
    'Authorization' = "$($Token.token_type) $($Token.access_token)"
    'Content-Type'  = 'application/json'
}
$listparam = @{
    method = 'GET'
    uri = $vmGetUri
    headers = $header
    body = $body
}
invoke-webrequest @listparam -OutVariable RawRestVMResults

$RestVM = $RawRestVMResults.Content|ConvertFrom-Json
$restVM.properties.storageProfile.osDisk.osType

#endregion

