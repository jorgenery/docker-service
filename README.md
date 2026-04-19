# Docker Services - Documentação

## 📋 Estrutura do Projeto

```
docker-service/
├── core/                      # Reverse Proxy (Traefik) + Management (Portainer)
│   ├── docker-compose.yml
│   ├── traefik.yml
│   ├── proxy/
│   │   └── acme.json         # Certificados Let's Encrypt
│   └── data/
│       └── portainer/        # Dados do Portainer
│
├── database/                  # Databases
│   ├── docker-compose.yml
│   └── data/
│       ├── postgres/         # PostgreSQL
│       ├── redis/           # Redis
│       └── mongodb/         # MongoDB
│
├── landing-page/             # Landing Page
│   ├── docker-compose.yml
│   ├── nginx.conf
│   └── data/
│       └── index.html       # Página inicial
│
├── data-science/             # Data Science & ML
│   ├── docker-compose.yml
│   └── data/
│       ├── jupyter/         # Jupyter notebooks
│       └── airflow/         # Airflow DAGs, logs, plugins
│
├── automation/               # Workflow Automation
│   ├── docker-compose.yml
│   └── data/
│       └── n8n/             # n8n workflows
│
├── analytics/               # Business Intelligence
│   ├── docker-compose.yml
│   └── data/
│       └── metabase/        # Metabase data
│
├── ai/                      # AI/ML Services
│   ├── docker-compose.yml
│   └── data/
│       └── ollama/          # Ollama models
│
├── apps/                    # Custom Applications
│   ├── docker-compose.yml
│   └── data/
│       └── openclaw/        # OpenClaw data
│
├── monitoring/              # Observability Stack
│   ├── docker-compose.yml
│   ├── loki-config.yml
│   ├── promtail-config.yml
│   ├── prometheus.yml
│   └── data/
│       ├── loki/           # Loki data
│       ├── promtail/       # Promtail cache
│       └── prometheus/     # Prometheus data
│
├── .env.example            # Variáveis de ambiente (template)
├── docker-compose.yml      # Orquestração principal
├── prepara.sh              # Setup inicial
├── start.sh                # Inicia todos os containers
├── stop.sh                 # Para todos os containers
├── status.sh               # Mostra status
└── logs.sh                 # Exibe logs
```

## 🚀 Início Rápido

### 1. Preparação Inicial

```bash
# Execute o script de setup
bash prepara.sh

# Crie o arquivo .env com suas configurações
cp .env.example .env

# Edite o .env com seus dados
nano .env
```

### 2. Variáveis de Ambiente Essenciais

```env
# Domínios
DOMINIO=datareview.com.br
EMAILSECURE=admin@datareview.com.br

# PostgreSQL
POSTGRES_USER=postgres
POSTGRES_PASSWORD=senha_segura_123

# Redis
REDIS_PASSWORD=senha_redis_123

# n8n
N8N_HOST=n8n.datareview.com.br

# Metabase
METABASE_ADMIN_EMAIL=admin@datareview.com.br
METABASE_ADMIN_PASSWORD=senha_metabase_123
METABASE_HOST=metabase.datareview.com.br
```

### 3. Iniciar Containers

**Opção 1 - Script automático (recomendado):**
```bash
bash start.sh
```

**Opção 2 - Comando manual:**
```bash
docker-compose -f core/docker-compose.yml \
               -f database/docker-compose.yml \
               -f automation/docker-compose.yml \
               -f analytics/docker-compose.yml \
               -f ai/docker-compose.yml \
               -f apps/docker-compose.yml \
               -f monitoring/docker-compose.yml \
               up -d
```

## 🔧 Uso Diário

### Iniciar/Parar Serviços

```bash
# Iniciar tudo
bash start.sh

# Parar tudo
bash stop.sh

# Status de todos os containers
bash status.sh

# Ver logs
bash logs.sh                    # Todos
bash logs.sh postgresql         # Específico
```

### Gerenciar Serviços Individuais

```bash
# Iniciar apenas uma stack
docker-compose -f database/docker-compose.yml up -d

# Parar apenas uma stack
docker-compose -f automation/docker-compose.yml down

# Reinicar um container
docker-compose -f core/docker-compose.yml restart portainer
```

## 🌐 Acessar Serviços

| Serviço | URL | Porta |
|---------|-----|-------|
| **Traefik** | https://painel.datareview.com.br | 80, 443 |
| **Portainer** | https://portainer.datareview.com.br | 9000 |
| **Grafana** | https://monitor.datareview.com.br | 3000 |
| **n8n** | https://n8n.datareview.com.br | 5678 |
| **Metabase** | https://metabase.datareview.com.br | 3000 |
| **Ollama** | http://localhost:11434 | 11434 |
| **PostgreSQL** | localhost:5432 | 5432 |
| **Redis** | localhost:6379 | 6379 |

## 🐳 Containers Disponíveis

### Core
- **Traefik** (v3.6) - Reverse proxy com SSL/TLS automático
- **Portainer** - Gerenciador visual de containers

### Database
- **PostgreSQL** (16) - Banco de dados relacional
- **Redis** (7) - Cache e message broker

### Automation
- **n8n** - Plataforma de automação de workflows

### Analytics
- **Metabase** - BI e análise de dados

### AI/ML
- **Ollama** - Inferência de LLM local

### Apps
- **OpenClaw** - Aplicação customizada

### Monitoring
- **Loki** - Banco de logs
- **Promtail** - Coletor de logs
- **Grafana** - Visualização de métricas

## 📊 Redes Docker

Existem duas redes internas:
- **public_net** - Para serviços acessíveis externamente (via Traefik)
- **internal_net** - Para serviços internos (database, cache, etc)

## 🔒 Segurança

1. **Senhas Padrão**: Altere todas as senhas em `.env`
2. **SSL/TLS**: Configurado automaticamente via Let's Encrypt
3. **Acesso**: Serviços internos não expostos na internet
4. **Backups**: Configure backups do PostgreSQL regularmente

## 🆘 Troubleshooting

### Container não inicia
```bash
# Ver logs detalhados
docker logs nome_container

# Verificar health
docker ps | grep nome_container

# Reiniciar
docker-compose restart nome_container
```

### Erro de conexão entre containers
```bash
# Verificar redes
docker network ls
docker network inspect public_net

# Testar conectividade
docker-compose exec container1 ping container2
```

### PostgreSQL não conecta
```bash
# Ver se está rodando
docker-compose -f database/docker-compose.yml ps postgresql

# Verificar logs
docker logs postgresql

# Conectar ao container
docker exec -it postgresql psql -U postgres
```

### Certificado Let's Encrypt expirado
```bash
# Remover certificado antigo
rm core/proxy/acme.json

# Reiniciar traefik
docker-compose -f core/docker-compose.yml restart traefik
```

## 📚 Links Úteis

- [Traefik Documentation](https://doc.traefik.io/)
- [Portainer Documentation](https://docs.portainer.io/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Redis Documentation](https://redis.io/documentation)
- [n8n Documentation](https://docs.n8n.io/)
- [Metabase Documentation](https://www.metabase.com/docs/)
- [Ollama Documentation](https://github.com/ollama/ollama)
- [Grafana Documentation](https://grafana.com/docs/)

## 📝 Licenças

Cada serviço tem sua própria licença - consulte os repositórios oficiais.
