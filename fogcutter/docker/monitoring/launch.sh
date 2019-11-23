#!/bin/bash

# Assumes pew-net exists
# Assumes mounted dirs are created as non-root user
# Prometheus + Node Exporter + cAdvisor + Grafana

docker network create pew-monitoring-net

# grafana-cli plugins install grafana-piechart-panel
sudo chown 472:472 $PWD/grafana/{grafana-data,provisioning} \
&& \
docker run \
    --name monitoring_grafana \
    --detach \
    --restart unless-stopped \
    --env GF_SERVER_DOMAIN="seaturtle.pw" \
    --env GF_SERVER_ROOT_URL="%(protocol)s://%(domain)s/grafana/" \
    --user 472 \
    --volume $PWD/grafana/grafana-data:/var/lib/grafana:rw \
    --volume $PWD/grafana/provisioning:/etc/grafana/provisioning:rw \
    --network pew-monitoring-net \
    grafana/grafana:6.3.7 \
&& \
docker network connect pew-net monitoring_grafana

sudo chown nobody:nogroup $PWD/prometheus/prometheus-data \
&& \
docker run \
    --name monitoring_prometheus \
    --detach \
    --restart unless-stopped \
    --volume $PWD/prometheus/prometheus-data:/prometheus:rw \
    --volume $PWD/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro \
    --volume $PWD/prometheus/alert.rules:/etc/prometheus/alert.rules:ro \
    --network pew-monitoring-net \
    prom/prometheus:v2.14.0 --config.file=/etc/prometheus/prometheus.yml \
                            --storage.tsdb.path=/prometheus \
                            --storage.tsdb.retention.size=200GB

docker run \
    --name monitoring_node-exporter \
    --detach \
    --restart unless-stopped \
    --cap-add SYS_TIME \
    --pid host \
    --volume /:/host:ro,rslave \
    --network pew-monitoring-net \
    quay.io/prometheus/node-exporter:v0.18.1 --path.rootfs=/host

docker run \
    --name monitoring_cadvisor \
    --detach \
    --restart unless-stopped \
    --volume /:/rootfs:ro \
    --volume /var/run:/var/run:ro \
    --volume /sys:/sys:ro \
    --volume /var/lib/docker:/var/lib/docker:ro \
    --volume /dev/disk:/dev/disk:ro \
    --network pew-monitoring-net \
    google/cadvisor:v0.33.0

# alert manager
