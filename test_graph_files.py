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

import logging
from pathlib import Path
from typing import Set

from rdflib import OWL, Graph, URIRef

NS_OWL = OWL

top_srcdir = Path(__file__).parent


def test_version_iri_graph_files() -> None:
    """
    This test confirms that the generated versionIRI files correspond to their denoted versions.
    """
    n_versions: Set[URIRef] = set()

    ontology_iris_archive_txt_path = top_srcdir / "ontology_iris_archive.txt"
    with ontology_iris_archive_txt_path.open("r") as archive_fh:
        for line in archive_fh:
            cleaned_line = line.strip()
            if cleaned_line[-1].isdigit():
                n_versions.add(URIRef(cleaned_line))
    assert len(n_versions) > 0

    for n_version in sorted(n_versions):
        version_relative_path_str = str(n_version).split(".org/")[1]
        for extension in [".rdf", ".ttl"]:
            version_iri_graph_path = top_srcdir / (
                version_relative_path_str + extension
            )
            logging.debug("version_iri_graph_path = %s.", version_iri_graph_path)
            version_graph = Graph()
            version_graph.parse(version_iri_graph_path)
            assert len(version_graph) > 0

            version_iri_found = False
            for triple in version_graph.triples((None, NS_OWL.versionIRI, n_version)):
                version_iri_found = True
            assert version_iri_found
