SHELL=/bin/bash
.DEFAULT_GOAL:=help


.PHONY: help info
##@ Helpers

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  \
	make [VARS] \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ \
	{ printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ \
	{ printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

################################################################################

info: ## Info about
	@echo manage image $(IMAGE)
	@echo TAG_BUILD=$(TAG_BUILD)


tar-source: ## tar the sources
	rm -f intro.tar.gz \
	&& rm -f deployment/index.html \
	&& cp -R css deployment \
	&& cp -R ./img deployment \
	&& cp -R js deployment \
	&& cp -R scss deployment \
	&& cp -R vendor deployment \
	&& cp -R index.html deployment \
	&& tar -czvf intro.tar.gz deployment

scp-to-pi: ## scp to pi
	scp -P 5566 intro.tar.gz alarm@usque.ru:~/pelican

deploy-on-pi: ## deploy to pi
	ssh alarm@usque.ru -p 5566 /home/alarm/pelican/./deploy-intro.sh

deploy: tar-source scp-to-pi deploy-on-pi ## deploy on pi
