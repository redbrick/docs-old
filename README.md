# Docs

[![Documentation Status](https://readthedocs.org/projects/redbrick/badge/?version=latest)](http://redbrick.readthedocs.io/en/latest/?badge=latest)
[![CircleCI](https://circleci.com/gh/redbrick/docs.svg?style=svg)](https://circleci.com/gh/redbrick/docs)
[![Code Climate](https://codeclimate.com/github/redbrick/docs/badges/gpa.svg)](https://codeclimate.com/github/redbrick/docs)

Documentation for [Redbrick](https://redbrick.dcu.ie)

Available at [docs.redbrick.dcu.ie](https://docs.redbrick.dcu.ie) and at the [readthedocs mirror](https://redbrick.readthedocs.io)
The readthedocs mirror is automatically deployed on commit to `master`.
The docs site is a scheduled cron job on halfpint that `git pull && mkdics
build` once an hour to up date the docs.

The docs are built using mkdocs.
To bring up a local server with a copy of the docs just run

``` bash
docker-compose up server
```

To build the docs just run

``` bash
docker-compose up build-docs
```

## Testing locally

When you do a change make sure it works by building it locally.
Run

``` yaml
docker-compose up build-docs
docker-compose up test
```

This will test the docs build and if there are any dead links in them
