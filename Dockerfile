FROM openjdk:13-alpine

WORKDIR /usr/src/app

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.10/community" >> /etc/apk/repositories \
	&& apk --update upgrade \
	&& apk add curl bash runit tzdata \
	&& curl -sLO https://bitbucket.org/pvoutput/pvoutput-integration-service/downloads/org.pvoutput.integration.v1.5.5.1.zip \
	&& apk del curl \
	&& rm -rf /var/cache/apk/* 

COPY *.sh ./
RUN chmod +x *.sh 
RUN /usr/src/app/unpack.sh

# RUN mkdir -p in out \
# 	&& cd in \
# 	&& unzip ../*.zip \
# 	&& rm -rf src \
# 	&& mkdir -p /config/logs \
# 	&& mv conf/powerwall.ini conf/powerwall.ini.orig \
# 	&& mv conf/pvoutput.ini conf/pvoutput.ini.orig \
# 	&& ln -sf /config/in/powerwall.ini /usr/src/app/in/conf/ \
# 	&& ln -sf /config/in/pvoutput.ini /usr/src/app/in/conf/ \
# 	&& rmdir logs \
# 	&& ln -sf /config/in/logs /usr/src/app/in/logs \
# 	&& mkdir -p /etc/run_once \
# 	&& mkdir -p /etc/service/pvoutput.in \
# 	&& ln -s /usr/src/app/init_in.sh /etc/service/pvoutput.in/run \
# 	&& cd ..

# RUN cd out \
# 	&& unzip ../*.zip \
# 	&& rm -rf ../*.zip src \
# 	&& mkdir -p /config/logs \
# 	&& mv conf/powerwall.ini conf/powerwall.ini.orig \
# 	&& mv conf/pvoutput.ini conf/pvoutput.ini.orig \
# 	&& ln -sf /config/out/powerwall.ini /usr/src/app/out/conf/ \
# 	&& ln -sf /config/out/pvoutput.ini /usr/src/app/out/conf/ \
# 	&& rmdir logs \
# 	&& ln -sf /config/out/logs /usr/src/app/out/logs \
# 	&& mkdir -p /etc/run_once \
# 	&& mkdir -p /etc/service/pvoutput.out \
# 	&& ln -s /usr/src/app/init_out.sh /etc/service/pvoutput.out/run \
# 	&& cd .. 

# # USER nobody

CMD [ "sh" , "boot.sh" ]
