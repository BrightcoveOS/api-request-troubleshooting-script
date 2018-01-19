#!/bin/bash

# Purpose: Troubleshoot HTTP requests and reponses to/from Brightcove APIs

# Install: Move this file to a directory you control

# Prereq's:
# 1) bash
# 2) cURL
# 3) valid Video Cloud Studio ClientId and ClientSecret
# 4) valid request URL

# Use
# 1) Open terminal
# 2) navigate to directory containing this file
# 3) run 'sudo ./requestTool.sh'
# 4) follow prompts
# 5) Search the directory containing this file for 'request_log.txt'


#get creds from user
echo "please enter your client ID"
read client_id

echo "please enter your client secret"
read client_secret

echo "please enter the full request URL"
read request_url

#OR comment out above and uncommnet below to hardcode
# BC Support Creds Client ID
# client_id=""
# client_secret=""
# request_url=""

# divider for request/response data
req_url_header=">>>>>>>>>>>>>>>> REQUEST/RESPONSE >>>>>>>>>>>>>>>>>"

# format for time breakdown output
write_out_format="

>>>>>>>> CONNECTION BREAKDONWN >>>>>>>>>>>

num_connects:		%{num_connects}
num_redirects:		%{num_redirects}

>>>>>>>> SIZE BREAKDONWN >>>>>>>>>>>

size_request:		%{size_request}
size_upload:		%{size_upload}

size_header: 		%{size_header}
size_download:		%{size_download}

>>>>>>>> SPEED BREAKDONWN >>>>>>>>>>>

speed_download: 	%{speed_download}
speed_upload:		%{speed_upload}

>>>>>>>>> TIME BREAKDONWN >>>>>>>>>>>

time_namelookup: 	%{time_namelookup}
time_connect:  		%{time_connect}
time_appconnect: 	%{time_appconnect}
time_pretransfer:  	%{time_pretransfer}
time_redirect:  	%{time_redirect}
time_starttransfer: %{time_starttransfer}
----------
time_total:  		%{time_total} seconds
"


# used to parse JSON in resposne
function parseJSON {
    temp=`echo $json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $prop`
    echo ${temp##*|}
}

# get auth token using OAUTH API
# request will use the above entered client ID as username
# request will require client secret as password
json=`curl -s -X POST -u "$client_id:$client_secret" -H "Accept: application/json" -H "Content-Type: application/x-www-form-urlencoded" "https://oauth.brightcove.com/v4/access_token?grant_type=client_credentials"`

#property to parse json for
prop='access_token'

#execute json parse on oauth response
auth_token=`parseJSON`

#get response time
response_metrics=`curl -v -w "$write_out_format" -s -H "Authorization: Bearer $auth_token" -H "Accept: application/json" "$request_url" 2>&1 `

output="$req_url_header\n\n"
output="$output$request_url\n"
output="$output$response_metrics\n\n"

#output info to a file with the name below in the current working directory
printf %b "$output" > request_log.txt

#set client id and auth token to empty string
auth_token=""
client_id=""
