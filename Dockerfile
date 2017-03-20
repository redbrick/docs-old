FROM python:3
RUN pip install mkdocs
WORKDIR /usr/src/app
CMD [ "mkdocs", "serve", "-a", "0.0.0.0:8000" ]
