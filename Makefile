.DEFAULT_GOAL := help

help:
	@echo ""
	@echo "Available tasks:"
	@echo "    lint   Run linter and code style checker"
	@echo "    unit   Run unit tests and generate coverage"
	@echo "    test   Run linter and unit tests"
	@echo "    watch  Run linter and unit tests when any of the source files change"
	@echo "    deps   Install dependencies"
	@echo "    all    Install dependencies and run linter and unit tests"
	@echo "    start  Start Docker"
	@echo "    inst   Install Database, Need Start First"
	@echo ""

deps:
	composer install --prefer-dist

lint:
	vendor/bin/phplint . --exclude=vendor/
	vendor/bin/phpcs -p --standard=PSR2 --exclude=PSR2.Namespaces.UseDeclaration --extensions=php --encoding=utf-8 --ignore=*/vendor/*,*/benchmarks/*,*/db/* .

unit:
	vendor/bin/phpunit --coverage-text --coverage-clover=coverage.xml --coverage-html=./report/

watch:
	find . -name "*.php" -not -path "./vendor/*" -o -name "*.json" -not -path "./vendor/*" | entr -c make test

test: lint unit

travis: lint unit

all: deps test

start: 
	docker-compose up -d

inst:
	docker exec -it slim_db mysql -uroot -p123456 -D mysql -e "create database production_db default charset utf8;"
	docker exec -it slim_db mysql -uroot -p123456 -D mysql -e "create database development_db default charset utf8;"
	docker exec -it slim_db mysql -uroot -p123456 -D mysql -e "create database testing_db default charset utf8;"
	vendor/bin/phinx migrate
	vendor/bin/phinx seed:run

    

.PHONY: help deps lint test watch all
