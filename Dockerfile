# DOCKER-VERSION 1.2.0
#
# # leeo.la/dotfiles
#
# !EXPERIMENTAL!
#
# A humble dockerfile which install and configure my entire development
# environment.
#
FROM centos:centos7
MAINTAINER Lee Olayvar <leeolayvar@gmail.com>

# ## Set the CWD
WORKDIR /root


# ## Configure users
ENV HOME /root
ENV GOPATH /go
ENV GOBIN /go/bin
ENV PATH $PATH:$GOBIN:/usr/local/go/bin
ENV TERM screen-256color
ENV DOCKER_LOG file

# ## Set locale
#
# This is in place mainly for Powerline fonts to work
# correctly.
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8


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




# ## Install simple user dependencies
#
# Some user deps that we aren't yet compiling by hand.
RUN yum update -y && yum clean all
RUN yum install -y\
  make tar \
# required by fish
  man hostname bc \
  openssl \
  vim \
  git \
  mercurial \
  curl \
  ruby rake \
  gcc gcc-c++


# ## Install build dependencies
#
# Ie, dependencies we need for the build, but can remove
# after it's all done.
RUN yum install -y \
  automake pcre-devel xz-devel ncurses-devel \
  zlib-devel openssl-devel


# Install Docker
#
# Used to run Docker in Docker.
ADD ./utils/wrapdocker /usr/local/bin/wrapdocker
RUN yum install -y libvirt libvirt-client python-virtinst &&\
  curl -o /usr/local/bin/docker https://get.docker.io/builds/Linux/x86_64/docker-latest &&\
  chmod +x /usr/local/bin/docker &&\
  chmod +x /usr/local/bin/wrapdocker


# ## Keychain
#
# TODO: REMOVE RPM DEPENDENCY
RUN rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el5.rf.x86_64.rpm &&\
  yum install -y keychain


# ## Install mosh
#
# TODO: REMOVE RPM DEPENDENCY
# NOTE: We're using an rpm & yum install because the source installation
# was proving very difficult.
#
# In short, protobuf would be installed but mosh's configure could never
# find protobuf. Very time consuming. The source installation code is
# below for future work.
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm &&\
  yum install -y mosh
#RUN cd /tmp &&\
#  curl -O https://protobuf.googlecode.com/svn/rc/protobuf-2.5.0.tar.gz &&\
#  tar xvf protobuf-2.5.0.tar.gz
##  cd protobuf-2.6.0
##  ./configure &&\
##  make && make install
#RUN git clone https://github.com/keithw/mosh /tmp/mosh &&\
#  cd /tmp/mosh
##  ./autogen.sh &&\
##  ./configure &&\
##  make &&\
##  make install


# ## Install silversearcher
#
# General purpose
RUN git clone https://github.com/ggreer/the_silver_searcher /tmp/ag &&\
  cd /tmp/ag &&\
  git checkout 0.20.0 &&\
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
  mv go /usr/local/go


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
  cd .. &&\
  git clone git://git.code.sf.net/p/tmux/tmux-code tmux &&\
  cd tmux &&\
  sh autogen.sh &&\
  ./configure &&\
  make && make install
# Suddenly this is causing a failure. Not sure why.. but if it's not
# needed, who cares?
# POSSIBLY DEPRECATED
#  ln -s /usr/lib/libevent-2.0.so.5 /usr/lib64/libevent-2.0.so.5 &&\


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
RUN cd /tmp &&\
  git clone https://github.com/pote/gpm.git && cd gpm &&\
    git checkout v1.2.3 &&\
    ./configure &&\
    make install &&\
    cd /tmp &&\
  git clone https://github.com/pote/gvp.git && cd gvp &&\
    git checkout v0.1.0 &&\
    ./configure &&\
    make install &&\
    cd /tmp &&\
  git clone https://github.com/leeolayvar/gvp-fish && cd gvp-fish &&\
    cp bin/gvp-fish /usr/local/bin


# ## Github's Hub
RUN git clone https://github.com/github/hub.git /tmp/hub &&\
  cd /tmp/hub &&\
  git checkout v1.12.2 &&\
  rake install prefix=/usr/local


# ## Powerline
RUN pip install git+git://github.com/Lokaltog/powerline


# ## Clean up excess build files and deps
RUN rm -rf /tmp && mkdir /tmp &&\
  yum remove -y \
    automake pcre-devel xz-devel ncurses-devel \
    zlib-devel openssl-devel


# ## Add and link configs
# ### vim
ADD vim /root/.dotfiles/vim
RUN mkdir -p ~/.vim/tmp/bkp ~/.vim/tmp/swp ~/.vim/bundle &&\
  ln -s ~/.dotfiles/vim/colors .vim/colors &&\
  ln -s ~/.dotfiles/vim/vimrc .vimrc &&\
  ln -s ~/.dotfiles/vim/snippets .vim/snippets &&\

  git clone https://github.com/altercation/vim-colors-solarized &&\
  mv vim-colors-solarized/colors/solarized.vim ~/.vim/colors &&\
  rm -rf vim-colors-solarized &&\

  git clone https://github.com/gmarik/vundle .vim/bundle/Vundle.vim &&\
  echo "Installing Vim Plugins. This will take a couple minutes.." &&\
  vim +PluginInstall +qall >/dev/null 2>&1

# ### ssh
#
# Access to /docker-shared/.ssh is not possible (i believe) during
# the Dockerfile build, due to the lack of a real shared volume.
# At best, it will write the file(s) and then overwrite them once
# the volume is shared.
#
# So, if something needs to be placed into ~/.ssh, it needs to be
# done manually by the user, or post run.
#ADD ssh/config /root/.ssh/config

# ### fish
ADD fish /root/.dotfiles/fish
RUN mkdir -p .config/fish &&\
  ln -s ~/.dotfiles/fish/config.fish .config/fish/config.fish &&\
  ln -s ~/.dotfiles/fish/greetings .config/fish/greetings &&\
  ln -s ~/.dotfiles/fish/functions .config/fish/functions

# ### git
ADD git /root/.dotfiles/git
RUN ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig

# ### tmux
ADD tmux /root/.dotfiles/tmux
RUN ln -s .dotfiles/tmux/tmux.conf .tmux.conf

# ### powerline
ADD powerline /root/.dotfiles/powerline
RUN ln -s ~/.dotfiles/powerline ~/.config/powerline


# ## Run process
#CMD ["/usr/local/bin/wrapdocker", "/usr/local/bin/tmux"]
CMD ["/usr/local/bin/tmux"]
