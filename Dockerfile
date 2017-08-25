FROM ubuntu

RUN apt-get update && apt-get install -y git
COPY cli /cli

RUN /bin/bash /cli/init