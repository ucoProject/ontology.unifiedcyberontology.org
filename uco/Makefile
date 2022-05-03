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

all: \
  .symlinking.done.log \
  action.rdf \
  action.ttl \
  core.rdf \
  core.ttl \
  identity.rdf \
  identity.ttl \
  location.rdf \
  location.ttl \
  marking.rdf \
  marking.ttl \
  observable.rdf \
  observable.ttl \
  pattern.rdf \
  pattern.ttl \
  role.rdf \
  role.ttl \
  time.rdf \
  time.ttl \
  tool.rdf \
  tool.ttl \
  types.rdf \
  types.ttl \
  uco.rdf \
  uco.ttl \
  victim.rdf \
  victim.ttl \
  vocabulary.rdf \
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
	    --theme united \
	    --title uco-0.8.0-docs \
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
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

action.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/action/action.ttl
	cp $< $@

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
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

core.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/core/core.ttl
	cp $< $@

identity.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/identity/identity.ttl \
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

identity.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/identity/identity.ttl
	cp $< $@

location.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/location/location.ttl \
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

location.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/location/location.ttl
	cp $< $@

marking.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/marking/marking.ttl \
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

marking.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/marking/marking.ttl
	cp $< $@

observable.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/observable/observable.ttl \
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

observable.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/observable/observable.ttl
	cp $< $@

pattern.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/pattern/pattern.ttl \
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

pattern.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/pattern/pattern.ttl
	cp $< $@

role.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/role/role.ttl \
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

role.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/role/role.ttl
	cp $< $@

time.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/time/time.ttl \
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

time.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/time/time.ttl
	cp $< $@

tool.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/tool/tool.ttl \
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

tool.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/tool/tool.ttl
	cp $< $@

types.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/types/types.ttl \
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

types.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/types/types.ttl
	cp $< $@

uco.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/master/uco.ttl \
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

uco.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/master/uco.ttl
	cp $< $@

victim.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/victim/victim.ttl \
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

victim.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/victim/victim.ttl
	cp $< $@

vocabulary.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/vocabulary/vocabulary.ttl \
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

vocabulary.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/vocabulary/vocabulary.ttl
	cp $< $@