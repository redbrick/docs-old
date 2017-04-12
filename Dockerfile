FROM python:3-onbuild
WORKDIR /usr/src/app
CMD [ "mkdocs", "serve", "-a", "0.0.0.0:8000" ]
