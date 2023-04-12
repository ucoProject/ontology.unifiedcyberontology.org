#!/usr/bin/make -f

SHELL := /bin/bash

PY3 ?= python3

all: \
  deploy

deploy: \
  .venv.done.log

.venv.done.log: \
  requirements.txt
	rm -rf venv
	$(PY3) -m venv \
		venv
	source venv/bin/activate \
		&& pip install \
			--upgrade \
			pip
	source venv/bin/activate \
		&& pip install \
			--requirement requirements.txt
	touch $@

clean:
	rm -rf venv ||:
	find . -type d -name __pycache__ -exec rm -r {} \+ ||:
