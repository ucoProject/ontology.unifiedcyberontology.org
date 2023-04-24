#!/usr/bin/make -f

# Portions of this file contributed by NIST are governed by the following
# statement:
#
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

top_srcdir := $(shell pwd)

# Use HOST_PREFIX to test the deployment at the specified host.
# Syntax note - there is no trailing slash.
HOST_PREFIX ?= http://localhost

RDF_TOOLKIT_JAR := $(top_srcdir)/dependencies/UCO/lib/rdf-toolkit.jar

all: \
  iri_mappings_to_html.json \
  iri_mappings_to_rdf.json \
  iri_mappings_to_ttl.json \
  servable_ontology_files.json

.PHONY: \
  check-mypy \
  check-pytest \
  check-service

$(RDF_TOOLKIT_JAR): \
  .git_submodule_init.done.log
	touch -c $@
	test -r $@

.co.done.log: \
  co.rdf \
  co.ttl
	touch $@

.documentation.done.log: \
  current_ontology_version.txt \
  dependencies/UCO/tests/uco_monolithic.ttl
	rm -rf documentation
	mkdir documentation
	source venv/bin/activate \
	  && ontospy gendocs \
	    --outputpath $$PWD/documentation \
	    --theme darkly \
	    --title uco-$$(head -n1 current_ontology_version.txt)-docs \
	    --type 2 \
	    $(top_srcdir)/dependencies/UCO/tests/uco_monolithic.ttl
	touch $@

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
	touch $@

.owl.done.log: \
  owl.rdf \
  owl.ttl
	touch $@

.uco.done.log: \
  .co.done.log \
  .owl.done.log
	$(MAKE) \
	  CURRENT_RELEASE=$$(head -n1 current_ontology_version.txt) \
	  --directory uco
	touch $@

.venv.done.log: \
  .git_submodule_init.done.log \
  requirements.txt \
  router/requirements.txt
	rm -rf venv
	python3 -m venv \
	  venv
	source venv/bin/activate \
	  && pip install \
	    --upgrade \
	    pip \
	    setuptools \
	    wheel
	source venv/bin/activate \
	  && pip install \
	    --requirement router/requirements.txt
	source venv/bin/activate \
	  && pip install \
	    --requirement requirements.txt
	touch $@

check: \
  .uco.done.log \
  check-mypy \
  check-pytest
	$(MAKE) \
	  CURRENT_RELEASE=$$(head -n1 current_ontology_version.txt) \
	  --directory uco \
	  check

check-mypy: \
  .venv.done.log
	source venv/bin/activate \
	  && mypy \
	    --strict \
	    router \
	    src \
	    test_*.py

check-pytest: \
  .venv.done.log
	source venv/bin/activate \
	  && pytest test_graph_files.py \
	    --log-level=DEBUG
	source venv/bin/activate \
	  && HOST_PREFIX="$(HOST_PREFIX)" \
	    pytest test_router.py \
	      --log-level=DEBUG

check-service:
	wget \
	  --output-document _$@ \
	  $(HOST_PREFIX)/
	rm _$@
	wget \
	  --output-document _$@ \
	  $(HOST_PREFIX)/documentation/
	rm _$@
	wget \
	  --output-document _$@ \
	  $(HOST_PREFIX)/uco/action/0.9.1.rdf
	rm _$@
	wget \
	  --output-document _$@ \
	  $(HOST_PREFIX)/uco/action/$$(head -n1 current_ontology_version.txt).rdf
	rm _$@
	@echo "INFO:Makefile:Service tests pass!" >&2

clean:
	@rm -rf \
	  documentation
	@$(MAKE) \
	  CURRENT_RELEASE=$$(head -n1 current_ontology_version.txt) \
	  --directory uco \
	  clean
	@rm -f \
	  .*.done.log \
	  current_ontology_iris.txt
	@test ! -r dependencies/UCO/README.md \
	  || $(MAKE) \
	    --directory dependencies/UCO \
	    clean
	@# Revert status of test files, to avoid UCO submodule irrelevantly reporting as dirty.
	@cd dependencies/UCO \
	  && git checkout -- \
	    tests/examples

