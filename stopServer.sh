#!/usr/bin/env bash

cd "$(dirname "$0")"
PIDFILE="tmp/pids/puma.pid"
STATEFILE="tmp/pids/puma.state"

if [ -e ${PIDFILE} ]
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