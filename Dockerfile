FROM python:3-alpine
WORKDIR /usr/src/app
ADD . /usr/src/app
RUN pip install mkdocs
CMD [ "mkdocs", "serve", "-a", "0.0.0.0:8000" ]
