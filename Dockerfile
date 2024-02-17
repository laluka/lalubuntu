# docker build --no-cache --tag lalubuntu .
# docker run --rm -it --net=host lalubuntu zsh

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Requirements
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y curl wget git vim tmux sudo tzdata

# Sources
# RUN git clone https://github.com/laluka/lalubuntu && sudo mv lalubuntu /opt/lalubuntu
COPY . /opt/lalubuntu

# Pre-Install
WORKDIR /opt/lalubuntu
RUN bash -x pre-install.sh
ENV PATH="/root/.local/bin:${PATH}"

# Install
RUN ansible-playbook -vvv -i inventory.ini --ask-become main.yml --tags base-install
RUN ansible-playbook -vvv -i inventory.ini --ask-become main.yml --tags offensive-stuff
# RUN ansible-playbook -vvv -i inventory.ini --ask-become main.yml --tags gui-tools
# RUN ansible-playbook -vvv -i inventory.ini --ask-become main.yml --tags hardening
