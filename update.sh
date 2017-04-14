#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"
printf "\nPulling down the latest for the current branch.\n"
git pull
printf "\nExecuting the serverSetup.sh script to recompile assets and update dependencies.\n"
source serverSetup.sh
