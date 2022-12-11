FROM continuumio/miniconda3

RUN apt-get update

# install pip package
RUN pip3 install --upgrade pip
RUN pip3 install notebook