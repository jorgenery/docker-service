# ⚡ QUICKSTART

## 30 segundos para começar

```bash
# 1. Preparar diretórios
bash prepara.sh

# 2. Configurar variáveis
cp .env.example .env
# Edite .env com suas configurações (especialmente senhas!)

# 3. Iniciar
bash start.sh

# 4. Verificar status
bash status.sh
```

## Acessar Serviços

Após ~2-3 minutos:

| Serviço | URL | Login |
|---------|-----|-------|
| Portainer | https://portainer.datareview.com.br | Criar na primeira vez |
| Grafana | https://monitor.datareview.com.br | admin / grafana123 |
| n8n | https://n8n.datareview.com.br | Criar na primeira vez |
| Metabase | https://metabase.datareview.com.br | admin@... / (do .env) |

## Parar Tudo

```bash
bash stop.sh
```

## Comandos Úteis

```bash
# Ver status
bash status.sh

# Ver logs
bash logs.sh

# Logs específicos
bash logs.sh postgresql

# Backup
bash backup.sh

# Health check
bash health-check.sh
```

## Próximo Passo

Leia [SETUP_GUIDE.md](./SETUP_GUIDE.md) para configuração completa!
