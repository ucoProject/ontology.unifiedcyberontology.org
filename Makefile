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

# Use HOST_PREFIX to test the deployment at the specified host.
# Syntax note - there is no trailing slash.
HOST_PREFIX ?= http://localhost

all: \
  all-uco

.PHONY: \
  all-uco \
  check-service


# This target checks for a file's existence to confirm that the submodule
# has been checked out at least once.  To simplify development work, a
# submodule init-update is only run to do an initial checkout, so
# submodule-update doesn't reset a development pointer.
.git_submodule_init.done.log: \
  .gitmodules
	test -r dependencies/UCO/README.md \
	  || (git submodule init dependencies/UCO && git submodule update dependencies/UCO)
	# Initialize UCO submodules and retrieve rdf-toolkit.
	$(MAKE) \
	  --directory dependencies/UCO \
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

all-uco: \
  .venv.done.log \
  dependencies/UCO/tests/uco_monolithic.ttl
	$(MAKE) \
	  --directory uco

check: \
  all-uco
	$(MAKE) \
	  --directory uco \
	  check

# Test matrix:
# Concept broad type: ontology, class, or property
# "Accept" header: none specified, Turtle requested, or RDF requested
check-service:
	## Ontologies
	wget \
	  --output-document _$@ \
	  $(HOST_PREFIX)/uco/vocabulary.ttl
	diff _$@ uco/vocabulary.ttl
	rm _$@
	wget \
	  --output-document _$@ \
	  $(HOST_PREFIX)/uco/vocabulary.rdf
	diff _$@ uco/vocabulary.rdf
	rm _$@
	wget \
	  --header 'Accept: text/turtle' \
	  --output-document _$@ \
	  $(HOST_PREFIX)/uco/vocabulary
	diff _$@ uco/vocabulary.ttl
	rm _$@
	wget \
	  --header 'Accept: text/turtle' \
	  --output-document _$@ \
	  $(HOST_PREFIX)/uco/vocabulary/0.9.1
	diff _$@ uco/vocabulary/0.9.1.ttl
	rm _$@
	wget \
	  --header 'Accept: application/rdf+xml' \
	  --output-document _$@ \
	  $(HOST_PREFIX)/uco/vocabulary
	diff _$@ uco/vocabulary.rdf
	rm _$@
	wget \
	  --header 'Accept: application/rdf+xml' \
	  --output-document _$@ \
	  $(HOST_PREFIX)/uco/vocabulary/0.9.1
	diff _$@ uco/vocabulary/0.9.1.rdf
	rm _$@
#	## Classes
#	wget \
	  --output-document _$@ \
	  $(HOST_PREFIX)/uco/core/UcoObject
#	# NOTE - no comparison test done, default behavior just needs to not return a server error.
#	rm _$@
#	wget \
	  --header 'Accept: text/html' \
	  --output-document _$@ \
	  $(HOST_PREFIX)/uco/core/UcoObject
#	diff _$@ uco/core/UcoObject.html
#	rm _$@
#	#TODO - Turtle breakout needs to be written.
#	wget \
#	  --header 'Accept: text/turtle' \
#	  --output-document _$@ \
#	  $(HOST_PREFIX)/uco/core/UcoObject
#	diff _$@ uco/core/UcoObject.ttl
#	rm _$@
#	#TODO - Turtle RDF-XML breakout needs to be written.
#	wget \
#	  --header 'Accept: application/rdf+xml' \
#	  --output-document _$@ \
#	  $(HOST_PREFIX)/uco/core/UcoObject
#	diff _$@ uco/core/UcoObject.rdf
#	rm _$@
	## Properties
#	wget \
	  --output-document _$@ \
	  $(HOST_PREFIX)/uco/core/hasFacet
	# NOTE - no comparison test done, default behavior just needs to not return a server error.
#	rm _$@
#	wget \
	  --header 'Accept: text/html' \
	  --output-document _$@ \
	  $(HOST_PREFIX)/uco/core/hasFacet
#	diff _$@ uco/core/hasFacet.html
#	rm _$@
#	#TODO - Turtle breakout needs to be written.
#	wget \
#	  --header 'Accept: text/turtle' \
#	  --output-document _$@ \
#	  $(HOST_PREFIX)/uco/core/hasFacet
#	diff _$@ uco/core/hasFacet.ttl
#	rm _$@
#	#TODO - Turtle RDF-XML breakout needs to be written.
#	wget \
#	  --header 'Accept: application/rdf+xml' \
#	  --output-document _$@ \
#	  $(HOST_PREFIX)/uco/core/hasFacet
#	diff _$@ uco/core/hasFacet.rdf
#	rm _$@
	# Confirm documentation index is reachable.
	wget \
	  --output-document _$@ \
	  $(HOST_PREFIX)/uco/documentation/
	diff _$@ uco/documentation/index.html
	rm _$@
	# Confirm HTML index for non-umbrella namespaces are redirected to umbrella documentation index.
	wget \
	  --header 'Accept: text/html' \
	  --output-document _$@ \
	  $(HOST_PREFIX)/uco/core/
	diff _$@ uco/documentation/index.html
	rm _$@
	@echo >&2
	@echo "INFO:Makefile:Service tests pass!" >&2

clean:
	@$(MAKE) \
	  --directory uco \
	  clean
	@rm -f .*.done.log
	@test ! -r dependencies/UCO/README.md \
	  || $(MAKE) \
	    --directory dependencies/UCO \
	    clean
	@# Revert status of test files, to avoid UCO submodule irrelevantly reporting as dirty.
	@cd dependencies/UCO \
	  && git checkout -- tests/examples

dependencies/UCO/tests/uco_monolithic.ttl: \
  .git_submodule_init.done.log
	$(MAKE) \
	  --directory dependencies/UCO/tests \
	  uco_monolithic.ttl
	# Clean up superfluous artifact.  TODO - This step can be removed after the 0.3.0 release of the referenced tool.
	rm -rf dependencies/UCO/dependencies/UCO/dependencies/CASE-Utility-SHACL-Inheritance-Review/build
	# Guarantee file is built and timestamp is up to date.
	test -r $@
	touch $@
