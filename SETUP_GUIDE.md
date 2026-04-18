# 🚀 GUIA DE SETUP DETALHADO

## Pré-requisitos

- Docker >= 20.10
- Docker Compose >= 2.0
- Acesso SSH/Terminal
- Domínio registrado (opcional, para produção)
- 8GB RAM mínimo (recomendado 16GB)
- 50GB espaço em disco

## Passo 1: Clone/Prepare o Repositório

```bash
# Navegue até o diretório
cd /caminho/para/docker-service

# Se estiver em um repositório Git
git clone seu-repo-url
cd docker-service
```

## Passo 2: Preparar o Ambiente

```bash
# Execute o script de preparação
bash prepara.sh

# Saída esperada:
# 📁 Criando estrutura de diretórios...
# 🔒 Configurando permissões...
# ✅ Estrutura criada com sucesso!
```

## Passo 3: Configurar Variáveis de Ambiente

```bash
# Copie o arquivo de exemplo
cp .env.example .env

# Abra e edite o arquivo
nano .env
# ou
vim .env
# ou
code .env

# Campos obrigatórios a editar:
# DOMINIO=seu-dominio-real.com
# EMAILSECURE=seu-email@dominio.com
# POSTGRES_PASSWORD=senha_muito_segura_123
# REDIS_PASSWORD=outra_senha_segura_456
```

### Exemplo de .env configurado:

```env
# DOMÍNIOS
DOMINIO=meuservidor.com
EMAILSECURE=admin@meuservidor.com

# ENDEREÇOS
N8N_HOST=n8n.meuservidor.com
METABASE_HOST=metabase.meuservidor.com
OPENCLAW_HOST=app.meuservidor.com

# CREDENCIAIS BANCO DE DADOS
POSTGRES_USER=postgres
POSTGRES_PASSWORD=MuySen@2024!Postgres
POSTGRES_DB=maindb

# CREDENCIAIS REDIS
REDIS_PASSWORD=MuySen@2024!Redis

# CREDENCIAIS APLICAÇÕES
METABASE_ADMIN_EMAIL=admin@meuservidor.com
METABASE_ADMIN_PASSWORD=MuySen@2024!Metabase
GRAFANA_PASSWORD=MuySen@2024!Grafana

# TIMEZONE
TZ=America/Sao_Paulo
```

## Passo 4: Configurar DNS (Para Produção)

Se for usar em produção com domínio real:

1. Acesse seu registrador de domínio (GoDaddy, Namecheap, etc)
2. Configure o tipo de registro **A**:
   - Hostname: `@` (raiz)
   - Value: `seu-ip-do-servidor`
   - TTL: 3600 (padrão)

3. Configure wildcard (opcional, para subdomínios):
   - Hostname: `*.datareview.com.br`
   - Value: `seu-ip-do-servidor`

4. Adicione registros específicos:
   ```
   painel        → seu-ip
   n8n           → seu-ip
   metabase      → seu-ip
   monitor       → seu-ip
   ```

5. Aguarde 24-48 horas para propagação DNS

## Passo 5: Configurar Firewall

### UFW (Ubuntu/Debian)

```bash
# Permitir SSH
sudo ufw allow 22/tcp

# Permitir HTTP
sudo ufw allow 80/tcp

# Permitir HTTPS
sudo ufw allow 443/tcp

# Ativar firewall
sudo ufw enable

# Verificar status
sudo ufw status
```

### Para Windows Firewall

- Pesquisar por "Windows Defender Firewall"
- Permitir acesso nas portas 80 e 443

## Passo 6: Iniciar Containers

### Primeira Inicialização (Com Logs)

```bash
# Crie as redes externas
docker network create public_net
docker network create internal_net

# Inicie cada serviço e aguarde estar saudável
docker-compose -f core/docker-compose.yml up

# Em outra janela, inicie database
docker-compose -f database/docker-compose.yml up

# Aguarde ~30 segundos

# Em outra janela, inicie o resto
docker-compose -f monitoring/docker-compose.yml up
docker-compose -f automation/docker-compose.yml up
docker-compose -f analytics/docker-compose.yml up
docker-compose -f ai/docker-compose.yml up
docker-compose -f apps/docker-compose.yml up
```

### Inicialização em Background (Normal)

```bash
# Use o script preparado
bash start.sh

# Ou comando manual
docker-compose -f core/docker-compose.yml \
               -f database/docker-compose.yml \
               -f automation/docker-compose.yml \
               -f analytics/docker-compose.yml \
               -f ai/docker-compose.yml \
               -f apps/docker-compose.yml \
               -f monitoring/docker-compose.yml \
               up -d
```

