#!/bin/bash

docker run -d \
    --name ut2004 \
    -p 10.42.0.203:5000:80 \
    -p 10.42.0.203:7777:7777 \
    -p 10.42.0.203:7778:7778 \
    -e "CONFIG_1=[Engine.AccessControl];AdminPassword=password123;[UWeb.WebServer];bEnabled=True" \
    -e "UT2004_CMD=CTF-FACECLASSIC?game=XGame.xCTFGame" \
    reflectivecode/ut2004
