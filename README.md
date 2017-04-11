# Docs
[![Documentation Status](https://readthedocs.org/projects/redbrick/badge/?version=latest)](http://redbrick.readthedocs.io/en/latest/?badge=latest)
[![CircleCI](https://circleci.com/gh/redbrick/docs.svg?style=svg)](https://circleci.com/gh/redbrick/docs)

Documentation for [Redbrick](https://redbrick.dcu.ie)

Available at [docs.redbrick.dcu.ie](https://docs.redbrick.dcu.ie) and at the [readthedocs mirror](https://redbrick.readthedocs.io)

The docs are built using mkdocs.
To bring up a local server with a copy of the docs just run
```
docker-compose up server
```
To build the docs just run
```
docker-compose up build-docs
```

## Testing locally
When you do a change make sure it works by building it locally.
Run
```
docker-compose up build-docs
docker-compose up test
```
This will test the docs build and if there are any dead links in them

## Deployment
Docs are auto deployed to https://readthedocs.io on commit to the `latest` branch.