## Passo 7: Verificar Status

```bash
# Ver todos containers
docker ps

# Ver status dos serviços
bash status.sh

# Saudável = todas as linhas verdes:
# CONTAINER ID     IMAGE                    STATUS           PORTS
# abc123...        traefik:v3.6            Up 2 minutes     0.0.0.0:80->80/tcp
# def456...        postgres:16-alpine      Up 2 minutes     0.0.0.0:5432->5432/tcp
```

## Passo 8: Testar Conectividade

### Teste de rede local

```bash
# Testar Traefik
curl -i http://localhost

# Testar n8n (sem HTTPS)
curl -i http://localhost:5678

# Testar PostgreSQL
docker exec postgresql psql -U postgres -c "\l"

# Testar Redis
docker exec redis redis-cli -a seu-redis-password ping
```

### Teste de domínio (após DNS configurado)

```bash
# Aguardar propagação DNS (até 48h)
nslookup datareview.com.br

# Testar acesso
curl -i https://datareview.com.br

# Testar subdomínio
curl -i -H "Host: n8n.datareview.com.br" https://datareview.com.br
```

## Passo 9: Configurar Aplicações

### Portainer
1. Acessar: `https://painel.datareview.com.br`
2. Criar usuário admin na primeira execução
3. Conectar ao Docker daemon local

### PostgreSQL
```bash
# Criar banco de dados customizado
docker exec postgresql createdb -U postgres seu-novo-banco

# Conectar ao banco
docker exec -it postgresql psql -U postgres -d seu-novo-banco
```

### n8n
1. Acessar: `https://n8n.datareview.com.br`
2. Criar usuário admin
3. Começar a criar workflows

### Metabase
1. Acessar: `https://metabase.datareview.com.br`
2. Fazer login com credenciais do .env
3. Conectar ao PostgreSQL
4. Criar dashboards

### Grafana
1. Acessar: `https://monitor.datareview.com.br`
2. Fazer login (admin/grafana123)
3. Adicionar Loki como data source: `http://loki:3100`
4. Importar dashboards

## Passo 10: Configurar Backup Automático

### Linux/Mac (Cron)

```bash
# Editar crontab
crontab -e

# Adicionar linhas:
# Backup diário às 2:00 AM
0 2 * * * cd /caminho/para/docker-service && bash backup.sh

# Limpeza de logs antigos, semanalmente
0 3 * * 0 docker system prune -a -f
```

### Windows (Task Scheduler)

1. Abrir Task Scheduler
2. Criar tarefa básica
3. Trigger: Diário às 2:00 AM
4. Action: 
   ```
   Program: powershell.exe
   Arguments: -File "C:\path\to\backup.ps1"
   ```

## Passo 11: Monitoramento

### Alertas Grafana

1. Acessar Grafana
2. Ir para Alerting → Notification Channels
3. Adicionar: Email, Slack, PagerDuty, etc
4. Criar Alert Rules para métricas críticas

### Health Check

```bash
# Executar verificação
bash health-check.sh

# Ou agendar com cron (a cada 30 minutos)
*/30 * * * * cd /caminho/docker-service && bash health-check.sh >> health-check.log 2>&1
```

## Troubleshooting Pós-Setup

### Certificado não é emitido

```bash
# Verificar logs
docker logs traefik | grep -i "acme\|certificate"

# Validar DNS (deve retornar seu IP)
nslookup datareview.com.br

# Verificar firewall (porta 80 acessível?)
curl -v http://datareview.com.br
```

### Containers não conseguem se comunicar

```bash
# Testar ping
docker exec n8n ping postgresql

# Testar porta
docker exec n8n nc -zv postgresql 5432

# Verificar se estão na mesma rede
docker network inspect internal_net | grep "Containers"
```

### Falta de memória

```bash
# Ver uso atual
docker stats

# Se necessário, aumentar limites no docker-compose.yml
# E depois fazer restart

# Limpar espaço
docker system prune -a --volumes
```

## Próximas Etapas

- [ ] Agendar backups automáticos
- [ ] Configurar alertas no Grafana
- [ ] Testar restore de backup
- [ ] Documentar configurações customizadas
- [ ] Configurar CI/CD se aplicável
- [ ] Planejar disaster recovery
- [ ] Revisar logs regularmente

## Suporte

Para problemas:
1. Consulte [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)
2. Verifique [ARCHITECTURE.md](./ARCHITECTURE.md)
3. Consulte documentação oficial dos projetos

