#!/usr/bin/env python3

# NOTICE
# This software was produced for the U.S. Government under contract FA8702-22-C-0001,
# and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007)
# ©2021 The MITRE Corporation. All Rights Reserved.
#
#
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

import pathlib
from flask import Flask, request, redirect, abort, send_file
from werkzeug.wrappers import Response as BaseResponse
from datetime import datetime
from typing import Optional, Set
import string
import json

app = Flask(__name__)

srcdir = pathlib.Path(__file__).parent
top_srcdir = srcdir / ".."

# load html mappings
with (top_srcdir / "iri_mappings_to_html.json").open("r") as fp:
    html = json.load(fp)

# load rdf mappings
with (top_srcdir / "iri_mappings_to_rdf.json").open("r") as fp:
    rdf = json.load(fp)

# load ttl mappings
with (top_srcdir / "iri_mappings_to_ttl.json").open("r") as fp:
    ttl = json.load(fp)

# load expected files
servable_ontology_files: Set[str] = set()
with (top_srcdir / "servable_ontology_files.json").open("r") as fp:
    _tmp = json.load(fp)
    for servable_ontology_file in _tmp:
        servable_ontology_files.add(servable_ontology_file)


@app.route("/")
def root() -> BaseResponse:
    """Routes the root '/' of the host to the index of the docs"""

    # redirect when we find a match, using only HTTPS scheme to avoid
    # Flask+NGINX 80/443 redirect loop
    return redirect(f"https://{request.host}/documentation/index.html", 301)


@app.route("/<path:target>", methods=["GET"])
def router(target: str) -> BaseResponse:
    """Routes data through the file system to the appropriate documentation"""

    target_path: str = f"/{target}"

    # If requesting a listed file, immediately use send_file.
    # If an unlisted file, the end of this function will 404.
    if target_path in servable_ontology_files:
        return send_file(".." + target_path, as_attachment=True)

    # content_type throughout this function will either be None, or will be spelled as an IANA media type.
    content_type: Optional[str] = request.headers.get("Accept")

    def _redirect_301(location: str) -> BaseResponse:
        # Use only HTTPS scheme to avoid Flask+NGINX 80/443 redirect loop
        return redirect(f"https://{request.host}{location}", 301)

    # override content_type with extensions from the target for restful lookups
    if target.endswith(".ttl") or target.endswith(".rdf"):
        target_parts = target.rsplit(".", 1)
        content_type = (
            "text/turtle" if target_parts[1] == "ttl" else "application/rdf+xml"
        )

    # Direct next by Accepts: content negotiation
    if content_type == "application/rdf+xml":
        # headers requested RDF-XML content
        if target_path in rdf:
            return _redirect_301(rdf[target_path])
    elif content_type == "text/turtle":
        # headers requested Turtle content
        if target_path in ttl:
            return _redirect_301(ttl[target_path])
    elif content_type == "text/html":
        # headers requested HTML content
        if target_path in html:
            return _redirect_301(html[target_path])

    # Lacking a recognized content type request, try some known User-Agent patterns.
    user_agent: Optional[str] = request.headers.get("User-Agent")
    if isinstance(user_agent, str):
        # For agents presenting like browsers, serve HTML.
        if user_agent.startswith("Mozilla/"):
            if target_path in html:
                return _redirect_301(html[target_path])
        # For all others, assume agent is ontology-specialized
        # software, or otherwise desiring machine-readable content.
        # Serve RDF-XML per minimal requirement "RDF/XML is the only
        # required exchange syntax for OWL"
        # ( https://www.w3.org/2007/OWL/wiki/XML_Serialization ).
        elif target_path in rdf:
            return _redirect_301(rdf[target_path])

    # blanket check mappings for HTML
    if target_path in html:
        return _redirect_301(html[target_path])

    abort(404)
