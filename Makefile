.PHONY: test
test:
	dart --checked test/test.ldap2date.dart

.PHONY: docs
docs:
	git checkout -q gh-pages
	git merge -q master
	dartdoc lib/ldap2date.dart
	@mv docs/* .
	@rm -r docs

