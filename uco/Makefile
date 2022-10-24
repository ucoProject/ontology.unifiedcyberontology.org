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

CURRENT_RELEASE := 0.9.1

SHELL := /bin/bash

top_srcdir := $(shell cd .. ; pwd)

RDF_TOOLKT_JAR := $(top_srcdir)/dependencies/UCO/lib/rdf-toolkit.jar

rdf_files := \
  action.rdf \
  core.rdf \
  identity.rdf \
  location.rdf \
  marking.rdf \
  observable.rdf \
  pattern.rdf \
  role.rdf \
  time.rdf \
  tool.rdf \
  types.rdf \
  uco.rdf \
  victim.rdf \
  vocabulary.rdf

all: \
  $(rdf_files) \
  .symlinking.done.log \
  action.ttl \
  core.ttl \
  identity.ttl \
  location.ttl \
  marking.ttl \
  observable.ttl \
  pattern.ttl \
  role.ttl \
  time.ttl \
  tool.ttl \
  types.ttl \
  uco.ttl \
  victim.ttl \
  vocabulary.ttl

.PHONY: \
  clean-symlinking

.documentation.done.log: \
  $(top_srcdir)/.venv.done.log \
  $(top_srcdir)/dependencies/UCO/tests/uco_monolithic.ttl
	rm -rf documentation
	mkdir documentation
	source $(top_srcdir)/venv/bin/activate \
	  && ontospy gendocs \
	    --outputpath $$PWD/documentation \
	    --theme darkly \
	    --title uco-0.9.0-docs \
	    --type 2 \
	    $(top_srcdir)/dependencies/UCO/tests/uco_monolithic.ttl
	touch $@

.%.symlinking.done.log: \
  %.ttl \
	.documentation.done.log
		source $(top_srcdir)/venv/bin/activate \
			&& python3 $(top_srcdir)/src/map_concepts_as_symlinks.py \
				$<

.symlinking.done.log: \
	.action.symlinking.done.log \
	.core.symlinking.done.log \
	.identity.symlinking.done.log \
	.location.symlinking.done.log \
	.marking.symlinking.done.log \
	.observable.symlinking.done.log \
	.pattern.symlinking.done.log \
	.role.symlinking.done.log \
	.time.symlinking.done.log \
	.tool.symlinking.done.log \
	.types.symlinking.done.log \
	.uco.symlinking.done.log \
	.victim.symlinking.done.log \
	.vocabulary.symlinking.done.log

action.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/action/action.ttl \
  $(RDF_TOOLKT_JAR) \
  namespaces.sed
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f namespaces.sed \
	  __$@ \
	  > _$@
	rm __$@
	cp _$@ action/$(CURRENT_RELEASE).rdf
	mv _$@ $@

action.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/action/action.ttl
	cp $< $@
	cp $< action/$(CURRENT_RELEASE).ttl

check: \
  $(rdf_files)
	# Test that generated RDF-XML is valid XML.
	source $(top_srcdir)/venv/bin/activate \
	  && rdfpipe \
	    --input-format xml \
	    --no-out \
	    action.rdf

clean: \
  clean-symlinking
	@rm -f \
	  *.rdf \
	  *.ttl \
	  .*.done.log
	@rm -rf \
	  documentation

clean-symlinking:
	@rm -f \
	  .symlinking.done.log
	@find \
	  . \
	  -name '*.html' \
	  -type l \
	  -exec rm '{}' \;

core.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/core/core.ttl \
  $(RDF_TOOLKT_JAR) \
  namespaces.sed
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f namespaces.sed \
	  __$@ \
	  > _$@
	rm __$@
	cp _$@ core/$(CURRENT_RELEASE).rdf
	mv _$@ $@

core.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/core/core.ttl
	cp $< $@
	cp $< core/$(CURRENT_RELEASE).ttl

identity.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/identity/identity.ttl \
  $(RDF_TOOLKT_JAR) \
  namespaces.sed
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f namespaces.sed \
	  __$@ \
	  > _$@
	rm __$@
	cp _$@ identity/$(CURRENT_RELEASE).rdf
	mv _$@ $@

identity.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/identity/identity.ttl
	cp $< $@
	cp $< identity/$(CURRENT_RELEASE).ttl

location.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/location/location.ttl \
  $(RDF_TOOLKT_JAR) \
  namespaces.sed
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f namespaces.sed \
	  __$@ \
	  > _$@
	rm __$@
	cp _$@ location/$(CURRENT_RELEASE).rdf
	mv _$@ $@

