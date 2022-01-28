test: setup fmt init validate clean

i init:
	terraform init

v validate:
	terraform validate

f fmt:
	terraform fmt

setup:
	ln -fs tests/providers.tf

clean:
	rm providers.tf
