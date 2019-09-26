FROM debian:9.8

RUN apt update
RUN apt install -y apt-transport-https ca-certificates curl gettext-base gnupg iproute2 iputils-ping libssl1.0.2 lsb-release nginx-extras supervisor vim procps

# unpack nginx config over /etc and /usr/share/nginx
RUN rm -rf /etc/nginx
COPY conf/root.tgz /root.tgz
RUN cd /;tar -xvf root.tgz

RUN rm -rf /usr/share/nginx/html
COPY conf/html.tgz /html.tgz
RUN cd /;tar -xvf html.tgz

# original app built for node v10 but this seems to be absolutely fine
RUN curl https://nodejs.org/dist/v8.12.0/node-v8.12.0-linux-x64.tar.gz | tar xz --strip-components=1

# mongo-charts is in a tar file, split into sections to bypass github's 100MB file limit
# reassembly and unpack it into /mongodb-charts
RUN mkdir /tgz-parts
COPY tgz-parts/* /tgz-parts/
RUN cd /tgz-parts/; cat * > /mongo-charts-modified.tgz
RUN cd /;tar -xf mongo-charts-modified.tgz
RUN rm -rf /tgz-parts
COPY charts-cli.js /mongodb-charts/bin/charts-cli.js
COPY entrypoint.sh /entrypoint.sh

# move to tar file later.
COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN groupadd -r app -g 1000 && useradd -r -g app -u 1000 app -d /app && mkdir -p /app
RUN mkdir -p /mongodb-charts/volumes/keys/
RUN mkdir -p /run/secrets/
RUN mkdir -p /var/log/nginx

RUN chown -R app:app /mongodb-charts/volumes/keys/
RUN chown -R app:app /mongodb-charts
RUN chown -R app:app /usr/share/nginx/
RUN chown -R app:app /run/secrets/
RUN chown -R app:app /var/log/nginx/
RUN chown -R app:app /var/lib/nginx/
RUN chown app:app /entrypoint.sh

USER 1000

EXPOSE 80
EXPOSE 8080
ENTRYPOINT [ "/entrypoint.sh" ]
