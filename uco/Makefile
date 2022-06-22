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
  $(top_srcdir)/dependencies/UCO/ontology/uco/action/action.ttl \
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
	mv _$@ $@

action.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/action/action.ttl
	cp $< $@

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
  $(top_srcdir)/dependencies/UCO/ontology/uco/core/core.ttl \
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
	mv _$@ $@

core.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/core/core.ttl
	cp $< $@

identity.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/identity/identity.ttl \
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
	mv _$@ $@

identity.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/identity/identity.ttl
	cp $< $@

location.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/location/location.ttl \
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
	mv _$@ $@

location.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/location/location.ttl
	cp $< $@

marking.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/marking/marking.ttl \
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
	mv _$@ $@

marking.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/marking/marking.ttl
	cp $< $@

observable.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/observable/observable.ttl \
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
	mv _$@ $@

observable.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/observable/observable.ttl
	cp $< $@

pattern.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/pattern/pattern.ttl \
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
	mv _$@ $@

pattern.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/pattern/pattern.ttl
	cp $< $@

role.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/role/role.ttl \
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
	mv _$@ $@

role.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/role/role.ttl
	cp $< $@

time.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/time/time.ttl \
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
	mv _$@ $@

time.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/time/time.ttl
	cp $< $@

tool.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/tool/tool.ttl \
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
	mv _$@ $@

tool.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/tool/tool.ttl
	cp $< $@

types.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/types/types.ttl \
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
	mv _$@ $@

types.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/types/types.ttl
	cp $< $@

uco.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/master/uco.ttl \
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
	mv _$@ $@

uco.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/master/uco.ttl
	cp $< $@

victim.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/victim/victim.ttl \
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
	mv _$@ $@

victim.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/victim/victim.ttl
	cp $< $@

vocabulary.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/vocabulary/vocabulary.ttl \
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
	mv _$@ $@

vocabulary.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/vocabulary/vocabulary.ttl
	cp $< $@
