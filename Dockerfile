FROM openjdk:11
# FROM ubuntu:latest

# utils
RUN apt-get update
RUN apt-get install -y curl unzip zip

# python3
RUN apt-get install -y python3-pip

# install pip package
RUN pip3 install --upgrade pip
RUN pip3 install notebook pandas loguru tabula-py