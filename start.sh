#!/bin/bash

# ========================================
# SCRIPT: START.SH
# ========================================
# Inicia todos os containers em ordem correta

set -e

echo "🚀 Iniciando Docker Services..."
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar se .env existe
if [ ! -f .env ]; then
    echo -e "${RED}❌ Arquivo .env não encontrado!${NC}"
    echo "   Execute: cp .env.example .env"
    echo "   E configure as variáveis de ambiente"
    exit 1
fi

# Criar redes externas
echo -e "${YELLOW}📡 Criando redes Docker...${NC}"
docker network create public_net 2>/dev/null || true
docker network create internal_net 2>/dev/null || true

# 1. Core (Traefik + Portainer)
echo -e "${YELLOW}1️⃣  Iniciando Core (Traefik + Portainer)...${NC}"
docker-compose -f core/docker-compose.yml up -d

# 2. Database (PostgreSQL + Redis + MongoDB)
echo -e "${YELLOW}2️⃣  Iniciando Database (PostgreSQL + Redis + MongoDB)...${NC}"
docker-compose -f database/docker-compose.yml up -d
sleep 10

# 3. Monitoring (Prometheus + Loki + Promtail + Grafana + Node Exporter + cAdvisor)
echo -e "${YELLOW}3️⃣  Iniciando Monitoring (Prometheus + Loki + Promtail + Grafana)...${NC}"
docker-compose -f monitoring/docker-compose.yml up -d

# 4. Landing Page
echo -e "${YELLOW}4️⃣  Iniciando Landing Page...${NC}"
docker-compose -f landing-page/docker-compose.yml up -d

# 5. Automation (n8n)
echo -e "${YELLOW}5️⃣  Iniciando Automation (n8n)...${NC}"
docker-compose -f automation/docker-compose.yml up -d

# 6. Analytics (Metabase)
echo -e "${YELLOW}6️⃣  Iniciando Analytics (Metabase)...${NC}"
docker-compose -f analytics/docker-compose.yml up -d

# 7. AI (Ollama)
echo -e "${YELLOW}7️⃣  Iniciando AI (Ollama)...${NC}"
docker-compose -f ai/docker-compose.yml up -d

# 8. Apps (OpenClaw)
echo -e "${YELLOW}8️⃣  Iniciando Apps (OpenClaw)...${NC}"
docker-compose -f apps/docker-compose.yml up -d

# 9. Data Science (JupyterLab + Airflow)
echo -e "${YELLOW}9️⃣  Iniciando Data Science (JupyterLab + Airflow)...${NC}"
docker-compose -f data-science/docker-compose.yml up -d

echo ""
echo -e "${GREEN}✅ Todos os containers foram iniciados!${NC}"
echo ""
echo "📊 Status dos containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""
echo "🌐 URLs de acesso (após configurar domínios):"
echo "   - Landing:   https://${DOMINIO}"
echo "   - Portainer: https://painel.${DOMINIO}"
echo "   - Grafana:   https://monitor.${DOMINIO}"
echo "   - Prometheus: https://prometheus.${DOMINIO}"
echo "   - n8n:       https://${N8N_HOST}"
echo "   - Metabase:  https://${METABASE_HOST}"
echo "   - JupyterLab: https://${JUPYTER_HOST}"
echo "   - Airflow:   https://${AIRFLOW_HOST}"
echo "   - Ollama:    https://ollama.${DOMINIO}"
echo "   - OpenClaw:  https://${OPENCLAW_HOST}"
echo ""
echo "📖 Para ver logs: ./logs.sh"
echo "🛑 Para parar: ./stop.sh"
