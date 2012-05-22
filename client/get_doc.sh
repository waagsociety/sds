#!/bin/bash
#retrieve all documents for a person in a context using a token
token='9422250d510137e15b6fdd'
echo 'token: '$token

curl http://localhost:3000/api/all \
-H "Accept: application/json" \
-H "Authorization: OAuth2 $token"


