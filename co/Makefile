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
  co.rdf

all: \
  $(rdf_files) \
  .symlinking.done.log \
  co.ttl

.PHONY: \
  clean-symlinking

.documentation.done.log: \
  $(top_srcdir)/.venv.done.log \
  $(top_srcdir)/dependencies/UCO/ontology/co/co.ttl
	rm -rf documentation
	mkdir documentation
	source $(top_srcdir)/venv/bin/activate \
	  && ontospy gendocs \
	    --outputpath $$PWD/documentation \
	    --theme darkly \
	    --title co-shapes-docs \
	    --type 2 \
	    $(top_srcdir)/dependencies/UCO/ontology/co/co.ttl
	touch $@

.%.symlinking.done.log: \
  %.ttl \
  .documentation.done.log
	source $(top_srcdir)/venv/bin/activate \
	  && python3 $(top_srcdir)/src/map_concepts_as_symlinks.py \
	    $<

.symlinking.done.log: \
	.co.symlinking.done.log

check: \
  $(rdf_files)
	# Test that generated RDF-XML is valid XML.
	source $(top_srcdir)/venv/bin/activate \
	  && rdfpipe \
	    --input-format xml \
	    --no-out \
	    co.rdf

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

co.rdf: \
  $(top_srcdir)/dependencies/UCO/ontology/co/co.ttl \
  $(RDF_TOOLKT_JAR) \
  $(top_srcdir)/src/namespaces.sed
	java -jar $(RDF_TOOLKT_JAR) \
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

co.ttl: \
  $(top_srcdir)/dependencies/UCO/ontology/co/co.ttl
	cp $< $@
