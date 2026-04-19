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
chmod 755 ./*.sh

# ========================================
# BUILD DE IMAGENS
# ========================================
echo "🔨 Reconstruindo imagens Docker..."

# Função para fazer build de imagens custom
build_images() {
  echo "📦 Puxando imagens do registro..."
  
  # Core services
  docker pull traefik:v3.6 || echo "⚠️  Falha ao puxar traefik:v3.6"
  docker pull portainer/portainer-ce:latest || echo "⚠️  Falha ao puxar portainer"
  
  # Database services
  docker pull postgres:16-alpine || echo "⚠️  Falha ao puxar postgres:16-alpine"
  docker pull mongo:7-jammy || echo "⚠️  Falha ao puxar mongo:7-jammy"
  docker pull redis:7-alpine || echo "⚠️  Falha ao puxar redis:7-alpine"
  
  # Automation services
  docker pull n8nio/n8n:latest || echo "⚠️  Falha ao puxar n8n"
  
  # Analytics services
  docker pull metabase/metabase:latest || echo "⚠️  Falha ao puxar metabase"
  
  # AI services
  docker pull ollama/ollama:latest || echo "⚠️  Falha ao puxar ollama"
  
  # Data Science services
  docker pull jupyter/datascience-notebook:latest || echo "⚠️  Falha ao puxar jupyterlab"
  docker pull apache/airflow:2.8.1-python3.11 || echo "⚠️  Falha ao puxar airflow"
  
  # Monitoring services
  docker pull prom/prometheus:latest || echo "⚠️  Falha ao puxar prometheus"
  docker pull grafana/grafana:latest || echo "⚠️  Falha ao puxar grafana"
  docker pull grafana/loki:latest || echo "⚠️  Falha ao puxar loki"
  docker pull grafana/promtail:latest || echo "⚠️  Falha ao puxar promtail"
  docker pull gcr.io/cadvisor/cadvisor:latest || echo "⚠️  Falha ao puxar cadvisor"
  
  # Apps services
  docker pull nginx:alpine || echo "⚠️  Falha ao puxar nginx"
  docker pull alpine/openclaw:latest || echo "⚠️  Falha ao puxar openclaw"
  
  echo "✅ Imagens atualizadas com sucesso!"
}

# Reconstrói imagens custom se houver Dockerfiles
build_custom_images() {
  if [ -f "./apps/Dockerfile" ]; then
    echo "🔨 Construindo imagem custom: apps"
    docker build -t docker-service/apps:latest ./apps || echo "⚠️  Falha ao construir apps"
  fi
  
  if [ -f "./landing-page/Dockerfile" ]; then
    echo "🔨 Construindo imagem custom: landing-page"
    docker build -t docker-service/landing-page:latest ./landing-page || echo "⚠️  Falha ao construir landing-page"
  fi
}

# Executa build
build_images
build_custom_images

echo "✨ Build de imagens concluído!"

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
