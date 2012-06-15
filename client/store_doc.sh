#!/bin/bash
#store a document
token='255f604b13a667c296c6f7'
curl http://localhost:3000/api/store \
-H "Accept: application/json" \
-H "Authorization: OAuth2 $token" \
-X POST -d @doc.txt 

#todo create an actual document
