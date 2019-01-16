FROM ubuntu

RUN apt-get update && apt-get install -y git locales

RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# COPY cli /cli
# COPY tasks /tasks

COPY .bashrc /root/
COPY .gitconf /root/.gitconfig

WORKDIR /tasks
COPY bootstrap.sh .

RUN chmod 700 ./bootstrap.sh && ./bootstrap.sh && rm ./bootstrap.sh # &>/dev/null

# ENV PATH="/cli/:${PATH}"

ENTRYPOINT /bin/bash