co.rdf: \
  co.ttl \
  $(RDF_TOOLKIT_JAR) \
  $(top_srcdir)/src/namespaces.sed
	rm -f __$@ _$@
	java -jar $(RDF_TOOLKIT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f $(top_srcdir)/src/namespaces.sed \
	  __$@ \
	  > _$@
	xmllint \
	  --noout \
	  _$@
	rm __$@
	mkdir -p co
	cp \
	  _$@ \
	  co/$$(head -n1 current_ontology_version.txt).rdf
	mv _$@ $@

co.ttl: \
  dependencies/UCO/ontology/co/co.ttl \
  current_ontology_version.txt
	cp $< _$@
	mkdir -p co
	cp \
	  _$@ \
	  co/$$(head -n1 current_ontology_version.txt).ttl
	mv _$@ $@

current_ontology_iris.txt: \
  .venv.done.log \
  dependencies/UCO/tests/uco_monolithic.ttl \
  src/current_ontology_iris_txt.py
	source venv/bin/activate \
	  && python3 src/current_ontology_iris_txt.py \
	    --ontology-base https://ontology.unifiedcyberontology.org \
	    _$@ \
	    dependencies/UCO/tests/uco_monolithic.ttl
	mv _$@ $@

current_ontology_version.txt: \
  .venv.done.log \
  dependencies/UCO/ontology/uco/master/uco.ttl \
  src/current_ontology_version.py
	source venv/bin/activate \
	  && python3 src/current_ontology_version.py \
	    dependencies/UCO/ontology/uco/master/uco.ttl \
	    https://ontology.unifiedcyberontology.org/uco/uco \
	    > _$@
	test -s _$@
	mv _$@ $@

dependencies/UCO/ontology/uco/master/uco.ttl: \
  .git_submodule_init.done.log
	touch -c $@
	test -r $@

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

iri_mappings_to_html.json: \
  .documentation.done.log \
  ontology_iris_archive.txt \
  src/map_entries_to_gendocs.py
	source venv/bin/activate \
	  && cd src \
	    && python3 map_entries_to_gendocs.py \
	      --ontology-base https://ontology.unifiedcyberontology.org \
	      $(top_srcdir)/dependencies/UCO/tests/uco_monolithic.ttl \
	      $(top_srcdir)/ontology_iris_archive.txt

iri_mappings_to_rdf.json: \
  .uco.done.log \
  ontology_iris_archive.txt \
  src/map_iris_to_graph_file.py
	source venv/bin/activate \
	  && python3 src/map_iris_to_graph_file.py \
	    --ontology-base https://ontology.unifiedcyberontology.org \
	    _$@ \
	    application/rdf+xml \
	    ontology_iris_archive.txt
	mv _$@ $@

iri_mappings_to_ttl.json: \
  .uco.done.log \
  ontology_iris_archive.txt \
  src/map_iris_to_graph_file.py
	source venv/bin/activate \
	  && python3 src/map_iris_to_graph_file.py \
	    --ontology-base https://ontology.unifiedcyberontology.org \
	    _$@ \
	    text/turtle \
	    ontology_iris_archive.txt
	mv _$@ $@

# Accumulate all ontology and version IRIs.
ontology_iris_archive.txt: \
  current_ontology_iris.txt
	cat $< > __$@
	test ! -r $@ \
	  || cat $@ >> __$@
	LC_ALL=C sort __$@ \
	  | uniq > _$@
	rm __$@
	mv _$@ $@

owl.rdf: \
  owl.ttl \
  $(RDF_TOOLKIT_JAR) \
  $(top_srcdir)/src/namespaces.sed
	rm -f __$@ _$@
	java -jar $(RDF_TOOLKIT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f $(top_srcdir)/src/namespaces.sed \
	  __$@ \
	  > _$@
	xmllint \
	  --noout \
	  _$@
	rm __$@
	mkdir -p owl
	cp \
	  _$@ \
	  owl/$$(head -n1 current_ontology_version.txt).rdf
	mv _$@ $@

owl.ttl: \
  dependencies/UCO/ontology/owl/owl.ttl \
  current_ontology_version.txt
	cp $< _$@
	mkdir -p owl
	cp \
	  _$@ \
	  owl/$$(head -n1 current_ontology_version.txt).ttl
	mv _$@ $@

servable_ontology_files.json: \
  .uco.done.log \
  ontology_iris_archive.txt \
  src/servable_ontology_files_json.py
	rm -f _$@
	source venv/bin/activate \
	  && python3 src/servable_ontology_files_json.py \
	    --ontology-base https://ontology.unifiedcyberontology.org \
	    _$@ \
	    $(top_srcdir) \
	    ontology_iris_archive.txt
	mv _$@ $@
