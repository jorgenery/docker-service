#!/bin/bash

#!/bin/bash

# ========================================
# SCRIPT: STOP.SH
# ========================================
# Para todos os containers

echo "🛑 Parando todos os containers..."
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Função para parar um serviço com tratamento de erro
stop_service() {
    local service_name=$1
    local compose_file=$2

    echo -e "${YELLOW}Parando $service_name...${NC}"
    if docker-compose --env-file .env -f "$compose_file" down 2>/dev/null; then
        echo -e "${GREEN}✅ $service_name parado com sucesso${NC}"
    else
        echo -e "${RED}❌ Erro ao parar $service_name (continuando...)${NC}"
    fi
    echo ""
}

# Para em ordem reversa da inicialização
stop_service "Data Science (JupyterLab + Airflow)" "data-science/docker-compose.yml"
stop_service "Apps (OpenClaw)" "apps/docker-compose.yml"
stop_service "AI (Ollama)" "ai/docker-compose.yml"
stop_service "Analytics (Metabase)" "analytics/docker-compose.yml"
stop_service "Automation (n8n)" "automation/docker-compose.yml"
stop_service "Landing Page" "landing-page/docker-compose.yml"
stop_service "Monitoring (Prometheus + Grafana + Loki)" "monitoring/docker-compose.yml"
stop_service "Database (PostgreSQL + Redis + MongoDB)" "database/docker-compose.yml"
stop_service "Core (Traefik + Portainer)" "core/docker-compose.yml"

echo -e "${GREEN}✅ Processo de parada concluído!${NC}"
echo ""
echo "📊 Status final dos containers:"
docker ps --format "table {{.Names}}\t{{.Status}}" 2>/dev/null || echo -e "${YELLOW}Não foi possível obter status dos containers${NC}"
docker ps --format "table {{.Names}}\t{{.Status}}"
