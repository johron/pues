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

RUN echo "ubuntu   ALL = NOPASSWD: ALL" >> /etc/sudoers

RUN lua -v && luarocks --version
RUN echo 'root:docker' | chpasswd

USER ubuntu
WORKDIR /home/ubuntu/pues

ADD . /home/ubuntu/pues

RUN echo 'build() { [[ $(pwd) == "/home/ubuntu/pues" ]] && sudo luarocks make /home/ubuntu/pues/rockspecs/pues-scm-1.rockspec || echo "Error: This command can only be run from /home/ubuntu/pues"; }' >> /home/ubuntu/.bashrc
RUN echo 'run() { [[ $(pwd) == "/home/ubuntu/pues" ]] && lua /home/ubuntu/pues/pues/main.lua "$@" || echo "Error: This command can only be run from /home/ubuntu/pues"; }' >> /home/ubuntu/.bashrc

CMD ["/bin/bash"]
