# GUIA DE TROUBLESHOOTING - Docker Services

## 🔴 Problemas Comuns

### 1. Container não inicia

**Sintomas:**
- Container aparece em `docker ps` como "Exited (1)" ou similar
- Container desaparece após alguns segundos

**Diagnóstico:**
```bash
# Ver logs completos
docker logs nome_container

# Ver últimas 50 linhas
docker logs --tail 50 nome_container

# Seguir logs em tempo real
docker logs -f nome_container
```

**Soluções Comuns:**

#### PostgreSQL não inicia
```bash
# Verificar permissões
ls -la database/data/postgres

# Se houver problema de permissão
chmod 700 database/data/postgres

# Se o banco está corrompido, recrie
rm -rf database/data/postgres
mkdir -p database/data/postgres
docker-compose -f database/docker-compose.yml up postgresql
```

#### n8n não se conecta ao PostgreSQL
```bash
# Verificar se PostgreSQL está pronto
docker exec postgresql pg_isready -U postgres

# Testar conexão manualmente
docker exec -it n8n psql -h postgresql -U postgres -d n8n

# Ver variáveis de ambiente
docker inspect n8n | grep -A 20 "Env"
```

---

### 2. Erro de porta já em uso

**Sintomas:**
```
Error response from daemon: Ports are not available: exposing port TCP 0.0.0.0:5432 -> 0.0.0.0:5432: listen tcp 0.0.0.0:5432: bind: An attempt was made to use a port in a state that does not allow its use.
```

**Solução:**
```bash
# Encontrar processo usando a porta (Linux/Mac)
lsof -i :5432

# Encontrar processo usando a porta (Windows PowerShell)
Get-Process -Id (Get-NetTCPConnection -LocalPort 5432 -ErrorAction SilentlyContinue).OwningProcess

# Parar container anterior
docker stop postgresql
docker rm postgresql

# Ou mudar porta no docker-compose.yml
# Alterar: ports: - "5432:5432"
# Para:    ports: - "5433:5432"
```

---

### 3. Erro de memória (Out of Memory)

**Sintomas:**
- Container morre periodicamente
- Logs mostram "Killed" ou "OOMKilled"

**Solução:**
```bash
# Adicionar limites de memória no docker-compose.yml
services:
  postgresql:
    deploy:
      resources:
        limits:
          memory: 2G
        reservations:
          memory: 1G
```

---

### 4. Traefik não roteia para aplicação

**Sintomas:**
- Acessar domínio retorna "404 Not Found"
- Certificado SSL está OK
- Container está rodando

**Diagnóstico:**
```bash
# Ver logs do Traefik
docker logs traefik

# Ver configuração do Traefik
docker exec traefik traefik config

# Verificar se labels estão corretos
docker inspect n8n | grep -i traefik

# Testar roteamento
curl -H "Host: n8n.datareview.com.br" http://localhost/

# Ver acesso direto
curl http://localhost:5678  # Para n8n
```

**Checklist:**
- [ ] Container está na mesma rede que Traefik
- [ ] Labels estão corretos no docker-compose
- [ ] Domínio está apontando para o servidor
- [ ] Firewall permite tráfego nas portas 80/443
- [ ] TRAEFIK_ENABLE=true nas labels

---

### 5. Certificado Let's Encrypt não é gerado

**Sintomas:**
- Acessar HTTPS retorna erro de certificado
- acme.json está vazio

**Solução:**
```bash
# Limpar certificado antigo
rm core/proxy/acme.json

# Reiniciar Traefik
docker-compose -f core/docker-compose.yml restart traefik

# Aguardar renovação (pode levar minutos)
docker logs -f traefik | grep -i "certificate"

# Se erro persiste, verificar:
# 1. Email correto em .env
# 2. Domínio apontando para servidor (DNS)
# 3. Porta 80 acessível externamente
# 4. Rate limits do Let's Encrypt não atingidos
```

---

### 6. Erro de conectividade entre containers

**Sintomas:**
- n8n não consegue conectar ao PostgreSQL
- "connection refused" ou "getaddrinfo ENOTFOUND postgresql"

**Diagnóstico:**
```bash
# Verificar redes
docker network ls
docker network inspect internal_net

# Testar ping entre containers
docker exec n8n ping postgresql

# Testar conectividade TCP
docker exec n8n nc -zv postgresql 5432

# Ver logs do container origem
docker logs --tail 20 n8n | grep -i "connection\|error"
```

**Solução:**
```bash
# Verificar se ambos containers estão na mesma rede
docker network inspect internal_net | grep -i "containers"

# Se não estiver, adicionar:
docker network connect internal_net n8n

# Reiniciar containers
docker-compose -f automation/docker-compose.yml restart n8n
```

---

### 7. Disco cheio / storage issues

