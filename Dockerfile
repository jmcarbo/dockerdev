FROM ubuntu
RUN apt-get update && apt-get -y install git make gcc
RUN apt-get -y install vim
RUN apt-get -y install curl tmux mutt
RUN apt-get update && apt-get install -y \
                gcc libc6-dev make \
                --no-install-recommends \
        && rm -rf /var/lib/apt/lists/*

RUN apt-get install -qqy \
    ca-certificates 
    
# Install Docker from Docker Inc. repositories.
RUN apt-get update && apt-get install -y apt-transport-https

# Add the repository to your APT sources
RUN echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list

# Then import the repository key
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

# Install docker
RUN apt-get update
RUN apt-get install -y lxc-docker

#
# Alternatively, just use the curl-able install.sh script provided at https://get.docker.com
#
  
ENV GOLANG_VERSION 1.4.1

RUN curl -sSL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz \
                | tar -v -C /usr/src -xz

RUN cd /usr/src/go/src && ./make.bash --no-clean 2>&1

ENV PATH /usr/src/go/bin:$PATH

RUN mkdir /home/swuser
RUN mkdir -p /home/swuser/go/src
ENV GOPATH /home/swuser/go
ENV PATH /home/swuser/go/bin:$PATH

RUN groupadd -r swuser -g 433 && \
        useradd -u 431 -r -g swuser -d /home/swuser -s /sbin/nologin -c "Docker image user" swuser && \
        chown -R swuser:swuser /home/swuser
RUN echo 'swuser:123456' | chpasswd
RUN usermod -a -G docker swuser
RUN addgroup admin
RUN usermod -a -G admin swuser
RUN apt-get install -y wget unzip libssl-dev
RUN wget http://elinks.or.cz/download/elinks-current-0.13.tar.bz2 && tar xjvf elinks-current-0.13.tar.bz2 && cd elinks-0.13* && ./configure && make -j8 && make install
RUN wget http://downloads.rclone.org/rclone-v1.09-linux-amd64.zip && unzip rclone* && cp rclone*/rclone /usr/local/bin
RUN apt-get install -y urlview muttprint muttprint-manual mutt-patched w3m
RUN apt-get install -y  pdftohtml
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y lxde-core lxterminal tightvncserver
EXPOSE 5901
RUN apt-get install -y firefox
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y uzbl

USER swuser
WORKDIR /home/swuser
RUN mkdir -p ~/.vim/autoload ~/.vim/bundle && \
        curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
RUN echo "execute pathogen#infect()\nsyntax on\nfiletype plugin indent on" >~/.vimrc
RUN cd ~/.vim/bundle && git clone https://github.com/fatih/vim-go.git
RUN go get github.com/mwgg/passera/src && mv ~/go/bin/src ~/go/bin/passera
RUN go get github.com/MaximeD/gost
CMD [ "/bin/bash" ]
