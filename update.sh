#!/usr/bin/env bash
set -e

case "$(uname -s)" in

   Darwin)
     OS="Mac OSX"
     ;;

   Linux)
     OS="Linux"
     ;;

   CYGWIN*|MINGW32*|MSYS*)
     OS="Windows"
     ;;

   *)
     OS="Unknown"
     ;;
esac

cd "$(dirname "$0")"
if [[ "$OS" == "Windows" ]]; then
  printf "\nSince we're on Windows the local Gemfile.lock will be deleted prevent cross-platform conflicts.\n"
  rm Gemfile.lock
fi

printf "\nPulling down the latest for the current branch.\n"
git pull
printf "\nExecuting the serverSetup.sh script to recompile assets and update dependencies.\n"
source serverSetup.sh
