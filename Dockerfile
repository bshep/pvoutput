FROM openjdk:13-alpine

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY *.zip ./

RUN unzip *.zip
# If you are building your code for production
# RUN npm install --only=production

# Bundle app source
COPY init.sh .
COPY boot.sh .

# RUN apt-get update && apt-get install -y \
#     rsync \
#  && rm -rf /var/lib/apt/lists/* \
#  && mkdir -p /downloads /config \
#  && ln -s /config/config.js /usr/src/app/node_modules/put.io-sync/config.js \
#  && deluser -q nobody \
#  && useradd -Ms /bin/bash -u 99 -g 100 nobody \
#  && chown -R 99:100 /usr/src/app

RUN mkdir -p /config/logs \
	&& mv conf/powerwall.ini conf/powerwall.ini.orig && mv conf/pvoutput.ini conf/pvoutput.ini.orig \
	&& ln -sf /config/powerwall.ini /usr/src/app/conf/ \
	&& ln -sf /config/pvoutput.ini /usr/src/app/conf/ \
	&& rmdir logs && ln -sf /config/logs /usr/src/app/logs 
# 	&& deluser nobody \
# 	&& adduser -Ds /bin/sh -u 99 -G users nobody \
# 	&& chown -R 99:100 /usr/src/app


RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.7/community" >> /etc/apk/repositories  && \
    apk --update upgrade && \
    apk add bash runit tzdata && \
    rm -rf /var/cache/apk/* && \
    chmod +x boot.sh && \
    mkdir -p /etc/run_once && \
	mkdir -p /etc/service/pvoutput && \
	ln -s /usr/src/app/init.sh /etc/service/pvoutput/run 
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
