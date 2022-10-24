#!/usr/bin/env python3

# NOTICE
# This software was produced for the U.S. Government under contract FA8702-22-C-0001,
# and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007)
# ©2021 The MITRE Corporation. All Rights Reserved.

import argparse
import logging
import os
from typing import Dict

import rdflib.plugins.sparql

def debug_printlinks(symlinks: Dict[str, str]) -> None:
    """Outputs the contents of the symlinks dict, for debugging only."""

    for src, dst in symlinks.items():
        logging.debug(repr(src) + " -> " + repr(dst))

def create_symlinks(top_srcdir: str, symlinks: Dict[str, str]) -> None:
    """Create symlinks based on generated gendoc -> web path."""

    _pre_cwd = os.getcwd()
    logging.debug("_pre_cwd = %r.", _pre_cwd)
    os.chdir(top_srcdir)
    logging.debug("os.getcwd() = %r.", os.getcwd())

    # TODO: research if more flags need to be specified for the symlink() func, what if we lack perms etc?
    for src, dst in symlinks.items():
        namespace_dir = os.path.dirname(dst)
        concept_file_basename = os.path.basename(dst)
        os.makedirs(namespace_dir, exist_ok=True)
        os.chdir(namespace_dir)
        logging.debug("os.getcwd() = %r.", os.getcwd())
        if not os.path.isfile(src):
            logging.error("os.getcwd() = %r.", os.getcwd())
            raise FileNotFoundError(src)
        try:
            os.symlink(src, concept_file_basename)
        except Exception as e:
            print(f'there was an error {e}')
        os.chdir(top_srcdir)

    # end method with resetting cwd
    os.chdir(_pre_cwd)
    logging.debug("os.getcwd() = %r.", os.getcwd())

def main() -> None:
    # parse arguments for ontology file we are preparing links for
    parser = argparse.ArgumentParser()
    parser.add_argument('inTtl', type=str, help='ttl file to build sym-links off of')
    parser.add_argument('--debug', action="store_true")
    args = parser.parse_args()

    logging.basicConfig(level=logging.DEBUG if args.debug else logging.INFO)

    # allow query on ontology file
    graph = rdflib.Graph()
    graph.parse(args.inTtl)

    # Inherit prefixes defined in input context dictionary.
    nsdict = {k:v for (k,v) in graph.namespace_manager.namespaces()}

    # select class and property concepts from ontology -- dict(prefix : query)
    queries = dict()
    queries["class"] = "SELECT ?nConcept WHERE { ?nConcept a owl:Class . }"
    queries["prop"] = "SELECT ?nConcept WHERE {{ ?nConcept a owl:DatatypeProperty . } UNION { ?nConcept a owl:ObjectProperty . }}"

    # hold gendoc location, assoicated to symlinked path -- dict(gendocs-path : symlink)
    symlinks: Dict[str, str] = dict()

    # generate paths for symlink src/dst locations
    tally = 0
    for prefix, query in queries.items():
        select_query_object = rdflib.plugins.sparql.processor.prepareQuery(query, initNs=nsdict)
        for (row_no, row) in enumerate(graph.query(select_query_object)):
            tally = row_no + 1
            concept_iri = row[0].toPython()

            # determine URL path (file path, relative to service root within file system)
            # the split-point is the string in common to CASE's and UCO's IRIs.
            url_path = concept_iri.split("ontology.org/")[1] + ".html"

            # determine path to symlink target (gendocs HTML file), relative to basename of URL path
            iri_parts = concept_iri.split('/')
            gendocs_target = f"../documentation/{prefix}-{iri_parts[-2]}{iri_parts[-1].lower()}.html"

            # format gendoc -> symlink (src, dst) combos
            symlinks[gendocs_target] = url_path

    if tally == 0:
        logging.warning(f"Found neither classes nor properties in input graph-file %r." % args.inTtl)

    top_srcdir = os.path.dirname(os.path.dirname(__file__))
    debug_printlinks(symlinks)
    create_symlinks(top_srcdir, symlinks)

if __name__ == "__main__":
    main()
