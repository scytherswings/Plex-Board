#!/usr/bin/env bash

cd "$(dirname "$0")"
printf "\nPulling down the latest for the current branch.\n"
git pull
printf "\nInstalling ruby-2.3.4 if it isn't already installed. This could take a while...\n"
rvm install ruby-2.3.4
printf "\nExecuting the serverSetup.sh script to recompile assets and update dependencies."
source serverSetup.sh