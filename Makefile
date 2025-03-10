ifndef APP_ENV
	include .env
	# Determine if .env.local file exist
	ifneq ("$(wildcard .env.local)", "")
		include .env.local
	endif
endif

ifndef INSIDE_DOCKER_CONTAINER
	INSIDE_DOCKER_CONTAINER = 0
endif

HOST_UID := $(shell id -u)
HOST_GID := $(shell id -g)
PHP_USER := -u www-data
PROJECT_NAME := -p ${COMPOSE_PROJECT_NAME}
OPENSSL_BIN := $(shell which openssl)
INTERACTIVE := $(shell [ -t 0 ] && echo 1)
ERROR_ONLY_FOR_HOST = @printf "\033[33mThis command for host machine\033[39m\n"
ifneq ($(INTERACTIVE), 1)
	OPTION_T := -T
endif
ifeq ($(GITLAB_CI), 1)
	# Determine additional params for phpunit in order to generate coverage badge on GitLabCI side
	PHPUNIT_OPTIONS := --coverage-text --colors=never
endif

build:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose -f docker-compose.yml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

build-test:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose -f docker-compose-test-ci.yml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

build-staging:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose -f docker-compose-staging.yml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

build-prod:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose -f docker-compose-prod.yml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

start:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose -f docker-compose.yml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

start-test:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose -f docker-compose-test-ci.yml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

start-staging:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose -f docker-compose-staging.yml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

start-prod:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose -f docker-compose-prod.yml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose -f docker-compose.yml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop-test:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose -f docker-compose-test-ci.yml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop-staging:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose -f docker-compose-staging.yml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop-prod:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose -f docker-compose-prod.yml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

restart: stop start
restart-test: stop-test start-test
restart-staging: stop-staging start-staging
restart-prod: stop-prod start-prod

env-prod:
	@make exec cmd="composer dump-env prod"

env-staging:
	@make exec cmd="composer dump-env staging"

generate-jwt-keys:
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@echo "\033[32mGenerating RSA keys for JWT\033[39m"
	@mkdir -p config/jwt
	@rm -f ${JWT_SECRET_KEY}
	@rm -f ${JWT_PUBLIC_KEY}
	@openssl genrsa -passout pass:${JWT_PASSPHRASE} -out ${JWT_SECRET_KEY} -aes256 4096
	@openssl rsa -passin pass:${JWT_PASSPHRASE} -pubout -in ${JWT_SECRET_KEY} -out ${JWT_PUBLIC_KEY}
	@chmod 664 ${JWT_SECRET_KEY}
	@chmod 664 ${JWT_PUBLIC_KEY}
	@echo "\033[32mRSA key pair successfully generated\033[39m"
else
	@make exec cmd="make generate-jwt-keys"
endif

ssh:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) symfony bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-root:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose $(PROJECT_NAME) exec $(OPTION_T) symfony bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-nginx:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose $(PROJECT_NAME) exec nginx /bin/sh
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-supervisord:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose $(PROJECT_NAME) exec supervisord bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-mysql:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose $(PROJECT_NAME) exec mysql bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-rabbitmq:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose $(PROJECT_NAME) exec rabbitmq /bin/sh
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-elasticsearch:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose $(PROJECT_NAME) exec elasticsearch bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-kibana:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose $(PROJECT_NAME) exec kibana bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

exec:
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@$$cmd
else
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) symfony $$cmd
endif

exec-bash:
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@bash -c "$(cmd)"
else
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) symfony bash -c "$(cmd)"
endif

exec-by-root:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@HOST_UID=$(HOST_UID) HOST_GID=$(HOST_GID) docker-compose $(PROJECT_NAME) exec $(OPTION_T) symfony $$cmd
else
	$(ERROR_ONLY_FOR_HOST)
endif

report-prepare:
	@make exec cmd="mkdir -p reports/coverage"

report-clean:
	@make exec-by-root cmd="rm -rf reports/*"

wait-for-db:
	@make exec cmd="php bin/console db:wait"

wait-for-elastic:
	@make exec cmd="php bin/console elastic:wait"

composer-install-no-dev:
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader --no-dev"

composer-install:
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader"

composer-update:
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer update"

info:
	@make exec cmd="php --version"
	@make exec cmd="bin/console about"

