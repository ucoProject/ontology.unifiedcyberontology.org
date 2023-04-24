#!/usr/bin/sed

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

# This set of sed commands is intended to expand XML Entities found to
# be used but not defined in rdf-toolkit output.

s_&action;_https://ontology.unifiedcyberontology.org/uco/action/_g
s_&analysis;_https://ontology.unifiedcyberontology.org/uco/analysis/_g
s_&co;_http://purl.org/co/_g
s_&configuration;_https://ontology.unifiedcyberontology.org/uco/configuration/_g
s_&core;_https://ontology.unifiedcyberontology.org/uco/core/_g
s_&identity;_https://ontology.unifiedcyberontology.org/uco/identity/_g
s_&location;_https://ontology.unifiedcyberontology.org/uco/location/_g
s_&marking;_https://ontology.unifiedcyberontology.org/uco/marking/_g
s_&observable;_https://ontology.unifiedcyberontology.org/uco/observable/_g
s_&owl;_http://www.w3.org/2002/07/owl#_g
s_&pattern;_https://ontology.unifiedcyberontology.org/uco/pattern/_g
s_&rdf;_http://www.w3.org/1999/02/22-rdf-syntax-ns#_g
s_&rdfs;_http://www.w3.org/2000/01/rdf-schema#_g
s_&role;_https://ontology.unifiedcyberontology.org/uco/role/_g
s_&sh;_http://www.w3.org/ns/shacl#_g
s_&time;_https://ontology.unifiedcyberontology.org/uco/time/_g
s_&tool;_https://ontology.unifiedcyberontology.org/uco/tool/_g
s_&types;_https://ontology.unifiedcyberontology.org/uco/types/_g
s_&uco-co;_https://ontology.unifiedcyberontology.org/co/_g
s_&uco-owl;_https://ontology.unifiedcyberontology.org/owl/_g
s_&victim;_https://ontology.unifiedcyberontology.org/uco/victim/_g
s_&vocabulary;_https://ontology.unifiedcyberontology.org/uco/vocabulary/_g
s_&xsd;_http://www.w3.org/2001/XMLSchema#_g
