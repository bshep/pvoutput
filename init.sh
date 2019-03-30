#!/bin/sh
	
if [ ! -e /config/powerwall.ini ]; then
	cp /usr/src/app/conf/powerwall.ini.orig /config/powerwall.ini
fi

if [ ! -e /config/pvoutput.ini ]; then
	cp /usr/src/app/conf/pvoutput.ini.orig /config/pvoutput.ini
fi

if [ ! -d /config/logs ]; then
	mkdir /config/logs
fi

cd /config 

chown -R 99:100 .
chmod -R 777 .

cd /usr/src/app/bin

sh pvoutput.sh

while [ 1 ]; do
	sleep 1
	
done
