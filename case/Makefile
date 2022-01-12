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
  .symlinking.done.log \
  case.rdf \
  case.ttl \
  investigation.rdf \
  investigation.ttl \
  vocabulary.rdf \
  vocabulary.ttl

.PHONY: \
  clean-symlinking

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

# NOTE: In CASE, this script is only called on the investigation.ttl
# file, because:
# * gendocs does not build documentation for datatypes, and
# * UCO concepts will not require symlinks to be constructed for the
#   benefit of .htaccess redirects.  UCO IRIs will not visit CASE's
#   server, and links within the gendocs HTML files are already
#   relatively-pathed to the gendocs HTML file name pattern.
.symlinking.done.log: \
  .documentation.done.log
	source $(top_srcdir)/venv/bin/activate \
	  && python3 $(top_srcdir)/src/map_concepts_as_symlinks.py \
	    $(top_srcdir)/dependencies/CASE/ontology/investigation/investigation.ttl
	# Spot-check one concept's link.
	test -r documentation/class-investigationInvestigativeAction.html
	test -L investigation/InvestigativeAction.html
	test -r investigation/InvestigativeAction.html
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
