SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.DEFAULT_GOAL := help
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

build: public  ## Build site
public:
	mkdocs build -s -v

.PHONY: serve
serve:  ## Run development server in debug mode
	mkdocs serve

.PHONY: clean
clean:  ## clean built docs
	rm -rf public

.venv/bin/activate:
	python3 -m venv .venv
	chmod +x -R .venv/bin

.PHONY: setup
setup: .venv/bin/activate  ## Setup env
	. $<
	pip install -r requirements.txt

.PHONY: lint
lint:  ## run linter on markdown
	@docker run --rm -v $$(pwd):/docs ruby:2-alpine sh -c 'gem install mdl && mdl /docs/docs/ -s /docs/.markdown.style.rb'

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

