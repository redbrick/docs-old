# Docs

[![Documentation Status](https://readthedocs.org/projects/redbrick/badge/?version=latest)](http://redbrick.readthedocs.io/en/latest/?badge=latest)
[![CircleCI](https://circleci.com/gh/redbrick/docs.svg?style=shield)](https://circleci.com/gh/redbrick/docs)

Documentation for [Redbrick](https://redbrick.dcu.ie)

Available at [docs.redbrick.dcu.ie](https://docs.redbrick.dcu.ie) and at the
[readthedocs](https://redbrick.readthedocs.io).

Docs are automatically deployed on commit to `master` to `readthedocs`

The docs are built using mkdocs. To bring up a local server with a copy of the
docs just run

```bash
docker-compose up docs
```

To build the docs just run

```bash
docker-compose up -d docs
```

## Testing locally

When you make a change make sure it works by building it locally.

Run:

```bash
docker-compose run --rm docs mkdocs build
docker-compose run --rm test
```

This will test the docs build and if there are any dead links in them
