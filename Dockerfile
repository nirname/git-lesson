FROM ubuntu

RUN apt-get update && apt-get install -y git

COPY cli /cli
COPY tasks /tasks

ENV PATH="/cli/:${PATH}"

# RUN /bin/bash /cli/init