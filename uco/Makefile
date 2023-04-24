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

CURRENT_RELEASE ?=
ifeq ($(CURRENT_RELEASE),)
$(error CURRENT_RELEASE not defined - did you call 'make' from one directory up?)
endif

RDF_TOOLKIT_JAR := $(top_srcdir)/dependencies/UCO/lib/rdf-toolkit.jar

version_iri_files := \
  action/$(CURRENT_RELEASE).rdf \
  action/$(CURRENT_RELEASE).ttl \
  analysis/$(CURRENT_RELEASE).rdf \
  analysis/$(CURRENT_RELEASE).ttl \
  configuration/$(CURRENT_RELEASE).rdf \
  configuration/$(CURRENT_RELEASE).ttl \
  core/$(CURRENT_RELEASE).ttl \
  core/$(CURRENT_RELEASE).rdf \
  core/$(CURRENT_RELEASE).ttl \
  identity/$(CURRENT_RELEASE).rdf \
  identity/$(CURRENT_RELEASE).ttl \
  location/$(CURRENT_RELEASE).rdf \
  location/$(CURRENT_RELEASE).ttl \
  marking/$(CURRENT_RELEASE).rdf \
  marking/$(CURRENT_RELEASE).ttl \
  observable/$(CURRENT_RELEASE).rdf \
  observable/$(CURRENT_RELEASE).ttl \
  pattern/$(CURRENT_RELEASE).rdf \
  pattern/$(CURRENT_RELEASE).ttl \
  role/$(CURRENT_RELEASE).rdf \
  role/$(CURRENT_RELEASE).ttl \
  time/$(CURRENT_RELEASE).rdf \
  time/$(CURRENT_RELEASE).ttl \
  tool/$(CURRENT_RELEASE).rdf \
  tool/$(CURRENT_RELEASE).ttl \
  types/$(CURRENT_RELEASE).rdf \
  types/$(CURRENT_RELEASE).ttl \
  uco/$(CURRENT_RELEASE).rdf \
  uco/$(CURRENT_RELEASE).ttl \
  victim/$(CURRENT_RELEASE).rdf \
  victim/$(CURRENT_RELEASE).ttl \
  vocabulary/$(CURRENT_RELEASE).rdf \
  vocabulary/$(CURRENT_RELEASE).ttl

all: \
  $(version_iri_files)

action.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/action/action.ttl \
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
	mv _$@ $@

action.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/action/action.ttl
	cp $< $@

action/$(CURRENT_RELEASE).rdf: \
  action.rdf
	mkdir -p action
	cp $< $@

action/$(CURRENT_RELEASE).ttl: \
  action.ttl
	mkdir -p action
	cp $< $@

analysis.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/analysis/analysis.ttl \
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
	mv _$@ $@

analysis.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/analysis/analysis.ttl
	cp $< $@

analysis/$(CURRENT_RELEASE).rdf: \
  analysis.rdf
	mkdir -p analysis
	cp $< $@

analysis/$(CURRENT_RELEASE).ttl: \
  analysis.ttl
	mkdir -p analysis
	cp $< $@

check: \
  $(version_iri_files)
	# Test that generated RDF-XML is valid XML.
	source $(top_srcdir)/venv/bin/activate \
	  && rdfpipe \
	    --input-format xml \
	    --no-out \
	    action.rdf

clean:
	@rm -f \
	  *.rdf \
	  *.ttl \
	  .*.done.log

configuration.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/configuration/configuration.ttl \
  $(RDF_TOOLKIT_JAR) \
  $(top_srcdir)/src/namespaces.sed
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
	rm __$@
	mv _$@ $@

configuration.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/configuration/configuration.ttl
	cp $< $@

configuration/$(CURRENT_RELEASE).rdf: \
  configuration.rdf
	mkdir -p configuration
	cp $< $@

configuration/$(CURRENT_RELEASE).ttl: \
  configuration.ttl
	mkdir -p configuration
	cp $< $@

core.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/core/core.ttl \
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
	mv _$@ $@

core.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/core/core.ttl
	cp $< $@

core/$(CURRENT_RELEASE).rdf: \
  core.rdf
	mkdir -p core
	cp $< $@

core/$(CURRENT_RELEASE).ttl: \
  core.ttl
	mkdir -p core
	cp $< $@

identity.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/identity/identity.ttl \
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
	mv _$@ $@

identity.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/identity/identity.ttl
	cp $< $@

