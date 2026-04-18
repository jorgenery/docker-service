# 📊 VERSÕES E ESPECIFICAÇÕES

## Containers Utilizados

### Core Services

| Serviço | Imagem | Versão | Porta | Descrição |
|---------|--------|--------|-------|-----------|
| **Traefik** | traefik | 3.6 | 80, 443 | Reverse proxy com SSL automático |
| **Portainer** | portainer/portainer-ce | latest | 9000 | Gerenciador visual de containers |

### Database Services

| Serviço | Imagem | Versão | Porta | Descrição |
|---------|--------|--------|-------|-----------|
| **PostgreSQL** | postgres | 16-alpine | 5432 | Banco de dados relacional |
| **Redis** | redis | 7-alpine | 6379 | Cache em memória |
| **MongoDB** | mongo | 7-jammy | 27017 | Banco de dados NoSQL |

### Landing Page

| Serviço | Imagem | Versão | Porta | Descrição |
|---------|--------|--------|-------|-----------|
| **Nginx** | nginx | alpine | 80 | Servidor web para landing page |

### Data Science Services

| Serviço | Imagem | Versão | Porta | Descrição |
|---------|--------|--------|-------|-----------|
| **JupyterLab** | jupyter/scipy-notebook | latest | 8888 | Ambiente de desenvolvimento interativo |
| **Airflow Webserver** | apache/airflow | 2.8.1-python3.11 | 8080 | Interface web do Airflow |
| **Airflow Scheduler** | apache/airflow | 2.8.1-python3.11 | - | Orquestrador de tarefas |

### Automation Services

| Serviço | Imagem | Versão | Porta | Descrição |
|---------|--------|--------|-------|-----------|
| **n8n** | n8n | latest | 5678 | Automação de workflows |

### Analytics Services

| Serviço | Imagem | Versão | Porta | Descrição |
|---------|--------|--------|--------|-----------|
| **Metabase** | metabase/metabase | latest | 3000 | BI e análise de dados |

### AI/ML Services

| Serviço | Imagem | Versão | Porta | Descrição |
|---------|--------|--------|-------|-----------|
| **Ollama** | ollama/ollama | latest | 11434 | Inferência de LLM local |

### Apps Services

| Serviço | Imagem | Versão | Porta | Descrição |
|---------|--------|--------|-------|-----------|
| **OpenClaw** | openclaw | latest | 3001 | Aplicação customizada |

### Monitoring Services

| Serviço | Imagem | Versão | Porta | Descrição |
|---------|--------|--------|-------|-----------|
| **Prometheus** | prom/prometheus | latest | 9090 | Coleta e armazenamento de métricas |
| **Loki** | grafana/loki | latest | 3100 | Armazenamento de logs |
| **Promtail** | grafana/promtail | latest | 9080 | Coletor de logs |
| **Grafana** | grafana/grafana | latest | 3000 | Visualização de métricas |
| **Node Exporter** | prom/node-exporter | latest | 9100 | Métricas do sistema host |
| **cAdvisor** | gcr.io/cadvisor/cadvisor | latest | 8080 | Métricas dos containers |

---

## Requisitos de Recursos

### Mínimos (Desenvolvimento)
- CPU: 2 cores
- RAM: 4 GB
- Disco: 20 GB

### Recomendados (Produção)
- CPU: 4+ cores
- RAM: 16 GB
- Disco: 100+ GB

### Por Serviço

| Serviço | CPU | RAM | Disco | Notas |
|---------|-----|-----|-------|-------|
| Traefik | 0.5 | 256MB | 100MB | Baixo consumo |
| Portainer | 0.5 | 512MB | 500MB | Leve |
| PostgreSQL | 1-2 | 2-4GB | 50GB+ | Maior consumo |
| Redis | 0.5 | 512MB | 10GB | Em memória |
| n8n | 1-2 | 1-2GB | 5GB | Depende de workflows |
| Metabase | 1 | 1-2GB | 10GB | Análises podem crescer |
| Ollama | 2-4 | 4-8GB | 20GB+ | GPU opcional |
| Loki | 0.5 | 512MB | 20GB+ | Depende do volume de logs |
| Promtail | 0.5 | 256MB | 100MB | Leve |
| Grafana | 0.5 | 512MB | 2GB | Leve |

---

## Compatibilidade

### Sistemas Operacionais Suportados
- ✅ Linux (Ubuntu 18.04+, Debian 10+, CentOS 7+)
- ✅ macOS (10.15+)
- ✅ Windows (10/11 com WSL2 ou Docker Desktop)

### Versões Docker
- ✅ Docker >= 20.10
- ✅ Docker Compose >= 2.0 (ou `docker-compose` 1.29+)

### Navegadores (Para UIs)
- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+

---

## Features por Serviço

