#!/bin/bash
client='a8e9a326cdbbe1fa7c72523df85d1ac8'
redirect='www.nu.nl/callback'
google-chrome http://localhost:3000/oauth/authorize?client_id=$client&redirect=$redirect
