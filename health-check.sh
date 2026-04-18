#!/bin/bash

# ========================================
# SCRIPT: HEALTH_CHECK.SH
# ========================================
# Verifica saúde de todos os containers

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🏥 Health Check - Docker Services"
echo "=================================="
echo ""

HEALTHY=0
UNHEALTHY=0

# Função para verificar container
check_container() {
    local name=$1
    local port=$2
    local expected_status=$3
    
    local status=$(docker inspect --format='{{.State.Status}}' "$name" 2>/dev/null || echo "not found")
    
    if [ "$status" == "running" ]; then
        echo -e "${GREEN}✅${NC} $name: Running"
        ((HEALTHY++))
    elif [ "$status" == "exited" ]; then
        echo -e "${RED}❌${NC} $name: Stopped"
        ((UNHEALTHY++))
    else
        echo -e "${YELLOW}⚠️${NC} $name: Not found"
        ((UNHEALTHY++))
    fi
}

# Verificar containers principais
check_container "traefik" "80"
check_container "portainer" "9000"
check_container "postgresql" "5432"
check_container "redis" "6379"
check_container "n8n" "5678"
check_container "metabase" "3000"
check_container "ollama" "11434"
check_container "openclaw" "3001"
check_container "loki" "3100"
check_container "promtail" ""
check_container "grafana" "3000"

echo ""
echo "📊 Resumo:"
echo -e "   ${GREEN}Saudáveis: $HEALTHY${NC}"
echo -e "   ${RED}Problemas: $UNHEALTHY${NC}"

if [ $UNHEALTHY -eq 0 ]; then
    echo -e "${GREEN}✅ Todos os serviços estão saudáveis!${NC}"
else
    echo -e "${RED}⚠️ Alguns serviços precisam de atenção${NC}"
fi
