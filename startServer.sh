#!/usr/bin/env bash

cd "$(dirname "$0")"

HOME_RVM=$HOME/.rvm/scripts/rvm
ROOT_RVM="/usr/local/rvm/scripts/rvm"
# Load RVM into a shell session *as a function*
if [[ -s ${HOME_RVM} ]] ; then
  # First try to load from a user install
  source ${HOME_RVM} \
  && printf "\nRVM successfully loaded from $HOME_RVM\n"

elif [[ -s ${ROOT_RVM} ]] ; then
  # Then try to load from a root install
  source ${ROOT_RVM} \
  && printf "\nRVM successfully loaded from $ROOT_RVM\n"
else
  printf "\nWARNING: An RVM installation was not found. Did you follow the instructions correctly? Attempting to use system Ruby...\n"
fi

printf "\nIf you run into any issues, check the error logs in: logs/production.stderr.log, logs/production.stdout.log, and logs/production.log\n\n"

mkdir -p tmp/pids && touch tmp/pids/puma.pid && exec bundle exec puma -C config/puma.rb config.ru

