SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# You can set these variables from the command line.
PYTHON          = python
PROOFER         = htmlproofer
BUILDDIR        ?= site
MKDOCS          = mkdocs
MKDOCSBUILDOPTS = --clean --strict
MKDOCSBUILD     = $(MKDOCS) build $(MKDOCSBUILDOPTS)
MKDOCSSERVE     = $(MKDOCS) serve -a 0.0.0.0:8000

BUILD_CMD := $(MKDOCSBUILD) --site-dir $(BUILDDIR) && \
	echo "Build finished. The HTML pages are in $(BUILDDIR)."

.PHONY: dep clean serve build test circleci-dep

build: dep site ## Build documentation

site:
	$(BUILD_CMD)

serve: dep ## Start mkdocs server to preview the docs locally on port 8000
	$(MKDOCSSERVE)

clean: ## clean repo
	rm -rf $(BUILDDIR)

dep: ## Install dependencies
	$(PYTHON) -m pip install --user -r requirements.txt

test: site  ## Test documentation with htmlproofer
	$(PROOFER) \
		--allow-hash-href \
		--check-html \
		--check-img-http \
		--disable-external \
		--empty-alt-ignore \
		--enforce-https \
		$(BUILDIR)

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
