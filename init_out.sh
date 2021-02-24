#!/bin/sh

CONFIG_DIR="/config/out"
APP_DIR="/usr/src/app/out"

if [ ! -e $CONFIG_DIR/powerwall.ini ]; then
	cp $APP_DIR/conf/powerwall.ini.orig $CONFIG_DIR/powerwall.ini
fi

if [ ! -e $CONFIG_DIR/pvoutput.ini ]; then
	cp $APP_DIR/conf/pvoutput.ini.orig $CONFIG_DIR/pvoutput.ini
fi

if [ ! -d $CONFIG_DIR/logs ]; then
	mkdir $CONFIG_DIR/logs
fi

cd $CONFIG_DIR 

chown -R 99:100 .
chmod -R 777 .

cd $APP_DIR/bin

sh pvoutput.sh

while [ 1 ]; do
	sleep 1
	
done
