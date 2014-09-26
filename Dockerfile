# DOCKER-VERSION 1.2.0
#
# # leeola Development
#
# !EXPERIMENTAL!
#
# A humble dockerfile which install and configure my entire development
# environment.
#
FROM centos
WORKDIR /root


# ## Configure users
ENV HOME /root
ENV GOPATH /go
ENV GOBIN /go/bin
ENV PATH $PATH:$GOBIN
ENV TERM screen-256color


# ## Setup the shared folders and links
#
# We're creating the folders with `-p` so that if they don't
# exist, our link still works.
#
# In the future we should probably throw a warning to the user
# if the docker-shared dir doesn't exist.
RUN mkdir -p /docker-shared/projects \
    /docker-shared/.ssh \
    ~/.config/fish &&\
  ln -s /docker-shared/._/fish/fish_history ~/.config/fish/fish_history &&\
  ln -s /docker-shared/projects ~/projects &&\
  ln -s /docker-shared/.ssh     ~/.ssh


## ## Fix locale nightmare
##
## This is close, and "might" be fixed.. we'll see. Both Tmux and Vim
## show the proper characters with this env setting and the language
## install.
#RUN apt-get update &&\
#  apt-get install -y language-pack-en-base &&\
#  update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
## By using env manually, tmux picks up on the locale settings
## (as the sole process)
##RUN echo 'LANG="en_US.UTF-8"' >> /etc/environment &&\
##  echo 'LC_ALL="en_US.UTF-8"' >> /etc/environment
#ENV LANG en_US.UTF-8
#ENV LC_ALL en_US.UTF-8


# ## Install simple user dependencies
#
# Some user deps that we aren't yet compiling by hand.
RUN yum install -y\
  make \
  tar \
  hostname \
  vim \
  git \
  mercurial \
  curl \
  ruby rake
#  mosh \


# ## Install build dependencies
#
# Ie, dependencies we need for the build, but can remove
# after it's all done.
RUN yum install -y gcc gcc-c++ automake pcre-devel xz-devel ncurses-devel


# ## Install silversearcher
#
# General purpose
RUN git clone https://github.com/ggreer/the_silver_searcher /tmp/ag &&\
  cd /tmp/ag &&\
  ./build.sh &&\
  make install


# ## Install pip
#
# Used in: Powerline
RUN cd /tmp &&\
  curl -O https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz &&\
  tar -xvf setuptools-1.4.2.tar.gz &&\
  cd setuptools-1.4.2 &&\
  python2.7 setup.py install &&\
  curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | python2.7 -


# ## Install Golang
RUN cd /tmp &&\
  curl -O https://storage.googleapis.com/golang/go1.3.2.linux-amd64.tar.gz &&\
  tar -xzf go1.3.2.linux-amd64.tar.gz &&\
  mv go/bin/go    /usr/local/bin/go &&\
  mv go/bin/gofmt /usr/local/bin/gofmt


# ## Install tmux
#
# First install libevent, a dep of tmux, then tmux.
RUN cd /tmp &&\
  curl -LO https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz &&\
  tar -xvf libevent-2.0.21-stable.tar.gz &&\
  ls -la &&\
  cd libevent-2.0.21-stable &&\
  ./configure --prefix=/usr --disable-static &&\
  make install &&\
  ln -s /usr/lib/libevent-2.0.so.5 /usr/lib64/libevent-2.0.so.5 &&\
  cd .. &&\
  git clone git://git.code.sf.net/p/tmux/tmux-code tmux &&\
  cd tmux &&\
  sh autogen.sh &&\
  ./configure &&\
  make && make install


# ## Install Fish
RUN cd /tmp &&\
  git clone https://github.com/fish-shell/fish-shell &&\
  cd fish-shell &&\
  git checkout 2.1.1 &&\
  autoconf &&\
  ./configure &&\
  make &&\
  make install


# ## Install N, and Node
RUN curl https://raw.githubusercontent.com/visionmedia/n/master/bin/n \
  -o /usr/bin/n && \
  chmod +x /usr/bin/n && \
  n stable &&\
  npm install -g \
    gulp \
    coffee-script


# ## Install Go Tools
# (Note, not currently installing Go here, yet)
RUN git clone https://github.com/pote/gpm.git && cd gpm &&\
    git checkout v1.2.3 &&\
    ./configure &&\
    make install &&\
    cd .. && rm -rf gpm &&\
  git clone https://github.com/pote/gvp.git && cd gvp &&\
    git checkout v0.1.0 &&\
    ./configure &&\
    make install &&\
    cd .. && rm -rf gpm &&\
  git clone https://github.com/leeolayvar/gvp-fish && cd gvp-fish &&\
    cp bin/gvp-fish /usr/local/bin &&\
    cd .. && rm -rf gvp-fish


## ## Github's Hub
#RUN git clone https://github.com/github/hub.git &&\
#  cd hub &&\
#  rake install prefix=/usr/local
#
#
## ## Powerline
#RUN pip install git+git://github.com/Lokaltog/powerline
#
#
## ## Add and link configs
## ### vim
#ADD config/vim /root/.dotfiles/config/vim
#RUN mkdir -p ~/.vim/tmp/bkp ~/.vim/tmp/swp ~/.vim/bundle &&\
#  ln -s ~/.dotfiles/config/vim/colors .vim/colors &&\
#  ln -s ~/.dotfiles/config/vim/vimrc .vimrc &&\
#  ln -s ~/.dotfiles/config/vim/snippets .vim/snippets &&\
#
#  git clone https://github.com/altercation/vim-colors-solarized &&\
#  mv vim-colors-solarized/colors/solarized.vim ~/.vim/colors &&\
#  rm -rf vim-colors-solarized &&\
#
#  git clone https://github.com/gmarik/vundle .vim/bundle/Vundle.vim &&\
#  echo "Installing Vim Plugins. This will take a couple minutes.." &&\
#  vim +PluginInstall +qall >/dev/null 2>&1
#
## ### ssh
##
## Access to /docker-shared/.ssh is not possible (i believe) during
## the Dockerfile build, due to the lack of a real shared volume.
## At best, it will write the file(s) and then overwrite them once
## the volume is shared.
##
## So, if something needs to be placed into ~/.ssh, it needs to be
## done manually by the user, or post run.
##ADD config/ssh/config /root/.ssh/config
#
## ### fish
#ADD config/fish /root/.dotfiles/config/fish
#RUN mkdir -p .config/fish &&\
#  ln -s ~/.dotfiles/config/fish/config.fish .config/fish/config.fish &&\
#  ln -s ~/.dotfiles/config/fish/ascii_greeting .config/fish/ascii_greeting &&\
#  ln -s ~/.dotfiles/config/fish/functions .config/fish/functions
#
## ### git
#ADD config/git /root/.dotfiles/config/git
#RUN ln -s ~/.dotfiles/config/git/gitconfig ~/.gitconfig
#
## ### tmux
#ADD config/tmux /root/.dotfiles/config/tmux
#RUN ln -s .dotfiles/config/tmux/tmux.conf .tmux.conf
#
## ### powerline
#ADD powerline /root/.dotfiles/powerline
#RUN ln -s ~/.dotfiles/powerline ~/.config/powerline
#
#
## ## Run process
#CMD ["/usr/bin/tmux"]
