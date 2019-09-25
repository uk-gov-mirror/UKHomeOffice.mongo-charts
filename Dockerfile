FROM quay.io/ukhomeofficedigital/nodejs-base:v8

RUN mkdir /tgz-parts
COPY tgz-parts/* /tgz-parts/
RUN cd /tgz-parts/; cat * > /mongo-charts-modified.tgz
RUN cd /;tar -xf mongo-charts-modified.tgz
RUN rm -rf /tgz-parts

RUN groupadd -r app -g 1000 && \
    useradd -r -g app -u 1000 app -d /app && \
    mkdir -p /app && \
    mkdir -p /mongodb-charts/volumes/keys/ && \
    chown -R app:app /mongodb-charts

USER 1000

EXPOSE 80
EXPOSE 8080
CMD /mongodb-charts/bin/charts-cli start
