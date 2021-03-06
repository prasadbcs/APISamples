# apiclient.ps1
#
# dalegaspi

#sign up for developer key @ http://developer.ap.org/
$apikey = '** your API key **'

$keyword_search = 'star wars'

$payload = (Invoke-WebRequest ('http://api.ap.org/v2/search/photo?count=1&apikey={0}&q={1}' -f $apikey,[System.Web.HttpUtility]::UrlEncode($keyword_search)) -Headers @{ accept='application/json' })

# invoke-webrequest has a bug with dealing with BOM
# http://stackoverflow.com/questions/20388562/invoke-restmethod-not-recognizing-xml-with-byte-order-mark-served-by-sharepoint
$json = $payload.Content.Substring(3) | ConvertFrom-Json

'suggested term: "{0}"' -f $json.suggestedTerm.title
'title of the most recent image about "{0}" is "{1}"' -f $keyword_search,$json.entries[0].title

$img_url = ($json.entries[0].contentLinks | ?{ $_.rel -eq "thumbnail" } | select -First 1).href 

'downloading thumbnail link {0}' -f $img_url

Invoke-WebRequest ($img_url + '&apikey={0}' -f $apikey) -OutFile 'c:\temp\thumbnail.jpg'