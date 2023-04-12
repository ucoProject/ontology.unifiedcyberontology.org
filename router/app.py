#!/usr/bin/env python3

# NOTICE
# This software was produced for the U.S. Government under contract FA8702-22-C-0001,
# and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007)
# ©2021 The MITRE Corporation. All Rights Reserved.

import pathlib
from flask import Flask, request, redirect, abort, send_file
from werkzeug.wrappers import Response as BaseResponse
from datetime import datetime
import string
import json

app = Flask(__name__)

srcdir = pathlib.Path(__file__).parent
top_srcdir = srcdir / ".."

# load html mappings
with (top_srcdir / 'iri_mappings_to_html.json').open('r') as fp:
    html = json.load(fp)

# load rdf mappings
with (top_srcdir / 'iri_mappings_to_rdf.json').open('r') as fp:
    rdf = json.load(fp)

# load ttl mappings
with (top_srcdir / 'iri_mappings_to_ttl.json').open('r') as fp:
    ttl = json.load(fp)

@app.route("/")
def root() -> BaseResponse:
    '''Routes the root '/' of the host to the index of the docs'''

    # redirect when we find a match based on SSL
    if request.is_secure:
        return redirect(f'https://{request.host}/documentation/index.html', 301)
    else:
        return redirect(f'http://{request.host}/documentation/index.html', 301)

@app.route("/<ontology>/<path:target>", methods=['GET'])
def router(ontology: str, target: str) -> BaseResponse:
    '''Routes data through the file system to the appropriate documentation'''
    content_type = request.headers.get('Accept')

    # override content_type with extensions from the target for restful lookups
    file_request = False
    if 'ttl' in target or 'rdf' in target:
        file_request = True
        target_parts = target.rsplit(".", 1)
        target = target_parts[0]
        content_type = 'turtle' if target_parts[1] == 'ttl' else 'rdf'

    # check the headers for 'rdf' in the content-type
    if content_type is not None and 'rdf' in content_type:
        if f"/{ontology}/{target}" in rdf:
            location = rdf[f"/{ontology}/{target}"]
            if file_request:
                return send_file(".." + rdf[f"/{ontology}/{target}"], as_attachment=True)

            if request.is_secure:
                return redirect(f'https://{request.host}{location}', 301)
            else:
                return redirect(f'http://{request.host}{location}', 301)

    # check the headers for 'turtle' in the content type
    if content_type is not None:
        if 'turtle' in content_type or 'ttl' in content_type:
            if f"/{ontology}/{target}" in ttl:
                location = ttl[f"/{ontology}/{target}"]
                if file_request:
                    return send_file(".." + ttl[f"/{ontology}/{target}"], as_attachment=True)

                if request.is_secure:
                    return redirect(f'https://{request.host}{location}', 301)
                else:
                    return redirect(f'http://{request.host}{location}', 301)

    # blanket check mappings for HTML
    if f"/{ontology}/{target}" in html:
        location = html[f"/{ontology}/{target}"]
        if request.is_secure:
            return redirect(f'https://{request.host}{location}', 301)
        else:
            return redirect(f'http://{request.host}{location}', 301)

    abort(404)
