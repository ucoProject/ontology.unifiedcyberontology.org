#!/usr/bin/make -f

# This software was developed at the National Institute of Standards
# and Technology by employees of the Federal Government in the course
# of their official duties. Pursuant to title 17 Section 105 of the
# United States Code this software is not subject to copyright
# protection and is in the public domain. NIST assumes no
# responsibility whatsoever for its use by other parties, and makes
# no guarantees, expressed or implied, about its quality,
# reliability, or any other characteristic.
#
# We would appreciate acknowledgement if the software is used.

SHELL := /bin/bash

all: \
  all-case

.PHONY: \
  all-case \
  check-service


# This target checks for a file's existence to confirm that the submodule
# has been checked out at least once.  To simplify development work, a
# submodule init-update is only run to do an initial checkout, so
# submodule-update doesn't reset a development pointer.
.git_submodule_init.done.log: \
  .gitmodules
	test -r dependencies/CASE/README.md \
	  || (git submodule init dependencies/CASE && git submodule update dependencies/CASE)
	# Initialize CASE submodules and retrieve rdf-toolkit.
	$(MAKE) \
	  --directory dependencies/CASE \
	  .git_submodule_init.done.log \
	  .lib.done.log
	test -r dependencies/Ontospy/README.md \
	  || (git submodule init dependencies/Ontospy && git submodule update dependencies/Ontospy)
	touch $@

.venv.done.log: \
  .git_submodule_init.done.log
	rm -rf venv
	python3 -m venv \
	  venv
	source venv/bin/activate \
	  && pip install \
	    --upgrade \
	    pip \
	    setuptools \
	    wheel
	# TODO - Ontospy does not currently handle Django >= 4.
	source venv/bin/activate \
	  && pip install \
	    django==3.2.9
	source venv/bin/activate \
	  && pip install \
	    --editable \
	    dependencies/Ontospy[FULL]
	touch $@

all-case: \
  .venv.done.log \
  dependencies/CASE/tests/case_monolithic.ttl
	$(MAKE) \
	  --directory case

check-service:
	wget \
	  --header 'Accept: text/turtle' \
	  -o _$@ \
	  http://localhost/case/investigation
	diff _$@ case/investigation.ttl
	rm _$@
	wget \
	  --header 'Accept: application/rdf+xml' \
	  -o _$@ \
	  http://localhost/case/investigation
	diff _$@ case/investigation.rdf
	rm _$@

clean:
	@$(MAKE) \
	  --directory case \
	  clean
	@rm -f .*.done.log
	@test ! -r dependencies/CASE/README.md \
	  || $(MAKE) \
	    --directory dependencies/CASE \
	    clean
	@# Revert status of test files, to avoid CASE submodule irrelevantly reporting as dirty.
	@cd dependencies/CASE \
	  && git checkout -- tests/examples

dependencies/CASE/tests/case_monolithic.ttl: \
  .git_submodule_init.done.log
	$(MAKE) \
	  --directory dependencies/CASE/tests \
	  case_monolithic.ttl
	# Clean up superfluous artifact.  TODO - This step can be removed after the 0.3.0 release of the referenced tool.
	rm -rf dependencies/CASE/dependencies/UCO/dependencies/CASE-Utility-SHACL-Inheritance-Review/build
	# Guarantee file is built and timestamp is up to date.
	test -r $@
	touch $@
