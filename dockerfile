FROM python:3.12.1-slim-bookworm

RUN apt update 
RUN apt install net-tools iputils-ping ffmpeg nano htop -y
RUN pip3 install awscli

WORKDIR /scripts
COPY Run.sh Run.sh
RUN chmod +x Run.sh

WORKDIR /recordings
ENTRYPOINT [ "/scripts/Run.sh" ] 