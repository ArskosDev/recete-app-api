#Add name of the docker image and specific tag to run the image
FROM python:3.9-alpine3.13

#Define the maintainer
LABEL maintainer="arskos.com"

#Recommanded when you run python in a container: 
#Prevents the buffer of the output
#The output will be printed directly to the console
#To prevent any delays in output
ENV PYTHONUNBUFFERED 1

#copy from local machine to /path/ inside container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
#copy the app directory to container
COPY ./app/* /app
#set working directory: 
#default dir from which the commands will run from 
#when we run in docker image
WORKDIR /app
EXPOSE 8000

#
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/path/bin:$PATH"

USER django-user


