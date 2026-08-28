# 📚 Índice de Documentação

## 🚀 Comece por aqui

1. **[QUICKSTART.md](./QUICKSTART.md)** - 30 segundos para começar (recomendado primeiro)
2. **[SETUP_GUIDE.md](./SETUP_GUIDE.md)** - Guia completo passo a passo
3. **[README.md](./README.md)** - Visão geral e referência rápida

## 📋 Documentação Detalhada

- **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Arquitetura da infraestrutura
- **[VERSIONS.md](./VERSIONS.md)** - Versões, requisitos e compatibilidade
- **[TROUBLESHOOTING.md](./TROUBLESHOOTING.md)** - Problemas e soluções

## 🛠️ Ferramentas e Scripts

| Script | Função |
|--------|--------|
| `prepara.sh` | Criar estrutura de diretórios |
| `start.sh` | Iniciar todos os containers |
| `stop.sh` | Parar todos os containers |
| `status.sh` | Ver status dos serviços |
| `logs.sh` | Exibir logs |
| `backup.sh` | Fazer backup do PostgreSQL |
| `restore.sh` | Restaurar backup |
| `health-check.sh` | Verificar saúde dos serviços |

## 📁 Estrutura de Diretórios Criada

```
docker-service/
├── 📖 Documentação
│   ├── README.md              ← Comece aqui
│   ├── QUICKSTART.md          ← 30 segundos
│   ├── SETUP_GUIDE.md         ← Configuração completa
│   ├── ARCHITECTURE.md        ← Arquitetura técnica
│   ├── VERSIONS.md            ← Versões e compatibilidade
│   ├── TROUBLESHOOTING.md     ← Problemas e soluções
│   └── INDEX.md               ← Este arquivo
│
├── 🔧 Scripts
│   ├── prepara.sh
│   ├── start.sh
│   ├── stop.sh
│   ├── status.sh
│   ├── logs.sh
│   ├── backup.sh
│   ├── restore.sh
│   ├── health-check.sh
│   └── Makefile
│
├── ⚙️ Configuração
│   ├── .env.example
│   ├── .env                   (criar via: cp .env.example .env)
│   ├── docker-compose.yml     (orquestração)
│   └── .gitignore
│
├── 🌐 CORE (Reverse Proxy + Management)
│   ├── docker-compose.yml
│   ├── traefik.yml
│   ├── proxy/
│   │   └── acme.json         (certificados Let's Encrypt)
│   └── data/
│       ├── traefik/
│       └── portainer/
│
├── 💾 DATABASE (PostgreSQL + Redis)
│   ├── docker-compose.yml
│   ├── data/
│   │   ├── postgres/
│   │   └── redis/
│   └── backups/
│       └── backup_*.sql
│
├── ⚙️ AUTOMATION (n8n)
│   ├── docker-compose.yml
│   └── data/
│       └── n8n/
│
├── 📊 ANALYTICS (Metabase)
│   ├── docker-compose.yml
│   └── data/
│       └── metabase/
│
├── 🤖 AI (Ollama)
│   ├── docker-compose.yml
│   └── data/
│       └── ollama/
│
├── 📱 APPS (OpenClaw)
│   ├── docker-compose.yml
│   └── data/
│       └── openclaw/
│
└── 📈 MONITORING (Loki + Promtail + Grafana)
    ├── docker-compose.yml
    ├── loki-config.yml
    ├── promtail-config.yml
    └── data/
        ├── loki/
        └── promtail/
```

## 🐳 Containers Organizados por Função

### Reverse Proxy & Management (Core)
- ✅ **Traefik** - Reverse proxy com SSL automático
- ✅ **Portainer** - Gerenciador visual

### Dados (Database)
- ✅ **PostgreSQL** - Banco relacional
- ✅ **Redis** - Cache

### Automação (Automation)
- ✅ **n8n** - Workflows

### Inteligência de Negócios (Analytics)
- ✅ **Metabase** - BI

### IA/ML (AI)
- ✅ **Ollama** - LLM local

### Aplicações (Apps)
- ✅ **OpenClaw** - Seu app customizado (openclaw agents add main)
- openclaw config set defaultModel "ollama/mistral"
- openclaw config set channels.telegram.groupAllowFrom '["SEU_TELEGRAM_USER_ID"]'
- openclaw pairing list
- openclaw pairing approve 344711698
- openclaw pairing approve telegram 9A6YEHXJ
- openclaw config set gateway.trustedProxies '["172.19.0.1", "172.19.0.2", "172.19.0.14", "172.19.0.17", "127.0.0.1"]'

### Observabilidade (Monitoring)
- ✅ **Loki** - Armazenamento de logs
- ✅ **Promtail** - Coletor de logs
- ✅ **Grafana** - Visualização

**Total: 11 containers organizados em 7 grupos**

## 🚀 Próximos Passos Recomendados

### 1️⃣ Leitura Rápida
```bash
cat QUICKSTART.md          # 2 minutos
```

### 2️⃣ Setup Inicial
```bash
bash prepara.sh            # Criar diretórios
cp .env.example .env       # Configurar
nano .env                  # Editar com suas configurações
```

### 3️⃣ Iniciar Containers
```bash
bash start.sh              # Ou: make start
```

### 4️⃣ Verificar
```bash
bash status.sh             # Ou: make status
```

### 5️⃣ Acessar Serviços
```
https://portainer.datareview.com.br      (Portainer)
https://monitor.datareview.com.br     (Grafana)
https://n8n.datareview.com.br         (n8n)
https://metabase.datareview.com.br    (Metabase)
```

## 💡 Dicas

- **Makefile**: Se tiver `make` instalado, use `make help`
- **Bash scripts**: Funcionam em Linux, Mac e Windows (com WSL2)
- **Primeiro acesso**: Parar containers inicialmente com `make stop`
- **Segurança**: Alterar TODAS as senhas em `.env` antes de produção
- **Backup**: Executar `./backup.sh` regularmente

## 📞 Ajuda Rápida

```bash
# Ver status
make status                 # ou: bash status.sh

# Ver logs
make logs                   # ou: bash logs.sh

# Fazer backup
make backup                 # ou: bash backup.sh

# Health check
make health                 # ou: bash health-check.sh

# Parar tudo
make stop                   # ou: bash stop.sh
```

## 📚 Documentação Relacionada

- [Traefik Docs](https://doc.traefik.io/traefik/)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Redis Docs](https://redis.io/documentation/)
- [n8n Docs](https://docs.n8n.io/)
- [Metabase Docs](https://www.metabase.com/docs/)
- [Ollama GitHub](https://github.com/ollama/ollama)
- [Grafana Docs](https://grafana.com/docs/grafana/)

---

**Versão**: 1.0  
**Última atualização**: Abril 2026  
**Status**: ✅ Pronto para usar
