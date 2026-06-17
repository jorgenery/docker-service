#!/bin/bash

# ========================================
# SCRIPT: BACKUP.SH
# ========================================
# Realiza backup do PostgreSQL

set -e

# Carregar variáveis de ambiente
if [ -f .env ]; then
    set -a
    source .env
    set +a
else
    echo "❌ Arquivo .env não encontrado!"
    exit 1
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./database/backups"
DB_NAME=${POSTGRES_DB:-maindb}
DB_USER=${POSTGRES_USER:-postgres}

mkdir -p "$BACKUP_DIR"

echo "💾 Iniciando backup do PostgreSQL..."
echo "   Data: $(date)"
echo ""

# Fazer backup
docker exec postgresql pg_dump -U $DB_USER $DB_NAME > "$BACKUP_DIR/backup_${DB_NAME}_${TIMESTAMP}.sql"

echo "✅ Backup realizado com sucesso!"
echo "   Arquivo: $BACKUP_DIR/backup_${DB_NAME}_${TIMESTAMP}.sql"
echo ""

# Manter apenas os últimos 7 backups
echo "🧹 Limpando backups antigos..."
ls -t "$BACKUP_DIR"/backup_*.sql | tail -n +8 | xargs -r rm

echo "✅ Limpeza concluída!"
ls -lh "$BACKUP_DIR"/backup_*.sql | head -5
