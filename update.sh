#!/usr/bin/env bash

cd "$(dirname "$0")"
printf "\nPulling down the latest for the current branch.\n"
git pull
printf "\nExecuting the serverSetup.sh script to recompile assets and update dependencies."
source serverSetup.sh