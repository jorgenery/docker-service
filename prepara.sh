#!/bin/bash

# ========================================
# SCRIPT DE INICIALIZAÇÃO - DOCKER SERVICES
# ========================================
# Cria estrutura de diretórios e permissões

set -e

echo "📁 Criando estrutura de diretórios..."

# Core services
mkdir -p ./core/data/{traefik,portainer}
mkdir -p ./core/proxy

# Database services
mkdir -p ./database/data/{postgres,redis}
mkdir -p ./database/backups

# Automation services
mkdir -p ./automation/data/n8n

# Analytics services
mkdir -p ./analytics/data/metabase

# AI services
mkdir -p ./ai/data/ollama

# Apps services
mkdir -p ./apps/data/openclaw

# Monitoring services
mkdir -p ./monitoring/data/{loki,promtail,prometheus}

# Data Science services
mkdir -p ./data-science/data/{jupyter,airflow/{dags,logs,plugins}}

# Landing page
mkdir -p ./landing-page/data

# Database services (MongoDB)
mkdir -p ./database/data/mongodb
mkdir -p ./database/backups

# ========================================
# PERMISSÕES
# ========================================
echo "🔒 Configurando permissões..."

# Traefik ACME
touch ./core/proxy/acme.json
chmod 600 ./core/proxy/acme.json

# PostgreSQL
chmod 700 ./database/data/postgres

# Redis
chmod 700 ./database/data/redis

# Loki
chmod 755 ./monitoring/data/loki

echo "✅ Estrutura criada com sucesso!"
echo ""
echo "📋 PRÓXIMOS PASSOS:"
echo "1. Copie o arquivo .env.example para .env"
echo "   cp .env.example .env"
echo ""
echo "2. Configure as variáveis de ambiente no arquivo .env"
echo ""
echo "3. Inicie os containers (exemplo):"
echo "   docker-compose -f docker-compose.yml \\"
echo "     -f core/docker-compose.yml \\"
echo "     -f database/docker-compose.yml \\"
echo "     -f automation/docker-compose.yml \\"
echo "     -f analytics/docker-compose.yml \\"
echo "     -f ai/docker-compose.yml \\"
echo "     -f apps/docker-compose.yml \\"
echo "     -f monitoring/docker-compose.yml \\"
echo "     up -d"
echo ""
echo "4. Ou use o script 'start.sh' para simplificar"
