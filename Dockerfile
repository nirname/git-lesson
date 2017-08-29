FROM ubuntu

RUN apt-get update && apt-get install -y git

COPY cli /cli
COPY tasks /tasks

COPY .bashrc /root/.bashrc

ENV PATH="/cli/:${PATH}"