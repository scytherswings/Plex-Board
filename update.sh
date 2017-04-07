#!/usr/bin/env bash

cd "$(dirname "$0")"
printf "\nPulling down the latest for the current branch"
git pull
printf "\Executing the serverSetup.sh script to recompile assets and update dependencies."
source serverSetup.sh