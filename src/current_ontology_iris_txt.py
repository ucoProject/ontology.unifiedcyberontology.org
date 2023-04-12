#!/usr/bin/env python3

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

import argparse
from typing import Set

from rdflib import Graph, OWL, RDF, URIRef

NS_OWL = OWL
NS_RDF = RDF


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--debug', action="store_true")
    parser.add_argument('--ontology-base', default="https://ontology.unifiedcyberontology.org", help="Restrict mapped concepts to start with only this domain.")
    parser.add_argument('out_txt', type=str, help="Output file.")
    parser.add_argument('in_ttl', type=str, help="Monolithic build of ontology.")
    args = parser.parse_args()

    graph = Graph()
    graph.parse(args.in_ttl)

    # Find all ontology-level IRIs and version IRIs.
    # (These IRIs are for the OWL ontologies and their versions, not for classes, shapes, etc.)
    n_ontology_concepts: Set[URIRef] = set()
    for triple in graph.triples((None, NS_OWL.backwardCompatibleWith, None)):
        assert isinstance(triple[0], URIRef)
        assert isinstance(triple[2], URIRef)
        n_ontology_concepts.add(triple[0])
        n_ontology_concepts.add(triple[2])
    for triple in graph.triples((None, NS_OWL.imports, None)):
        assert isinstance(triple[0], URIRef)
        assert isinstance(triple[2], URIRef)
        n_ontology_concepts.add(triple[0])
        n_ontology_concepts.add(triple[2])
    for triple in graph.triples((None, NS_OWL.incompatibleWith, None)):
        assert isinstance(triple[0], URIRef)
        assert isinstance(triple[2], URIRef)
        n_ontology_concepts.add(triple[0])
        n_ontology_concepts.add(triple[2])
    for triple in graph.triples((None, NS_OWL.priorVersion, None)):
        assert isinstance(triple[0], URIRef)
        assert isinstance(triple[2], URIRef)
        n_ontology_concepts.add(triple[0])
        n_ontology_concepts.add(triple[2])
    for triple in graph.triples((None, NS_OWL.versionIRI, None)):
        assert isinstance(triple[0], URIRef)
        assert isinstance(triple[2], URIRef)
        n_ontology_concepts.add(triple[0])
        n_ontology_concepts.add(triple[2])
    for triple in graph.triples((None, NS_OWL.versionInfo, None)):
        assert isinstance(triple[0], URIRef)
        n_ontology_concepts.add(triple[0])
    for triple in graph.triples((None, NS_RDF.type, NS_OWL.Ontology)):
        assert isinstance(triple[0], URIRef)
        n_ontology_concepts.add(triple[0])

    with open(args.out_txt, "w") as out_fh:
        for n_ontology_concept in sorted(n_ontology_concepts):
            ontology_concept_iri = n_ontology_concept.toPython()
            if not ontology_concept_iri.startswith(args.ontology_base):
                continue
            print(ontology_concept_iri, file=out_fh)


if __name__ == "__main__":
    main()
