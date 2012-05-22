#!/bin/bash
#swap auth code for access token
code='3e3ed67e36ba0e669964c9'
client_id='a8e9a326cdbbe1fa7c72523df85d1ac8' #taxi app id
secret='e98b132b7eeebfbf448d88'
redirect_url='http://taxi.local/callback'

curl http://localhost:3000/api/oauth/token \
-H "Accept: application/json" \
-X POST -d "{\"code\": \"$code\",\
\"grant_type\": \"authorization_code\",\
\"client_id\": \"$client_id\",\
\"client_secret\": \"$secret\"}" > token.txt
