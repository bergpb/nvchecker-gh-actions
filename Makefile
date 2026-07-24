.PHONY: build push test act

build:
	docker build . \
		-t ghcr.io/bergpb/nvchecker-gh-actions:latest \
		-t ghcr.io/bergpb/nvchecker-gh-actions:main \
		$(if $(VERSION),-t ghcr.io/bergpb/nvchecker-gh-actions:$(VERSION)) \
		-f Dockerfile

push:
	@docker push ghcr.io/bergpb/nvchecker-gh-actions:main && \
	docker push ghcr.io/bergpb/nvchecker-gh-actions:latest
	$(if $(VERSION),@docker push ghcr.io/bergpb/nvchecker-gh-actions:$(VERSION))

test:
	@./run-and-notify.sh

act: build
	act -j check-new-versions \
		--secret-file .env \
		--env LOG_FILE=nvchecker.log \
		--pull=false