### Traefik v3.6
- [x] Reverse proxy HTTP/HTTPS
- [x] SSL/TLS automático (Let's Encrypt)
- [x] Roteamento por hostname
- [x] Health checks
- [x] Dashboard API
- [x] Métricas Prometheus
- [x] Middleware (rate limiting, auth, etc)

### PostgreSQL 16
- [x] Full-text search
- [x] JSON/JSONB
- [x] Particionamento nativo
- [x] Replicação logical
- [x] Backup incremental
- [x] VACUUM automático

### Redis 7
- [x] Persistence (AOF/RDB)
- [x] Replicação
- [x] Clustering
- [x] Streams
- [x] Modules support
- [x] ACL (Access Control List)

### n8n (Latest)
- [x] 400+ integrações
- [x] Workflows visuais
- [x] REST API
- [x] Webhooks
- [x] Credenciais encriptadas
- [x] Agendamento
- [x] Error handling

### Metabase (Latest)
- [x] SQL editor nativo
- [x] Dashboards interativos
- [x] Visualizações múltiplas
- [x] Alertas
- [x] Segmentação
- [x] Permissões granulares
- [x] Dados em cache

### Ollama (Latest)
- [x] Modelos locais: Llama 2, Mistral, Neural Chat
- [x] REST API
- [x] Multi-GPU support (Nvidia)
- [x] Fast inference
- [x] Conversational models

### Grafana (Latest)
- [x] Dashboards customizáveis
- [x] Alertas em tempo real
- [x] Múltiplas data sources
- [x] Variáveis e templates
- [x] RBAC (Role-Based Access Control)
- [x] Plugins

### Loki (Latest)
- [x] Log aggregation escalável
- [x] LogQL query language
- [x] Rótulos para filtragem
- [x] Retenção configurável
- [x] Performance otimizada

---

## Upgrade Paths

### Upgrade Traefik
```bash
# Seu docker-compose.yml usa `image: traefik:v3.6`
# Para atualizar, altere para uma versão mais recente
# Exemplo: traefik:v3.7
image: traefik:v3.7

docker-compose -f core/docker-compose.yml up -d --pull always
```

### Upgrade PostgreSQL
```bash
# IMPORTANTE: Fazer backup antes!
./backup.sh

# Atualizar imagem
# image: postgres:16-alpine → postgres:17-alpine

# Upgrade da base de dados
docker exec postgresql pg_upgrade --check
docker-compose -f database/docker-compose.yml up -d --pull always
```

### Upgrade n8n
```bash
# Desabilitar auto-updates em produção
# Atualizar manualmente em horário de baixa demanda

docker-compose -f automation/docker-compose.yml pull
docker-compose -f automation/docker-compose.yml up -d
```

---

## Limitações Conhecidas

### Redis
- Não é persistente por padrão (use `appendonly yes`)
- Limite de memória configurável
- Sem clustering nativo (requer Cluster edition)

### PostgreSQL
- Replicação nativa limitada sem ferramentas externas
- Backup grande para bases muito volumosas

### n8n
- Não tem suporte nativo a WebSocket longos
- Workflows muito complexos podem causar timeout

### Ollama
- Requer muita RAM/GPU para modelos grandes
- Download inicial de modelos é lento
- Sem suporte a quantização automática

### Metabase
- Performance degradada com muitos dashboards
- Queries muito complexas podem ser lentas
- Sem cache distribuído nativo

---

## Performance Benchmarks (Aproximados)

### Traefik
- Throughput: ~10k req/s
- Latência: <1ms
- Memória: ~50-100MB

### PostgreSQL
- Throughput: ~5-10k TPS (transações/s)
- Query simples: <5ms
- Memória: Configurável (1-4GB recomendado)

### Redis
- Throughput: ~100k ops/s
- Latência: <1ms
- Memória: ~500MB-2GB

### n8n
- Workflows simultâneos: ~10-20
- Tempo de execução: Depende do workflow
- Memória: ~1-2GB

### Metabase
- Queries: ~100-500ms
- Dashboard renderização: ~1-3s
- Memória: ~1-2GB

### Ollama
- Inference latency: 1-10s (depende do modelo)
- Throughput: 1-5 reqs/s simultâneos
- Memória: 2-8GB (depende do modelo)

---

## Licenças

- **Traefik**: Apache 2.0
- **Portainer**: Zlib
- **PostgreSQL**: PostgreSQL License
- **Redis**: BSD 3-Clause
- **n8n**: Fair Code (Community free, Enterprise pago)
- **Metabase**: Elastic/Commercial
- **Ollama**: MIT
- **Grafana**: AGPL 3.0 (Community), Comercial
- **Loki**: AGPL 3.0

Consulte os sites oficiais para detalhes sobre uso comercial.
