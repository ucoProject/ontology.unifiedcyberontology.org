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
import json
from typing import Dict, Set

from rdflib import URIRef


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--ontology-base",
        default="https://ontology.unifiedcyberontology.org",
        help="Restrict mapped concepts to start with only this domain.",
    )
    parser.add_argument("out_json", type=str)
    parser.add_argument(
        "mime_type", type=str, choices={"application/rdf+xml", "text/turtle"}
    )
    parser.add_argument(
        "ontology_iris_archive_txt",
        type=str,
        help="txt file listing all ontology IRIs and version IRIs to expect",
    )
    args = parser.parse_args()

    n_ontology_concepts: Set[URIRef] = set()
    with open(args.ontology_iris_archive_txt, "r") as in_fh:
        for line in in_fh:
            cleaned_line = line.strip()
            if cleaned_line == "":
                continue
            if not cleaned_line.startswith(args.ontology_base):
                continue
            n_ontology_concepts.add(URIRef(cleaned_line))

    mappings: Dict[str, str] = dict()

    file_extension = {
        "application/rdf+xml": ".rdf",
        "text/turtle": ".ttl",
    }[args.mime_type]

    for n_ontology_concept in n_ontology_concepts:
        ontology_concept_iri = n_ontology_concept.toPython()
        ontology_url_path: str = ontology_concept_iri.split("ontology.org")[1]
        mappings[ontology_url_path] = ontology_url_path + file_extension

    with open(args.out_json, "w") as out_fh:
        json.dump(mappings, out_fh, indent=4, sort_keys=True)


if __name__ == "__main__":
    main()
