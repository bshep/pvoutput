FROM openjdk:13-alpine

WORKDIR /usr/src/app

COPY *.sh ./

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.7/community" >> /etc/apk/repositories \
	&& apk --update upgrade \
	&& apk add curl bash runit tzdata \
	&& curl -sLO https://bitbucket.org/pvoutput/pvoutput-integration-service/downloads/org.pvoutput.integration.v1.5.4.1.zip \
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

# # USER nobody

CMD [ "sh" , "boot.sh" ]
