#!/bin/bash
#store a document
token='9422250d510137e15b6fdd'

curl http://localhost:3000/api/store \
-H "Accept: application/json" \
-H "Authorization: OAuth2 $token" \
-X POST -d "{\"fake document 3\"}"

#todo create an actual document
