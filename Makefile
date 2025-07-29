# Colors for output
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m # No Color

# Docker compose file path
COMPOSE_FILE = srcs/docker-compose.yml

# Project name
PROJECT_NAME = inception

.PHONY: all build up down clean fclean re logs ps

# Default target
all: build up

# Build all Docker images
build:
	@echo "$(YELLOW)Building Docker images...$(NC)"
	docker compose -f $(COMPOSE_FILE) build

# Build and start all services
up: build
	@echo "$(GREEN)Starting all services...$(NC)"
	docker compose -f $(COMPOSE_FILE) up -d
	@echo "$(GREEN) All services are running!$(NC)"
	@echo "$(GREEN) Access your site at: https://subpark.42.fr$(NC)"

# Stop all services
down:
	@echo "$(YELLOW)Stopping all services...$(NC)"
	docker compose -f $(COMPOSE_FILE) down
	@echo "$(GREEN) All services stopped$(NC)"

# Clean up containers and networks
clean: down
	@echo "$(YELLOW)Cleaning up containers and networks...$(NC)"
	docker system prune -f
	@echo "$(GREEN) Cleanup completed$(NC)"

# Full clean: remove everything including images and volumes
fclean: down
	@echo "$(RED)Removing all containers, networks, images and volumes...$(NC)"
	docker compose -f $(COMPOSE_FILE) down --volumes --rmi all
	docker system prune -af --volumes
	@echo "$(GREEN) Full cleanup completed$(NC)"
	rm -rf db/* web/*

# Rebuild everything from scratch
re: fclean all

# Show logs
logs:
	@echo "$(YELLOW)Showing logs...$(NC)"
	docker compose -f $(COMPOSE_FILE) logs -f

# Show running containers
ps:
	@echo "$(YELLOW)Running containers:$(NC)"
	docker compose -f $(COMPOSE_FILE) ps
