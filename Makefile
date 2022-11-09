VERSION:=2.0-alpha4

test: fmt lint init validate

i init:
	terraform init

l lint:
	@type tflint &>/dev/null || echo "Ignoring not found: tflint" && tflint

v validate:
	terraform validate

f fmt:
	terraform fmt

release:
	@if [ $$(git status --short | wc -l) -gt 0 ]; then \
		git status; \
		echo ; \
		echo "Tree is not clean. Please commit and try again"; \
		exit 1; \
	fi
	git pull --tags
	git tag v$(VERSION)
	git push --tags
	git push
