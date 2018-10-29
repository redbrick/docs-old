# Docs

[![Documentation Status](https://readthedocs.org/projects/redbrick/badge/?version=latest)](http://redbrick.readthedocs.io/en/latest/?badge=latest)
[![Code Climate](https://codeclimate.com/github/redbrick/docs/badges/gpa.svg)](https://codeclimate.com/github/redbrick/docs)
[![CircleCI](https://circleci.com/gh/redbrick/docs.svg?style=shield)](https://circleci.com/gh/redbrick/docs)

Documentation for [Redbrick](https://redbrick.dcu.ie)

Available at [docs.redbrick.dcu.ie](https://docs.redbrick.dcu.ie) and at the [readthedocs mirror](https://redbrick.readthedocs.io)
The readthedocs mirror is automatically deployed on commit to `master`.
The docs site is a scheduled cron job on halfpint that `git pull && mkdics
build` once an hour to up date the docs.

The docs are built using mkdocs.
To bring up a local server with a copy of the docs just run

``` bash
docker-compose up docs
```

To build the docs just run

``` bash
docker-compose run --rm docs mkdocs build
```

## Testing locally

When you make a change make sure it works by building it locally.
Run

```bash
docker-compose run --rm docs mkdocs build
docker-compose run --rm test
```

This will test the docs build and if there are any dead links in them