identity/$(CURRENT_RELEASE).rdf: \
  identity.rdf
	mkdir -p identity
	cp $< $@

identity/$(CURRENT_RELEASE).ttl: \
  identity.ttl
	mkdir -p identity
	cp $< $@

location.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/location/location.ttl \
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
	mv _$@ $@

location.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/location/location.ttl
	cp $< $@

location/$(CURRENT_RELEASE).rdf: \
  location.rdf
	mkdir -p location
	cp $< $@

location/$(CURRENT_RELEASE).ttl: \
  location.ttl
	mkdir -p location
	cp $< $@

marking.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/marking/marking.ttl \
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
	mv _$@ $@

marking.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/marking/marking.ttl
	cp $< $@

marking/$(CURRENT_RELEASE).rdf: \
  marking.rdf
	mkdir -p marking
	cp $< $@

marking/$(CURRENT_RELEASE).ttl: \
  marking.ttl
	mkdir -p marking
	cp $< $@

observable.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/observable/observable.ttl \
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
	mv _$@ $@

observable.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/observable/observable.ttl
	cp $< $@

observable/$(CURRENT_RELEASE).rdf: \
  observable.rdf
	mkdir -p observable
	cp $< $@

observable/$(CURRENT_RELEASE).ttl: \
  observable.ttl
	mkdir -p observable
	cp $< $@

pattern.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/pattern/pattern.ttl \
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
	mv _$@ $@

pattern.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/pattern/pattern.ttl
	cp $< $@

pattern/$(CURRENT_RELEASE).rdf: \
  pattern.rdf
	mkdir -p pattern
	cp $< $@

pattern/$(CURRENT_RELEASE).ttl: \
  pattern.ttl
	mkdir -p pattern
	cp $< $@

role.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/role/role.ttl \
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
	mv _$@ $@

role.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/role/role.ttl
	cp $< $@

role/$(CURRENT_RELEASE).rdf: \
  role.rdf
	mkdir -p role
	cp $< $@

role/$(CURRENT_RELEASE).ttl: \
  role.ttl
	mkdir -p role
	cp $< $@

time.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/time/time.ttl \
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
	mkdir -p time
	mv _$@ $@

time.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/time/time.ttl
	cp $< $@

time/$(CURRENT_RELEASE).rdf: \
  time.rdf
	mkdir -p time
	cp $< $@

time/$(CURRENT_RELEASE).ttl: \
  time.ttl
	mkdir -p time
	cp $< $@

tool.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/tool/tool.ttl \
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
	mv _$@ $@

tool.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/tool/tool.ttl
	cp $< $@

tool/$(CURRENT_RELEASE).rdf: \
  tool.rdf
	mkdir -p tool
	cp $< $@

tool/$(CURRENT_RELEASE).ttl: \
  tool.ttl
	mkdir -p tool
	cp $< $@

types.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/types/types.ttl \
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
	mv _$@ $@

types.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/types/types.ttl
	cp $< $@

types/$(CURRENT_RELEASE).rdf: \
  types.rdf
	mkdir -p types
	cp $< $@

types/$(CURRENT_RELEASE).ttl: \
  types.ttl
	mkdir -p types
	cp $< $@

uco.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/master/uco.ttl \
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
	mkdir -p uco
	mv _$@ $@

uco.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/master/uco.ttl
	cp $< $@

uco/$(CURRENT_RELEASE).rdf: \
  uco.rdf
	mkdir -p uco
	cp $< $@

uco/$(CURRENT_RELEASE).ttl: \
  uco.ttl
	mkdir -p uco
	cp $< $@

victim.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/victim/victim.ttl \
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
	mv _$@ $@

victim.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/victim/victim.ttl
	cp $< $@

victim/$(CURRENT_RELEASE).rdf: \
  victim.rdf
	mkdir -p victim
	cp $< $@

victim/$(CURRENT_RELEASE).ttl: \
  victim.ttl
	mkdir -p victim
	cp $< $@

vocabulary.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/vocabulary/vocabulary.ttl \
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
	  --huge \
	  --noout \
	  _$@
	rm __$@
	mkdir -p vocabulary
	mv _$@ $@

vocabulary.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/uco/vocabulary/vocabulary.ttl
	cp $< $@

vocabulary/$(CURRENT_RELEASE).rdf: \
  vocabulary.rdf
	mkdir -p vocabulary
	cp $< $@

vocabulary/$(CURRENT_RELEASE).ttl: \
  vocabulary.ttl
	mkdir -p vocabulary
	cp $< $@
