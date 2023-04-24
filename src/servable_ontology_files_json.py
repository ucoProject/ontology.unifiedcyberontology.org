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
from pathlib import Path
from typing import Set


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--ontology-base",
        default="https://ontology.unifiedcyberontology.org",
        help="Restrict mapped concepts to start with only this domain.",
    )
    parser.add_argument("out_json", type=argparse.FileType("x"))
    parser.add_argument("top_srcdir")
    parser.add_argument("archive_txt", type=argparse.FileType("r"))
    args = parser.parse_args()

    top_srcdir_path: Path = Path(args.top_srcdir).absolute()
    assert top_srcdir_path.is_dir()

    graph_paths: Set[str] = set()
    for line in args.archive_txt:
        concept_iri = line.strip()

        # url_path has a leading "/".
        url_path: str = concept_iri.replace(args.ontology_base, "")

        for graph_file_extension in [".rdf", ".ttl"]:
            graph_path: str = url_path + graph_file_extension
            graph_abspath: Path = top_srcdir_path / (graph_path[1:])
            if not graph_abspath.exists():
                # The Makefile chain should have generated this file by now.
                raise FileNotFoundError(graph_abspath)
            graph_paths.add(graph_path)

    json.dump(sorted(graph_paths), args.out_json, indent=4)


if __name__ == "__main__":
    main()
