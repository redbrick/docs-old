SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.DEFAULT_GOAL := help
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

build: site  ## Build site
site: .venv/bin/mkdocs docs mkdocs.yml
	.venv/bin/mkdocs build -s -v

.PHONY: serve
serve: .venv/bin/mkdocs  ## Run development server in debug mode
	.venv/bin/mkdocs serve

.PHONY: clean
clean:  ## clean built docs
	rm -rf site

.venv/bin/activate:
	python3 -m venv .venv
	chmod +x -R .venv/bin
	.venv/bin/python -m pip install --upgrade pip

.venv/bin/mkdocs: .venv/bin/activate requirements.txt
	. $(word 1, $^)
	.venv/bin/python -m pip install -r $(word 2, $^)

.PHONY: lint, lint-markdown, lint-html
lint: lint-markdown lint-html ## run makrdown and html linter
lint-markdown: ## Run markdown linter
	@docker run --rm -v $$(pwd):/docs ruby:2-alpine sh -c 'gem install mdl && mdl /docs/docs/ -s /docs/.markdown.style.rb'
lint-html: build ## Run html linter
	@docker run --rm -v $$(pwd):/docs ruby:2 sh -c 'gem install html-proofer && htmlproofer --allow-hash-href --check-html --empty-alt-ignore --disable-external /docs/site'

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'
