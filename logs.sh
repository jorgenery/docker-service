#!/bin/bash

# ========================================
# SCRIPT: LOGS.SH
# ========================================
# Exibe logs de todos os containers

echo "📋 Logs dos containers"
echo ""
echo "Use: ./logs.sh [container_name]"
echo ""
echo "Containers disponíveis:"
echo "  - traefik"
echo "  - portainer"
echo "  - postgresql"
echo "  - redis"
echo "  - mongodb"
echo "  - landing-page"
echo "  - n8n"
echo "  - metabase"
echo "  - jupyterlab"
echo "  - airflow-webserver"
echo "  - airflow-scheduler"
echo "  - ollama"
echo "  - openclaw"
echo "  - prometheus"
echo "  - loki"
echo "  - promtail"
echo "  - grafana"
echo "  - node-exporter"
echo "  - cadvisor"
echo ""

if [ -z "$1" ]; then
    echo "Mostrando logs de todos os containers:"
    docker-compose -f core/docker-compose.yml \
                   -f database/docker-compose.yml \
                   -f landing-page/docker-compose.yml \
                   -f automation/docker-compose.yml \
                   -f analytics/docker-compose.yml \
                   -f data-science/docker-compose.yml \
                   -f ai/docker-compose.yml \
                   -f apps/docker-compose.yml \
                   -f monitoring/docker-compose.yml \
                   logs -f
else
    echo "Mostrando logs de: $1"
    docker logs -f "$1"
fi
