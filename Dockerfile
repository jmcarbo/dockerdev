FROM ubuntu
RUN apt-get update && apt-get -y install git make gcc
RUN apt-get -y install vim
RUN apt-get -y install curl
RUN apt-get update && apt-get install -y \
                gcc libc6-dev make \
                --no-install-recommends \
        && rm -rf /var/lib/apt/lists/*

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
USER swuser
WORKDIR /home/swuser
RUN mkdir -p ~/.vim/autoload ~/.vim/bundle && \
        curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
RUN echo "execute pathogen#infect()\nsyntax on\nfiletype plugin indent on" >~/.vimrc
RUN cd ~/.vim/bundle && git clone https://github.com/fatih/vim-go.git
RUN go get github.com/mwgg/passera/src && mv ~/go/bin/src ~/go/bin/passera
