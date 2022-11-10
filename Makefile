VERSION:=2.0-alpha8

test: variables-common.tf fmt lint init validate

variables-common.tf: SOURCE ?= https://github.com/getupcloud/managed-cluster/raw/main/templates/variables-common.tf
variables-common.tf:
	@if [ -e $(SOURCE) ]; then \
	    echo '## Copied from: $(SOURCE)' > $@; \
	    cat $(SOURCE) >> $@; \
	elif ! [ -e $@ ]; then \
	    echo '## Copied from: $(SOURCE)' > $@; \
	    curl -sL https://github.com/getupcloud/managed-cluster/raw/main/templates/variables-common.tf >> $@; \
	fi

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
