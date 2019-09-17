FROM quay.io/mongodb/charts:19.09

RUN groupadd -r app -g 2000 && \
    useradd -r -g app -u 2000 app -d /app && \
    mkdir -p /app && \
    mkdir -p /mongodb-charts/volumes/keys/ && \
    chown -R app:app /mongodb-charts

USER 2000