location.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/location/location.ttl
	cp $< $@
	cp $< location/$(CURRENT_RELEASE).ttl

marking.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/marking/marking.ttl \
  $(RDF_TOOLKT_JAR) \
  namespaces.sed
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f namespaces.sed \
	  __$@ \
	  > _$@
	rm __$@
	cp _$@ marking/$(CURRENT_RELEASE).rdf
	mv _$@ $@

marking.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/marking/marking.ttl
	cp $< $@
	cp $< marking/$(CURRENT_RELEASE).ttl

observable.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/observable/observable.ttl \
  $(RDF_TOOLKT_JAR) \
  namespaces.sed
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f namespaces.sed \
	  __$@ \
	  > _$@
	rm __$@
	cp _$@ observable/$(CURRENT_RELEASE).rdf
	mv _$@ $@

observable.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/observable/observable.ttl
	cp $< $@
	cp $< observable/$(CURRENT_RELEASE).ttl

pattern.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/pattern/pattern.ttl \
  $(RDF_TOOLKT_JAR) \
  namespaces.sed
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f namespaces.sed \
	  __$@ \
	  > _$@
	rm __$@
	cp _$@ pattern/$(CURRENT_RELEASE).rdf
	mv _$@ $@

pattern.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/pattern/pattern.ttl
	cp $< $@
	cp $< pattern/$(CURRENT_RELEASE).ttl

role.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/role/role.ttl \
  $(RDF_TOOLKT_JAR) \
  namespaces.sed
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f namespaces.sed \
	  __$@ \
	  > _$@
	rm __$@
	cp _$@ role/$(CURRENT_RELEASE).rdf
	mv _$@ $@

role.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/role/role.ttl
	cp $< $@
	cp $< role/$(CURRENT_RELEASE).ttl

time.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/time/time.ttl \
  $(RDF_TOOLKT_JAR) \
  namespaces.sed
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f namespaces.sed \
	  __$@ \
	  > _$@
	rm __$@
	mkdir -p time
	cp _$@ time/$(CURRENT_RELEASE).rdf
	mv _$@ $@

time.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/time/time.ttl
	cp $< $@
	mkdir -p time
	cp $< time/$(CURRENT_RELEASE).ttl

tool.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/tool/tool.ttl \
  $(RDF_TOOLKT_JAR) \
  namespaces.sed
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f namespaces.sed \
	  __$@ \
	  > _$@
	rm __$@
	cp _$@ tool/$(CURRENT_RELEASE).rdf
	mv _$@ $@

tool.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/tool/tool.ttl
	cp $< $@
	cp $< tool/$(CURRENT_RELEASE).ttl

types.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/types/types.ttl \
  $(RDF_TOOLKT_JAR) \
  namespaces.sed
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f namespaces.sed \
	  __$@ \
	  > _$@
	rm __$@
	cp _$@ types/$(CURRENT_RELEASE).rdf
	mv _$@ $@

types.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/types/types.ttl
	cp $< $@
	cp $< types/$(CURRENT_RELEASE).ttl

uco.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/master/uco.ttl \
  $(RDF_TOOLKT_JAR) \
  namespaces.sed
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f namespaces.sed \
	  __$@ \
	  > _$@
	rm __$@
	mkdir -p uco
	cp _$@ uco/$(CURRENT_RELEASE).rdf
	mv _$@ $@

uco.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/master/uco.ttl
	cp $< $@
	mkdir -p uco
	cp $< uco/$(CURRENT_RELEASE).ttl

victim.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/victim/victim.ttl \
  $(RDF_TOOLKT_JAR) \
  namespaces.sed
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f namespaces.sed \
	  __$@ \
	  > _$@
	rm __$@
	cp _$@ victim/$(CURRENT_RELEASE).rdf
	mv _$@ $@

victim.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/victim/victim.ttl
	cp $< $@
	cp $< victim/$(CURRENT_RELEASE).ttl

vocabulary.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/vocabulary/vocabulary.ttl \
  $(RDF_TOOLKT_JAR) \
  namespaces.sed
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target __$@ \
	  --target-format rdf-xml
	sed \
	  -f namespaces.sed \
	  __$@ \
	  > _$@
	rm __$@
	mkdir -p vocabulary
	cp _$@ vocabulary/$(CURRENT_RELEASE).rdf
	mv _$@ $@

vocabulary.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/vocabulary/vocabulary.ttl
	cp $< $@
	mkdir -p vocabulary
	cp $< vocabulary/$(CURRENT_RELEASE).ttl
