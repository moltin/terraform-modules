.PHONY: docs
docs: ## terraform docs
	@bin/docs && \
	\
	$(MAKE) changelog

.PHONY: changelog
changelog: ## generate changelog
	@docker run --rm -it -v $$(pwd):/code moltin/gitchangelog > CHANGELOG.md
