# api-request-troubleshooting-script

Troubleshooting shell script for Brightcove API requests

## Purpose:

Troubleshoot HTTP requests and reponses to/from Brightcove APIs

## Installation:

Move this file to a directory you control

## Requirements:

1. bash
2. [cURL](https://support.brightcove.com/concepts-set-curl)
3. valid [Brightcove ClientId and ClientSecret](https://support.brightcove.com/managing-api-authentication-credentials) (or use this Brightcove Learning Services [sample app](https://support.brightcove.com/oauth-api-sample-create-client-credentials))
4. valid request URL for one of the [Brightcove REST APIs](https://support.brightcove.com/getting-started-brightcove-apis) that use OAuth2 for authentication

## Use

1. Open terminal
2. navigate to directory containing this file
3. run 'sudo ./requestTool.sh'
4. follow prompts
5. Search the directory containing this file for 'request_log.txt'
