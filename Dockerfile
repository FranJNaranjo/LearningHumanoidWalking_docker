# syntax=docker/dockerfile:1 
FROM ubuntu:24.04

# https://qiita.com/haessal/items/0a83fe9fa1ac00ed5ee9
ENV DEBCONF_NOWARNINGS=yes
# https://qiita.com/yagince/items/deba267f789604643bab
ENV DEBIAN_FRONTEND=noninteractive
# https://qiita.com/jacob_327/items/e99ca1cf8167d4c1486d
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

# https://stackoverflow.com/a/25423366
SHELL ["/bin/bash", "-c"]

# https://genzouw.com/entry/2019/09/04/085135/1718/
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

# Install basic packages
RUN apt-get update -qq && apt-get install -y sudo aptitude build-essential lsb-release wget gnupg2 curl emacs
RUN aptitude update -q

# requirements: https://github.com/rohanpsingh/LearningHumanoidWalking

# update pip y setuptools
RUN apt-get update -qq && apt-get install -y python3-pip


# https://askubuntu.com/questions/1465218/pip-error-on-ubuntu-externally-managed-environment-%C3%97-this-environment-is-extern

# install required packages
RUN python3 -m pip install mujoco==3.2.2 --break-system-packages
RUN python3 -m pip install ray==2.40.0 --break-system-packages
RUN python3 -m pip install torch==2.5.1 --break-system-packages
RUN python3 -m pip install intel-openmp --break-system-packages
RUN python3 -m pip install mujoco-python-viewer --break-system-packages
RUN python3 -m pip install transforms3d --break-system-packages
RUN python3 -m pip install scipy --break-system-packages

RUN python3 -m pip install matplotlib --break-system-packages
RUN python3 -m pip install dm_control==1.0.22 --break-system-packages


RUN apt-get update -qq && apt-get install -y python3-tk

# Install Pytorch
RUN python3 -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu --break-system-packages

# Install git
RUN apt update -q -qq && \
    apt install -y git openssh-client && \
    apt clean && \
    rm -rf /var/lib/apt/lists/
RUN mkdir -p ~/.ssh && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts
