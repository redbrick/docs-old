# Docs

[![Documentation Status](https://readthedocs.org/projects/redbrick/badge/?version=latest)](http://redbrick.readthedocs.io/)
[![Build and Validate](https://github.com/redbrick/docs/workflows/Build%20and%20Validate/badge.svg)](https://github.com/redbrick/docs/actions?query=workflow%3A%22Build+and+Validate%22)

Documentation for [Redbrick](https://redbrick.dcu.ie)

Available at [docs.redbrick.dcu.ie](https://docs.redbrick.dcu.ie) and at the
[readthedocs](https://redbrick.readthedocs.io).

Docs are automatically deployed on commit to `master` to `readthedocs`

The docs are built using mkdocs. To bring up a local server with a copy of the
docs just run

```bash
python3 -m venv .venv
chmod +x -R .venv/bin
. .venv/bin/activate
pip install -r requirements.txt
```

## Testing locally

When you make a change make sure it works by building it locally.

Run:

```sh
mkdocs build -s -v
```

This will test the docs build and if there are any dead links in them

To lint the Markdown locally, use this command (downloads very fast):

```bash
docker run --rm -v $(pwd):/docs ruby:2-alpine sh -c 'gem install mdl && mdl /docs/docs/ -s /docs/.markdown.style.rb'
```
