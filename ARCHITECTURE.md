# ARQUITETURA DOCKER SERVICES
## Visão Geral da Infraestrutura

```
┌─────────────────────────────────────────────────────────────────┐
│                     INTERNET / USERS                             │
│                      (Externa)                                   │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                      (80 / 443)
                           │
        ┌──────────────────▼──────────────────┐
        │     TRAEFIK (Reverse Proxy)         │
        │  - SSL/TLS Automático               │
        │  - Let's Encrypt                    │
        │  - Roteamento de Hosts              │
        └──────────────────┬──────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        │            PUBLIC_NET               │
        │        (Bridge Network)             │
        │                  │                  │
  ┌─────▼──────┐  ┌──────▼────────┐  ┌──────▼───────┐
  │  Portainer │  │      n8n      │  │   Metabase   │
  │  (9000)    │  │    (5678)     │  │   (3000)     │
  │            │  │               │  │              │
  │Management  │  │  Workflows    │  │  Analytics   │
  └─────┬──────┘  └──────┬────────┘  └──────┬───────┘
        │                │                  │
        │         ┌──────┼──────┐           │
        │         │   INTERNAL_NET      │
        │         │  (Bridge Network)   │
        │         │                     │
  ┌─────┴─────────┴──┬────────────────┬─┴──────────────┐
  │                  │                │                │
  │        ┌─────────▼────────┐   ┌───▼─────┐  ┌──────▼────────┐
  │        │   PostgreSQL     │   │  Redis  │  │    Ollama     │
  │        │     (5432)       │   │ (6379) │  │   (11434)     │
  │        │                  │   │        │  │               │
  │        │   Databases:     │   │ Cache/ │  │ LLM Models    │
  │        │   - maindb       │   │ Queue  │  │ Inference     │
  │        │   - n8n          │   │        │  │               │
  │        │   - metabase     │   │        │  │               │
  │        └────────┬─────────┘   └───┬────┘  └──────┬────────┘
  │                 │                 │              │
  │                 └─────────────────┼──────────────┘
  │                                   │
  └─────────────────────────┬─────────┘
                            │
                      ┌─────▼─────────────┐
                      │   OpenClaw        │
                      │   (3001)          │
                      │                   │
                      │  Custom App       │
                      │  (Example)        │
                      └─────┬─────────────┘
                            │
            ┌───────────────┼───────────────┐
            │               │               │
       ┌────▼──────┐  ┌─────▼──────┐  ┌───▼─────────┐
       │   Loki    │  │ Promtail   │  │  Grafana    │
       │  (3100)   │  │            │  │  (3000)     │
       │           │  │ Log Scraper│  │             │
       │ Log DB    │  │            │  │ Visualization
       └────┬──────┘  └─────┬──────┘  │ & Alerting  │
            │              │         └─────────────┘
            └──────────────┴──────┘
                 MONITORING STACK
```

## 📊 Componentes por Camada

### 🔌 Camada de Ingresso (Entrypoint)
- **Traefik**: Reverse proxy, roteamento, SSL/TLS

### 🔐 Camada de Gerenciamento
- **Portainer**: Dashboard visual de containers

### 💾 Camada de Dados
- **PostgreSQL**: Banco de dados relacional (15GB limite recomendado)
- **Redis**: Cache em memória + Message Queue

### ⚙️ Camada de Aplicações
- **n8n**: Automação de workflows
- **Metabase**: BI e análise de dados
- **OpenClaw**: Aplicação customizada
- **Ollama**: Inferência de modelos LLM

### 👁️ Camada de Observabilidade
- **Grafana**: Dashboard de métricas e logs
- **Loki**: Armazenamento de logs
- **Promtail**: Coleta de logs de containers

## 🌐 Fluxo de Dados

### Requisição HTTP/HTTPS
```
Usuário → Traefik → Aplicação (n8n/Metabase/etc) → PostgreSQL/Redis
```

### Logs
```
Containers → Promtail → Loki → Grafana (Visualização)
```

### Automação
```
n8n Trigger → Query PostgreSQL → Redis Cache → Webhook Response
```

## 🔗 Dependências Entre Serviços

```
Traefik ─────┐
             │
             ├─→ Portainer
             │
             ├─→ PostgreSQL ─┐
             │               ├─→ n8n
             ├─→ Redis ──────┤
             │               ├─→ Metabase
             ├─→ Ollama ─────┤
             │               └─→ OpenClaw
             │
             ├─→ Loki ───────┐
             │               ├─→ Grafana
             └─→ Promtail ───┘
```

## 💾 Volumes Persistentes

```
docker-service/
├── core/
│   ├── data/
│   │   └── portainer/        (Dados do Portainer)
│   └── proxy/
│       └── acme.json         (Certificados Let's Encrypt)
│
├── database/
│   ├── data/
│   │   ├── postgres/         (Banco de dados)
│   │   └── redis/           (Cache)
│   └── backups/             (Backups do PostgreSQL)
│
├── automation/
│   └── data/
│       └── n8n/             (Workflows e credenciais)
│
├── analytics/
│   └── data/
│       └── metabase/        (Configuração e cache)
│
├── ai/
│   └── data/
│       └── ollama/          (Modelos de IA)
│
├── apps/
│   └── data/
│       └── openclaw/        (Dados da aplicação)
│
└── monitoring/
    └── data/
        ├── loki/            (Banco de logs)
        └── promtail/        (Cache)
```

## 🔒 Isolamento de Rede

### public_net (Bridge)
- Conectada ao Traefik
- Serviços: Portainer, n8n, Metabase, Grafana
- Acessível externamente (via Traefik)

### internal_net (Bridge)
- Não conectada à internet
- Serviços: PostgreSQL, Redis, Ollama, Loki, Promtail
- Apenas comunicação interna

## 📈 Escalabilidade

### Horizontal (Múltiplas Instâncias)
- n8n pode ser escalado (requer Postgres)
- Metabase pode ser escalado (requer Postgres)

### Vertical (Mais Recursos)
- PostgreSQL: Aumentar memória e storage
- Redis: Aumentar memória (maxmemory)
- Ollama: Mais VRAM/GPU se disponível

## 🚀 Performance

### Otimizações Implementadas
- Health checks em todos os serviços
- Restart policy: unless-stopped
- PostgreSQL: 9.6 conectados por pool
- Redis: persistence habilitada
- Grafana: cache habilitado

### Monitoramento
- Métrica de CPU/Memória por container
- Logs centralizados via Loki
- Dashboard Grafana para visualização

## 🔄 Backup & Disaster Recovery

### Estratégia
1. Backup diário do PostgreSQL (7 dias retenção)
2. Volumes nomeados para persistência
3. Snapshots de volumes (se necessário)

### Comandos
```bash
./backup.sh              # Fazer backup
./restore.sh backup.sql  # Restaurar
```

## 🎯 Caso de Uso Completo

**Exemplo: Automação com n8n + Análise com Metabase**

```
1. n8n Trigger (Webhook/Schedule)
   ↓
2. Query dados via API
   ↓
3. Salvar em PostgreSQL
   ↓
4. Cache em Redis
   ↓
5. Metabase consulta dados
   ↓
6. Grafana mostra resultado em Dashboard
   ↓
7. Alertas via Grafana (se configurado)
```
