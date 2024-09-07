FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    build-essential \
    libreadline-dev \
    unzip \
    libzzip-dev \
    sudo \
    curl \
    wget \
    git \
    nano \
    luarocks

RUN luarocks install luafilesystem
RUN luarocks install lunajson
RUN luarocks install luazip

RUN lua -v && luarocks --version
RUN echo 'root:docker' | chpasswd
RUN echo 'ubuntu:docker' | chpasswd

USER ubuntu
WORKDIR /home/ubuntu/pues

ADD . /home/ubuntu/pues

RUN echo 'test() {\nlua /home/ubuntu/pues/pues/main.lua "$@"\n}' >> /home/ubuntu/.bashrc

CMD ["/bin/bash"]
