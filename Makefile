.PHONY: docs
docs: ## terraform docs
	@bin/docs

.PHONY: changelog
changelog: ## generate changelog
	@docker run --rm -it -v $$(pwd):/code moltin/gitchangelog > CHANGELOG.md
