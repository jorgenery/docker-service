#!/bin/bash

# ========================================
# SCRIPT: RESTORE.SH
# ========================================
# Restaura backup do PostgreSQL

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

if [ -z "$1" ]; then
    echo "❌ Uso: ./restore.sh <arquivo_backup.sql>"
    echo ""
    echo "Backups disponíveis:"
    ls -lh ./database/backups/*.sql 2>/dev/null | awk '{print "   - " $NF}' || echo "   Nenhum backup encontrado"
    exit 1
fi

BACKUP_FILE="$1"
DB_USER=${POSTGRES_USER:-postgres}

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Arquivo não encontrado: $BACKUP_FILE"
    exit 1
fi

echo "⚠️  ATENÇÃO: Este processo irá sobrescrever o banco de dados!"
read -p "   Tem certeza? (s/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "❌ Operação cancelada"
    exit 1
fi

echo ""
echo "📥 Restaurando backup..."
echo "   Arquivo: $BACKUP_FILE"
echo "   Data: $(date)"
echo ""

# Restaurar backup
docker exec -i postgresql psql -U $DB_USER < "$BACKUP_FILE"

echo ""
echo "✅ Restauração concluída com sucesso!"
