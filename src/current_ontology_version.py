#!/usr/bin/env python3

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

import argparse
from typing import Optional

from rdflib import Graph, OWL, URIRef


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "ontology_graph", help="The graph file to read to extract the ontology version."
    )
    parser.add_argument(
        "ontology_iri",
        help="The IRI of the root owl:Ontology.  The versionIRI is assumed to have the ontology IRI, plus a slash, as a string-prefix.",
    )
    args = parser.parse_args()

    graph = Graph()
    graph.parse(args.ontology_graph)

    n_ontology = URIRef(args.ontology_iri)
    n_ontology_version: Optional[URIRef] = None
    for triple in graph.triples((n_ontology, OWL.versionIRI, None)):
        assert isinstance(triple[2], URIRef)
        n_ontology_version = triple[2]
    if n_ontology_version is None:
        raise ValueError("No versionIRI found for requested ontology.")

    ontology_version_iri = str(n_ontology_version)
    version_string = ontology_version_iri.replace(args.ontology_iri + "/", "")

    print(version_string)


if __name__ == "__main__":
    main()
