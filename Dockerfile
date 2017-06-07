FROM python:3-alpine
WORKDIR /usr/src/app
ADD . /usr/src/app
RUN pip install -r requirements.txt
VOLUME /usr/src/app
CMD [ "mkdocs", "serve", "-a", "0.0.0.0:8000" ]