logs:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}_symfony
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-nginx:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}_nginx
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-supervisord:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}_supervisord
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-mysql:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}_mysql
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-rabbitmq:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}_rabbitmq
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-elasticsearch:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}_elasticsearch
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-kibana:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}_kibana
else
	$(ERROR_ONLY_FOR_HOST)
endif

drop-migrate:
	@make exec cmd="php bin/console doctrine:schema:drop --full-database --force"
	@make exec cmd="php bin/console doctrine:schema:drop --full-database --force --env=test"
	@make migrate

migrate-no-test:
	@make exec cmd="php bin/console doctrine:migrations:migrate --no-interaction --all-or-nothing"

migrate:
	@make exec cmd="php bin/console doctrine:migrations:migrate --no-interaction --all-or-nothing"
	@make exec cmd="php bin/console doctrine:migrations:migrate --no-interaction --all-or-nothing --env=test"

migrate-cron-jobs:
	@make exec cmd="php bin/console scheduler:cleanup-logs"

fixtures:
	@make exec cmd="php bin/console doctrine:fixtures:load --env=test"

create-roles-groups:
	@make exec cmd="php bin/console user:create-roles-groups"

messenger-setup-transports:
	@make exec cmd="php bin/console messenger:setup-transports"

elastic-create-or-update-template:
	@make exec cmd="php bin/console elastic:create-or-update-template"

phpunit:
	@make exec-bash cmd="rm -rf ./var/cache/test* && bin/console cache:warmup --env=test && ./vendor/bin/phpunit -c phpunit.xml.dist --coverage-html reports/coverage $(PHPUNIT_OPTIONS) --coverage-clover reports/clover.xml --log-junit reports/junit.xml"

report-code-coverage: ## update code coverage on coveralls.io. Note: COVERALLS_REPO_TOKEN should be set on CI side.
	@make exec-bash cmd="export COVERALLS_REPO_TOKEN=${COVERALLS_REPO_TOKEN} && php ./vendor/bin/php-coveralls -v --coverage_clover reports/clover.xml --json_path reports/coverals.json"

phpcs: ## Runs PHP CodeSniffer
	@make exec-bash cmd="./vendor/bin/phpcs --version && ./vendor/bin/phpcs --standard=PSR12 --colors -p src tests"

ecs: ## Runs Easy Coding Standard
	@make exec-bash cmd="./vendor/bin/ecs --version && ./vendor/bin/ecs --clear-cache check src tests"

ecs-fix: ## Run The Easy Coding Standard to fix issues
	@make exec-bash cmd="./vendor/bin/ecs --version && ./vendor/bin/ecs --clear-cache --fix check src tests"

phpmetrics: ## Runs phpmetrics
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@mkdir -p reports/phpmetrics
	@if [ ! -f reports/junit.xml ] ; then \
		printf "\033[32;49mjunit.xml not found, running tests...\033[39m\n" ; \
		./vendor/bin/phpunit -c phpunit.xml.dist --coverage-html reports/coverage --coverage-clover reports/clover.xml --log-junit reports/junit.xml ; \
	fi;
	@echo "\033[32mRunning PhpMetrics\033[39m"
	@php ./vendor/bin/phpmetrics --version
	@php ./vendor/bin/phpmetrics --junit=reports/junit.xml --report-html=reports/phpmetrics .
else
	@make exec-by-root cmd="make phpmetrics"
endif

phpcpd: ## Runs php copy/paste detector
	@make exec cmd="php phpcpd.phar --fuzzy src tests"

phpmd: ## Runs php mess detector
	@make exec cmd="php ./vendor/bin/phpmd src text phpmd_ruleset.xml --suffixes php"

phpstan: ## Runs PHPStan static analysis tool
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@echo "\033[32mRunning PHPStan - PHP Static Analysis Tool\033[39m"
	@bin/console cache:clear --env=test
	@./vendor/bin/phpstan --version
	@./vendor/bin/phpstan analyze src tests
else
	@make exec cmd="make phpstan"
endif

phpinsights: ## Runs Php Insights PHP quality checks
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@echo "\033[32mRunning PHP Insights\033[39m"
	@php -d error_reporting=0 ./vendor/bin/phpinsights analyse --no-interaction --min-quality=100 --min-complexity=84 --min-architecture=100 --min-style=100
else
	@make exec cmd="make phpinsights"
endif
