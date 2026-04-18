#!/bin/bash

# ========================================
# SCRIPT: STATUS.SH
# ========================================
# Mostra status de todos os containers

echo "📊 Status dos Containers"
echo "========================"
echo ""

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Core
echo -e "${YELLOW}CORE (Reverse Proxy & Management)${NC}"
docker-compose -f core/docker-compose.yml ps

echo ""
echo -e "${YELLOW}DATABASE (PostgreSQL & Redis)${NC}"
docker-compose -f database/docker-compose.yml ps

echo ""
echo -e "${YELLOW}MONITORING (Loki, Promtail & Grafana)${NC}"
docker-compose -f monitoring/docker-compose.yml ps

echo ""
echo -e "${YELLOW}AUTOMATION (n8n)${NC}"
docker-compose -f automation/docker-compose.yml ps

echo ""
echo -e "${YELLOW}ANALYTICS (Metabase)${NC}"
docker-compose -f analytics/docker-compose.yml ps

echo ""
echo -e "${YELLOW}AI (Ollama)${NC}"
docker-compose -f ai/docker-compose.yml ps

echo ""
echo -e "${YELLOW}LANDING PAGE${NC}"
docker-compose -f landing-page/docker-compose.yml ps

echo ""
echo -e "${YELLOW}DATA SCIENCE (JupyterLab & Airflow)${NC}"
docker-compose -f data-science/docker-compose.yml ps

echo ""
echo "📊 Resumo geral:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"
