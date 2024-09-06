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

RUN su ubuntu -c "git clone https://github.com/johron/pues /home/ubuntu/pues"

CMD ["/bin/bash"]
