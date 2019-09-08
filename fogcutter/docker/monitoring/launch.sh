#!/bin/bash

# Assumes pew-net exists
# Assumes mounted dirs are created as non-root user
# Prometheus + Node Exporter + cAdvisor + Grafana

docker network create pew-monitoring-net

# grafana-cli plugins install grafana-piechart-panel
sudo chown 472:472 $PWD/grafana/{data,provisioning} \
&& \
docker run \
    --name monitoring_grafana \
    --detach \
    --restart unless-stopped \
    --user 472 \
    --volume $PWD/grafana/data:/var/lib/grafana:rw \
    --volume $PWD/grafana/provisioning:/etc/grafana/provisioning:rw \
    --publish 3000:3000 \
    --network pew-monitoring-net \
    grafana/grafana:6.3.5 \
&& \
docker network connect pew-net monitoring_grafana

#    --publish 9090:9090 \
sudo chown nobody:nogroup $PWD/prometheus/data \
&& \
docker run \
    --name monitoring_prometheus \
    --detach \
    --restart unless-stopped \
    --volume $PWD/prometheus/data:/prometheus:rw \
    --volume $PWD/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro \
    --volume $PWD/prometheus/alert.rules:/etc/prometheus/alert.rules:ro \
    --network pew-monitoring-net \
    prom/prometheus:v2.12.0 --config.file=/etc/prometheus/prometheus.yml \
                            --storage.tsdb.path=/prometheus

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
    google/cadvisor:v0.32.0

# alert manager
