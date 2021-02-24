#!/bin/bash

install_to_dir() {
    echo "Making directory: $SERVICE_PREFIX"
    mkdir $SERVICE_PREFIX
    cd $SERVICE_PREFIX

    echo "- Unpacking zip-file"
    unzip -q ../*.zip
    rm -rf src

    echo "- Making Log directory"
    mkdir -p /config/$SERVICE_PREFIX/logs

    echo "- Creating default configs"
    mv conf/powerwall.ini conf/powerwall.ini.orig
    mv conf/pvoutput.ini conf/pvoutput.ini.orig
    ln -sf /config/$SERVICE_PREFIX/powerwall.ini /usr/src/app/$SERVICE_PREFIX/conf/
    ln -sf /config/$SERVICE_PREFIX/pvoutput.ini /usr/src/app/$SERVICE_PREFIX/conf/

    echo "- Setup logs Directory"
    rmdir logs
    ln -sf /config/$SERVICE_PREFIX/logs /usr/src/app/$SERVICE_PREFIX/logs

    echo "- Setup service config files"
    mkdir -p /etc/run_once
    mkdir -p /etc/service/pvoutput.$SERVICE_PREFIX
    ln -s /usr/src/app/init_$SERVICE_PREFIX.sh /etc/service/pvoutput.$SERVICE_PREFIX/run
    cd ..
}



SERVICE_PREFIX="in"
install_to_dir

SERVICE_PREFIX="out"
install_to_dir

rm *.zip unpack.sh