**Sintomas:**
- Docker-compose não inicia containers
- "no space left on device"

**Diagnóstico:**
```bash
# Ver espaço em disco
df -h

# Ver tamanho dos volumes Docker
docker system df

# Ver tamanho específico do volume
du -sh database/data/postgres
du -sh monitoring/data/loki
```

**Solução:**
```bash
# Limpar imagens não usadas
docker image prune -a

# Limpar containers parados
docker container prune

# Limpar volumes órfãos
docker volume prune

# Limpar tudo (cuidado!)
docker system prune -a
```

---

### 8. PostgreSQL cresce muito

**Sintomas:**
- Arquivo database/data/postgres/base/* muito grande
- Servidor rodando lentamente

**Solução:**
```bash
# Fazer VACUUM no banco
docker exec postgresql vacuumdb -U postgres -d maindb -v -z

# Fazer ANALYZE
docker exec postgresql analyzedb -U postgres -d maindb

# Ver tamanho das tabelas
docker exec postgresql psql -U postgres -d maindb -c "\db+"

# Deletar dados antigos (exemplo)
docker exec postgresql psql -U postgres -d maindb -c "DELETE FROM logs WHERE created_at < now() - interval '90 days';"
```

---

### 9. Redis está muito grande

**Sintomas:**
- database/data/redis/dump.rdb muito grande

**Solução:**
```bash
# Conectar ao Redis
docker exec -it redis redis-cli -a redis123

# Dentro do Redis CLI:
> INFO memory           # Ver uso de memória
> DBSIZE               # Ver quantidade de chaves
> FLUSHDB              # Limpar banco atual
> FLUSHALL             # Limpar todos os bancos

# Sair: CTRL+C ou "exit"
```

---

### 10. Ollama não funciona / modelos lentos

**Sintomas:**
- Timeout ao usar Ollama
- Modelos não carregam

**Solução:**
```bash
# Verificar se Ollama está rodando
curl http://localhost:11434/api/tags

# Puxar modelo (exemplo: mistral)
docker exec ollama ollama pull mistral

# Ver logs
docker logs -f ollama

# Para máquinas com GPU (Nvidia)
# Descomente a seção deploy no ai/docker-compose.yml
```

---

## 📋 Checklist de Verificação

### Antes de colocar em produção:

- [ ] Arquivo `.env` configurado com senhas seguras
- [ ] Domínios apontando para servidor (DNS)
- [ ] Firewall permite portas 80 e 443
- [ ] Backup automático configurado (`crontab`)
- [ ] Monitoramento e alertas configurados
- [ ] Certificados SSL gerados e válidos
- [ ] Limites de recursos configurados
- [ ] Logs centralizados e funcionando
- [ ] Repositório Git com commits diários

### Operacional:

- [ ] Scripts de backup testados
- [ ] Rotina de limpeza de disco configurada
- [ ] Health checks configurados
- [ ] Alertas de CPU/Memória funcionando
- [ ] Plano de disaster recovery documentado

---

## 🆘 Quando Nada Funciona

### 1. Reiniciar tudo do zero

```bash
# Para tudo
./stop.sh

# Remove todos os containers
docker-compose down

# Remove volumes (CUIDADO - perderá dados!)
docker-compose down -v

# Inicia novamente
./start.sh
```

### 2. Verificar logs do sistema

```bash
# Docker daemon logs
docker info

# Ver eventos
docker events --filter "status=error"

# Check docker
docker system prune --volumes
```

### 3. Buscar ajuda

```bash
# Coletar informações para troubleshooting
docker ps -a
docker images
docker network ls
docker volume ls
docker system df
```

---

## 📞 Recursos de Ajuda

- **Traefik**: https://doc.traefik.io/traefik/
- **PostgreSQL**: https://www.postgresql.org/docs/
- **Redis**: https://redis.io/documentation/
- **n8n**: https://docs.n8n.io/
- **Metabase**: https://www.metabase.com/docs/
- **Docker**: https://docs.docker.com/
- **Grafana**: https://grafana.com/docs/

---

## 💡 Dicas Úteis

### Aliases Bash

```bash
# Adicione ao seu .bashrc ou .zshrc

alias docker-ps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias docker-logs='docker logs -f'
alias docker-exec='docker exec -it'

# Docker Compose
alias dc='docker-compose'
alias dcup='docker-compose up -d'
alias dcdown='docker-compose down'
alias dclogs='docker-compose logs -f'
```

### Monitoramento em tempo real

```bash
# Usar watch para monitorar containers
watch -n 1 'docker ps --format "table {{.Names}}\t{{.CPUPerc}}\t{{.MemUsage}}"'
```

### Teste de carga simples

```bash
# Para Traefik/website
ab -n 100 -c 10 https://datareview.com.br/

# Para n8n
curl -i https://seu-n8n.com/api/v1/me
```
