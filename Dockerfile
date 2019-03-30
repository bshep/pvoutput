FROM openjdk:13-alpine

# Create app directory
WORKDIR /usr/src/app

COPY *.sh .

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.7/community" >> /etc/apk/repositories \
    && apk --update upgrade \
	&& apk add curl bash runit tzdata \
	&& curl -sLO https://bitbucket.org/pvoutput/pvoutput-integration-service/downloads/org.pvoutput.integration.v1.5.4.zip \
	&& unzip *.zip \
	&& rm -rf *.zip src \
	&& mkdir -p /config/logs \
	&& mv conf/powerwall.ini conf/powerwall.ini.orig \
	&& mv conf/pvoutput.ini conf/pvoutput.ini.orig \
	&& ln -sf /config/powerwall.ini /usr/src/app/conf/ \
	&& ln -sf /config/pvoutput.ini /usr/src/app/conf/ \
	&& rmdir logs \
	&& ln -sf /config/logs /usr/src/app/logs \
    && chmod +x *.sh \
    && mkdir -p /etc/run_once \
	&& mkdir -p /etc/service/pvoutput \
	&& ln -s /usr/src/app/init.sh /etc/service/pvoutput/run \
	&& apk del curl \
    && rm -rf /var/cache/apk/* 
	# chmod 777 /etc && \
	# chown -R 99:100 /etc/sv
 
# USER nobody

# WORKDIR bin

# COPY init.sh .

CMD [ "sh" , "boot.sh" ]
#!/bin/bash
#
# 

# java -Djava.library.path=../lib/Linux/i686 -cp ../lib/org.pvoutput.integration.jar:../lib/commons-logging-1.1.1.jar:../lib/httpcore-4.1.2.jar:../lib/httpclient-4.1.2.jar:../lib/jetty-http-7.5.1.v20110908.jar:../lib/jetty-util-7.5.1.v20110908.jar:../lib/jetty-io-7.5.1.v20110908.jar:../lib/jetty-server-7.5.1.v20110908.jar:../lib/jetty-continuation-7.5.1.v20110908.jar:../lib/servlet-api-2.5.jar:../lib/json_simple-1.1.jar:../lib/jxl.jar:../lib/log4j-1.2.15.jar:../lib/RXTXcomm.jar:../lib/jackcess-1.2.2.jar:../lib/bsh-core-2.0b4.jar:../lib/sqlitejdbc-v056.jar:../lib/commons-net-3.1.jar org.pvoutput.integration.Controller $1 $2 $3
