#!/usr/bin/env bash

WSK_AUTH_KEY=`./bin/getWhiskKey.sh`
wsk property set --auth "${WSK_AUTH_KEY}"
