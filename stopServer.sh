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

if [[ "$OS" == "Windows" ]]; then
    printf "\nNo puma daemon to kill since we're on Windows.\n"
else
  cd "$(dirname "$0")"
  PIDFILE="tmp/pids/puma.pid"
  STATEFILE="tmp/pids/puma.state"

  if [ -s ${PIDFILE} ]
  then
    PUMA_PID="$(cat ${PIDFILE})"

    printf "Attempting to kill puma with PID: $PUMA_PID" \
    && kill -9 ${PUMA_PID} \
    && printf "\nServer stopped.\n" \
    && rm ${PIDFILE} \
    && rm ${STATEFILE}
  else
    printf "It seems Puma isn't running right now. Nothing to kill.\n"
  fi
fi
