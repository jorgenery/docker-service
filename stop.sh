#!/bin/bash

# ========================================
# SCRIPT: STOP.SH
# ========================================
# Para todos os containers

set -e

echo "🛑 Parando todos os containers..."
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Para em ordem reversa da inicialização
docker-compose -f data-science/docker-compose.yml down
docker-compose -f apps/docker-compose.yml down
docker-compose -f ai/docker-compose.yml down
docker-compose -f analytics/docker-compose.yml down
docker-compose -f automation/docker-compose.yml down
docker-compose -f landing-page/docker-compose.yml down
docker-compose -f monitoring/docker-compose.yml down
docker-compose -f database/docker-compose.yml down
docker-compose -f core/docker-compose.yml down

echo ""
echo -e "${GREEN}✅ Todos os containers foram parados!${NC}"
echo ""
docker ps --format "table {{.Names}}\t{{.Status}}"
