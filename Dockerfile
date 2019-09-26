FROM quay.io/ukhomeofficedigital/nodejs-base:v8

# Configure nginx
RUN yum install -y epel-release
RUN yum install -y nginx nginx-all-modules
# unpacks data over /etc and /usr/share/nginx
RUN rm -rf /etc/nginx
COPY conf/root.tgz /root.tgz
RUN cd /;tar -xvf root.tgz

# Configure supervisor.d
RUN yum install -y supervisor
COPY conf/supervisord.conf /etc/supervisor/supervisord.conf

# Unpack mongo-charts distribution
RUN mkdir /tgz-parts
COPY tgz-parts/* /tgz-parts/
RUN cd /tgz-parts/; cat * > /mongo-charts-modified.tgz
RUN cd /;tar -xf mongo-charts-modified.tgz
RUN rm -rf /tgz-parts
COPY charts-cli.js /mongodb-charts/bin/charts-cli.js
COPY entrypoint.sh /entrypoint.sh

RUN groupadd -r app -g 1000 && \
    useradd -r -g app -u 1000 app -d /app && \
    mkdir -p /app && \
    mkdir -p /mongodb-charts/volumes/keys/ && \
    chown -R app:app /mongodb-charts

USER 1000

EXPOSE 80
EXPOSE 8080
ENTRYPOINT [ "/entrypoint.sh" ]
