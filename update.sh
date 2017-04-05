#!/bin/bash
echo "Pulling down the latest for the current branch"
git pull
echo "Executing the serverSetup.sh script"
source serverSetup.sh