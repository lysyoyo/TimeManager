# ——————— Batman Project Makefile ————————————————————————————————————————————————————————

DOCKER_COMPOSE = docker compose
DOCKER_EXEC    = $(DOCKER_COMPOSE) exec
WEB_CONTAINER  = web
DB_CONTAINER   = db
frontend = frontend
ANDROID_BUILDER = android-builder
ANDROID_APK_PATH = frontend/android/app/build/outputs/apk/debug/app-debug.apk

.DEFAULT_GOAL := help
.PHONY: help build up down bash logs create-db migrate rollback test format credo iex
.PHONY: android android-build android-install android-logs android-watch

help: ## Display this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build Docker images
	@$(DOCKER_COMPOSE) build

install-elixir: ## Install dependencies
	@$(DOCKER_EXEC) $(WEB_CONTAINER) mix deps.get

install-vue: ## Install dependencies (dev)
	@$(DOCKER_EXEC) $(frontend) npm install

up: ## Start the application
	@$(DOCKER_COMPOSE) up -d

down: ## Stop the application
	@$(DOCKER_COMPOSE) down

make restart: down up ## Restart the application
	@echo "Application restarted successfully."

make remove: ## Remove the application
	@$(DOCKER_COMPOSE) down -v
	@echo "Application removed successfully."

bash: ## Access the web container's shell
	@$(DOCKER_EXEC) $(WEB_CONTAINER) bash

logs: ## View application logs
	@$(DOCKER_COMPOSE) logs -f

create-db: ## Create the database
	@$(DOCKER_EXEC) $(WEB_CONTAINER) mix ecto.create

migrate: ## Run database migrations
	@$(DOCKER_EXEC) $(WEB_CONTAINER) mix ecto.migrate

rollback: ## Rollback the last migration
	@$(DOCKER_EXEC) $(WEB_CONTAINER) mix ecto.rollback

test: ## Run tests
	@$(DOCKER_EXEC) $(WEB_CONTAINER) mix test

format: ## Check code formatting
	@$(DOCKER_EXEC) $(WEB_CONTAINER) mix format --check-formatted

format-fix: ## Fix code formatting
	@$(DOCKER_EXEC) $(WEB_CONTAINER) mix format

credo: ## Run static code analysis
	@$(DOCKER_EXEC) $(WEB_CONTAINER) mix credo

iex: ## Start an IEx session
	@$(DOCKER_EXEC) $(WEB_CONTAINER) iex -S mix

gen-resource: ## Generate a new resource (usage: make gen-resource ARGS="Context Schema schemas table_name field1:type field2:type")
	@$(DOCKER_EXEC) $(WEB_CONTAINER) mix phx.gen.html $(ARGS)

gen-migration: ## Generate a new migration (usage: make gen-migration NAME=create_users)
	@$(DOCKER_EXEC) $(WEB_CONTAINER) mix ecto.gen.migration $(NAME)

compile: ## Compile the project
	@$(DOCKER_EXEC) $(WEB_CONTAINER) mix compile

clean: ## Clean compiled files
	@$(DOCKER_EXEC) $(WEB_CONTAINER) mix clean

db-console: ## Access the database console
	@$(DOCKER_EXEC) $(DB_CONTAINER) psql -U postgres

db-logs: ## View database logs
	@$(DOCKER_COMPOSE) logs -f db

remove-comments: ## Remove non-essential comments from project files
	@echo "Removing non-essential comments from project files..."
	@$(DOCKER_EXEC) $(WEB_CONTAINER) /bin/sh -c '\
		find . -type f \( -name "*.ex" -o -name "*.exs" \) -print0 | \
		xargs -0 sed -i \
		-e '\''s/[[:space:]]*#[^!@][[:space:]].*$$//g'\'' \
		-e '\''/^[[:space:]]*#[^!@]/d'\'' \
		-e '\''s/"""[^@!].*?"""/""/g'\'' \
		-e '\''/^[[:space:]]*"""[^@!]/,/^[[:space:]]*"""/d'\'' \
		-e '\''/^[[:space:]]*#$$/d'\''\
		&& echo "Non-essential comments removed successfully."'
	@echo "CAUTION: Non-essential comments have been removed. Essential annotations and documentation are preserved."



reset-db: down up create-db migrate ## Reset the database (Warning: This will destroy all data)

ci: format credo test ## Run CI checks (format, credo, test)

# Variables pour le build Android
ANDROID_BUILDER = android-builder
ANDROID_APK_PATH = frontend/android/app/build/outputs/apk/debug/app-debug.apk

# Variables pour le serveur de partage
APK_SERVER_PORT = 8765
NETWORK_IP = $(shell ip route get 1.1.1.1 | awk '{print $$7}')

# Commandes principales pour Android
android-build: ## Build the Android application . NEED ALL DOOCKER CONTAINERS UP
	@$(DOCKER_COMPOSE) run --rm $(ANDROID_BUILDER)

android-watch: ## Start Android development with hot reload . NEED ALL DOOCKER CONTAINERS UP
	@$(DOCKER_COMPOSE) run --rm -e NODE_ENV=development $(ANDROID_BUILDER)

android-install: ## Install the APK on a connected device. NEED ALL DOOCKER CONTAINERS UP
	@if [ -f $(ANDROID_APK_PATH) ]; then \
		adb install -r $(ANDROID_APK_PATH); \
	else \
		echo "APK not found. Run 'make android-build' first"; \
		exit 1; \
	fi

android: android-build android-install ## Build and install the Android application. NEED ALL DOOCKER CONTAINERS UP

android-share: android-check-build android-serve-apk ## Share the APK via QR code. NEED ALL DOOCKER CONTAINERS UP

android-check-build: ## Check if APK exists. NEED ALL DOOCKER CONTAINERS UP
	@if [ ! -f $(ANDROID_APK_PATH) ]; then \
		echo "ERROR: APK not found. Please run 'make android-build' first"; \
		exit 1; \
	fi

android-serve-apk: ## Serve existing APK file with QR code. NEED ALL DOOCKER CONTAINERS UP
	@echo "Starting APK sharing server at http://$(NETWORK_IP):$(APK_SERVER_PORT)"
	@echo "Scan the QR code with your Android device to install the app"
	@echo "Make sure your device is on the same network"
	@docker run --rm \
		-v $(PWD)/frontend:/app \
		-w /app \
		-p $(APK_SERVER_PORT):$(APK_SERVER_PORT) \
		-e HOST_IP=$(NETWORK_IP) \
		-e PORT=$(APK_SERVER_PORT) \
		python:3.9-slim bash -c "\
		pip install qrcode flask pillow && \
		python apk_server.py"