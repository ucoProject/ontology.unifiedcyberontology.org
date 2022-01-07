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

RDF_TOOLKT_JAR := $(top_srcdir)/dependencies/CASE/lib/rdf-toolkit.jar

all: \
  .documentation.done.log \
  case.rdf \
  case.ttl \
  investigation.rdf \
  investigation.ttl \
  vocabulary.rdf \
  vocabulary.ttl

.documentation.done.log: \
  $(top_srcdir)/.venv.done.log \
  $(top_srcdir)/dependencies/CASE/tests/case_monolithic.ttl
	rm -rf documentation
	mkdir documentation
	source $(top_srcdir)/venv/bin/activate \
	  && ontospy gendocs \
	    --outputpath $$PWD/documentation \
	    --theme united \
	    --title case-0.5.0-docs \
	    --type 2 \
	    $(top_srcdir)/dependencies/CASE/tests/case_monolithic.ttl
	touch $@

case.rdf: \
  $(top_srcdir)/dependencies/CASE/ontology/master/case.ttl \
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

case.ttl: \
  $(top_srcdir)/dependencies/CASE/ontology/master/case.ttl
	cp $< $@

clean:
	@rm -f \
	  *.rdf \
	  *.ttl \
	  .*.done.log
	@rm -rf \
	  documentation

investigation.rdf: \
  $(top_srcdir)/dependencies/CASE/ontology/investigation/investigation.ttl \
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

investigation.ttl: \
  $(top_srcdir)/dependencies/CASE/ontology/investigation/investigation.ttl
	cp $< $@

vocabulary.rdf: \
  $(top_srcdir)/dependencies/CASE/ontology/vocabulary/vocabulary.ttl \
  $(RDF_TOOLKT_JAR)
	java -jar $(RDF_TOOLKT_JAR) \
	  --inline-blank-nodes \
	  --source $< \
	  --source-format turtle \
	  --target _$@ \
	  --target-format rdf-xml
	mv _$@ $@

vocabulary.ttl: \
  $(top_srcdir)/dependencies/CASE/ontology/vocabulary/vocabulary.ttl
	cp $< $@
