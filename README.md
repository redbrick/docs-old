# Docs [![Documentation Status](https://readthedocs.org/projects/redbrick/badge/?version=latest)](http://redbrick.readthedocs.io/en/latest/?badge=latest)[![CircleCI](https://circleci.com/gh/redbrick/docs.svg?style=svg)](https://circleci.com/gh/redbrick/docs)

Documentation for [Redbrick](https://redbrick.dcu.ie)

Migrated from [dokuwiki](https://docs.redbrick.dcu.ie) to [readthedocs](http://redbrick.readthedocs.io)

## Setup
Run `pip install --user mkdocs`
then clone the repo locally to make changes

## Testing locally
When you do a change make sure it works by building it locally.
Run `mkdocs serve` to start a local server.

## Deployment
Docs are auto deployed to https://readthedocs.io on commit to the `latest`
branch.

## Docker
When testing locally just run
```
docker run -it --rm --name docs -p 8000:8000 -v "$PWD":/usr/src/app redbrick/docs
```
To build the docs just run
```
docker run -it --rm --name docs -v "$PWD":/usr/src/app redbrick/docs mkdocs
```
