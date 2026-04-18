.PHONY: help init setup start stop restart status logs backup restore health clean

# Cores para output
YELLOW := \033[0;33m
GREEN := \033[0;32m
RED := \033[0;31m
NC := \033[0m # No Color

help:
	@echo "$(YELLOW)Docker Services - Makefile Commands$(NC)"
	@echo ""
	@echo "$(GREEN)Setup Commands:$(NC)"
	@echo "  make init          - Preparar estrutura de diretórios"
	@echo "  make setup         - Setup completo (init + .env)"
	@echo ""
	@echo "$(GREEN)Docker Commands:$(NC)"
	@echo "  make start         - Iniciar todos os containers"
	@echo "  make stop          - Parar todos os containers"
	@echo "  make restart       - Reiniciar todos"
	@echo "  make status        - Ver status dos containers"
	@echo "  make logs          - Ver logs em tempo real"
	@echo ""
	@echo "$(GREEN)Maintenance:$(NC)"
	@echo "  make backup        - Fazer backup do PostgreSQL"
	@echo "  make health        - Health check dos serviços"
	@echo "  make clean         - Limpar volumes (CUIDADO!)"
	@echo ""
	@echo "$(GREEN)Utilities:$(NC)"
	@echo "  make ps            - Listar containers (resumido)"
	@echo "  make disk          - Ver uso de disco"
	@echo ""

init:
	@echo "$(YELLOW)Executando prepara.sh...$(NC)"
	bash prepara.sh
	@echo "$(GREEN)✅ Estrutura criada!$(NC)"

setup: init
	@echo "$(YELLOW)Criando .env...$(NC)"
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "$(GREEN)✅ Arquivo .env criado$(NC)"; \
		echo "$(RED)⚠️ Edite o arquivo .env com suas configurações!$(NC)"; \
	else \
		echo "$(YELLOW)ℹ️ .env já existe$(NC)"; \
	fi

start:
	@echo "$(YELLOW)Iniciando containers...$(NC)"
	bash start.sh

stop:
	@echo "$(YELLOW)Parando containers...$(NC)"
	bash stop.sh

restart: stop start
	@echo "$(GREEN)✅ Containers reiniciados!$(NC)"

status:
	@echo "$(YELLOW)Status dos containers:$(NC)"
	bash status.sh

logs:
	@echo "$(YELLOW)Exibindo logs...$(NC)"
	bash logs.sh

backup:
	@echo "$(YELLOW)Fazendo backup...$(NC)"
	bash backup.sh

health:
	@echo "$(YELLOW)Health check...$(NC)"
	bash health-check.sh

ps:
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

disk:
	@echo "$(YELLOW)Uso de disco por volume:$(NC)"
	@du -sh ./*/data/* ./database/backups 2>/dev/null | sort -h
	@echo ""
	@echo "$(YELLOW)Resumo geral:$(NC)"
	@docker system df

clean:
	@echo "$(RED)⚠️  CUIDADO: Isso vai deletar TODOS os volumes!$(NC)"
	@read -p "Digite 'sim' para confirmar: " confirm && [ "$$confirm" = "sim" ] && \
		docker-compose down -v && \
		echo "$(GREEN)✅ Volumes deletados!$(NC)" || \
		echo "$(YELLOW)Cancelado$(NC)"

.DEFAULT_GOAL := help
