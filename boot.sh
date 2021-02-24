#!/bin/sh

shutdown() {
  echo "shutting down container"

  # first shutdown any service started by runit
  for _srv in $(ls -1 /etc/service); do
    sv force-stop $_srv
  done

  # shutdown runsvdir command
  kill -HUP $RUNSVDIR
  wait $RUNSVDIR

  # give processes time to stop
  sleep 0.5

  # kill any other processes still running in the container
  for _pid  in $(ps -eo pid | grep -v PID  | tr -d ' ' | grep -v '^1$' | head -n -6); do
    timeout -t 5 /bin/sh -c "kill $_pid && wait $_pid || kill -9 $_pid"
  done
  exit
}

relocate_config() {
  echo "Check for new config directories..."

  if [ ! -d /config/in ]; then
    echo " - Input directory not found, creating"
    mkdir -p /config/in
  fi

  if [ ! -d /config/out ]; then
    echo " - Output directory not found, creating"
    mkdir -p /config/out
  fi

  echo "Check for files in old configuration directory (will be moved to input directory)"
  if [ -e /config/powerwall.ini ]; then
    echo " - Found powerwall.ini, moving to input directory"
    mv /config/powerwall.ini /config/in/powerwall.ini
  fi

  if [ -e /config/pvoutput.ini ]; then
    echo " - Found pvoutput.ini, moving to input directory"
    mv /config/pvoutput.ini /config/in/pvoutput.ini
  fi

  if [ -d /config/logs ]; then
    echo " - Found logs direcotry, moving to input directory"
    mv /config/logs /config/in/logs
  fi
}

# store enviroment variables
export > /etc/envvars

PATH=/opt/openjdk-13/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
JAVA_HOME=/opt/openjdk-13

relocate_config

if [ "$TZ" == "" ]; then
  echo "TZ undefined, assuming UTC"
  TZ="UTC"
fi

cp "/usr/share/zoneinfo/$TZ" /etc/localtime
echo $TZ > /etc/timezone

# run all scripts in the run_once folder
/bin/run-parts /etc/run_once

exec env - PATH=$PATH runsvdir -P /etc/service &

RUNSVDIR=$!
echo "Started runsvdir, PID is $RUNSVDIR"
echo "wait for processes to start...."

sleep 5
for _srv in $(ls -1 /etc/service); do
    sv status $_srv
done

# catch shutdown signals
trap shutdown SIGTERM SIGHUP SIGQUIT SIGINT
tail -f /config/in/logs/* /config/out/logs/*
wait $RUNSVDIR

shutdown

