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


# ## Configure env vars
#
# IMPORTANT: If any env vars are added, they must be added in
# ./utils/startup.fish as well, so that they are properly exposed to
# SSH'd users.
ENV HOME /root
ENV GOPATH /go
ENV GOBIN /go/bin
ENV GOROOT /usr/local/go
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
    ~/.config/fish \
  && ln -s /docker-shared/._/fish/fish_history ~/.config/fish/fish_history \
  && ln -s /docker-shared/projects ~/projects \
  && ln -s /docker-shared/.ssh     ~/.ssh \




# ## Install simple user dependencies
#
# Some user deps that we aren't yet compiling by hand.
  && yum update -y \
  && yum install -y \
    make tar \
    openssl \
    openssh-server \
    git \
    mercurial \
    curl \
    gcc gcc-c++ \
# required by fish
    man hostname bc \
    zip unzip \


# ## Install build dependencies
#
# Ie, dependencies we need for the build, but can remove
# after it's all done.
  && yum install -y \
    automake pcre-devel xz-devel ncurses-devel \
    zlib-devel openssl-devel autoconf libtool \
    cmake \


# Install Docker
#
# Used to run Docker in Docker.
# We used to use  docker in docker, but currently that's disabled.
#ADD ./utils/wrapdocker /usr/local/bin/wrapdocker
  && yum install -y libvirt libvirt-client python-virtinst \
  && curl -o /usr/local/bin/docker https://get.docker.io/builds/Linux/x86_64/docker-latest \
  && chmod +x /usr/local/bin/docker \


# ## Keychain
#
# TODO: REMOVE RPM DEPENDENCY
  && rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el5.rf.x86_64.rpm \
  && yum install -y keychain \


# ## Install mosh
#
# TODO: REMOVE RPM DEPENDENCY
# NOTE: We're using an rpm & yum install because the source installation
# was proving very difficult.
#
# In short, protobuf would be installed but mosh's configure could never
# find protobuf. Very time consuming. The source installation code is
# below for future work.
  && rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm \
  && yum install -y mosh \
#RUN cd /tmp \
#  curl -O https://protobuf.googlecode.com/svn/rc/protobuf-2.5.0.tar.gz \
#  tar xvf protobuf-2.5.0.tar.gz
##  cd protobuf-2.6.0
##  ./configure \
##  make && make install
#RUN git clone https://github.com/keithw/mosh /tmp/mosh \
#  cd /tmp/mosh
##  ./autogen.sh \
##  ./configure \
##  make \
##  make install


# ## Install silversearcher
#
# General purpose
  && git clone https://github.com/ggreer/the_silver_searcher /tmp/ag \
  && cd /tmp/ag \
  && git checkout 0.20.0 \
  && ./build.sh \
  && make install \


# ## Install pip
#
# Used in: Powerline
  && cd /tmp \
  && curl -O https://pypi.python.org/packages/source/s/setuptools/setuptools-1.4.2.tar.gz \
  && tar -xvf setuptools-1.4.2.tar.gz \
  && cd setuptools-1.4.2 \
  && python2.7 setup.py install \
  && curl https://raw.githubusercontent.com/pypa/pip/master/contrib/get-pip.py | python2.7 - \


# ## Install Golang
 && cd /tmp \
 && curl -O https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz \
 && tar -xzf go1.4.2.linux-amd64.tar.gz \
 && mv go /usr/local/go \


# ## Install tmux
#
# First install libevent, a dep of tmux, then tmux.
  && cd /tmp \
  && curl -LO https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz \
  && tar -xvf libevent-2.0.21-stable.tar.gz \
  && ls -la \
  && cd libevent-2.0.21-stable \
  && ./configure --prefix=/usr --disable-static \
  && make install \
  && cd .. \
  && git clone git://git.code.sf.net/p/tmux/tmux-code tmux \
  && cd tmux \
  && git checkout 1.9a \
  && sh autogen.sh \
  && ./configure \
  && make && make install \
# Suddenly this is causing a failure. Not sure why.. but if it's not
# needed, who cares?
# POSSIBLY DEPRECATED
#  ln -s /usr/lib/libevent-2.0.so.5 /usr/lib64/libevent-2.0.so.5 \


# ## Install Fish
  && cd /tmp \
  && git clone https://github.com/fish-shell/fish-shell \
  && cd fish-shell \
  && git checkout 2.1.1 \
  && autoconf \
  && ./configure \
  && make \
  && make install \


# ## Install N, and Node
  && curl https://raw.githubusercontent.com/visionmedia/n/master/bin/n \
    -o /usr/bin/n \
  && chmod +x /usr/bin/n \
  && n stable \
  && npm install -g \
    gulp \
    coffee-script \


# ## Install Go Tools
# (Note, not currently installing Go here, yet)
# ### gpm
  && cd /tmp \
  && git clone https://github.com/pote/gpm.git && cd gpm \
  && git checkout v1.2.3 \
  && ./configure \
  && make install \
# ### gpm-all
  && cd /tmp \
  && git clone https://github.com/pote/gpm-all.git \
  && cd gpm-all \
  && ./configure \
  && make install \
# ### gpm-link
  && git clone https://github.com/elcuervo/gpm-link.git /tmp/gpm-link \
  && cd /tmp/gpm-link \
  && make install \
# ### gvp
  && cd /tmp \
  && git clone https://github.com/pote/gvp.git && cd gvp \
  && git checkout v0.1.0 \
  && ./configure \
  && make install \
  && cd /tmp \
# ### gvp-fish
  && git clone https://github.com/leeolayvar/gvp-fish && cd gvp-fish \
  && cp bin/gvp-fish /usr/local/bin \
# ### goimports
  && go get github.com/bradfitz/goimports \
# ### gocode
  && go get github.com/nsf/gocode \
# ### godef
  && go get code.google.com/p/rog-go/exp/cmd/godef \
# ### go oracle
  && go get golang.org/x/tools/oracle \
# ### gorename
#  && go get code.google.com/p/go.tools/cmd/gorename \


# ## Libsass Library
  && git clone https://github.com/sass/libsass /tmp/libsass \
  && cd /tmp/libsass \
  && make shared \
  && make install-shared \
# On centos, it seems we are missing /usr/local/lib from ldconfig,
# so add it and run ldconfig to make libsass work.
  && echo "/usr/local/lib" > /etc/ld.so.conf.d/libsass.conf \
  && ldconfig \


# ## AWS CLI
  && pip install awscli \
  && ln -s /docker-shared/.aws ~/.aws \


# ## NeoVim
# Checking out the commit i've used for ages:
# 61c98e7e35b18081a8f723406d5ed5f241ddbc96
  && git clone https://github.com/neovim/neovim /tmp/neovim \
  && cd /tmp/neovim \
  && git checkout 61c98e7e35b18081a8f723406d5ed5f241ddbc96 \
  && make install \


# ## Clean up excess build files and deps
  && rm -rf /tmp && mkdir /tmp \
  && yum remove -y \
    automake pcre-devel xz-devel ncurses-devel \
    zlib-devel openssl-devel autoconf libtool \
    cmake \
  && yum clean all


# ## Add and Link nvim, Install Plugins
#
# We're adding nvim here rather than with the other configs due to the
# plugin installations.
ADD nvim /root/.dotfiles/nvim
RUN ln -s /usr/local/bin/nvim /usr/local/bin/vim \
  && mkdir -p ~/.nvim/tmp/bkp ~/.nvim/tmp/swp ~/.nvim/bundle \
  && ln -s ~/.dotfiles/nvim/colors .nvim/colors \
  && ln -s ~/.dotfiles/nvim/nvimrc .nvimrc \
  && ln -s ~/.dotfiles/nvim/snippets .nvim/snippets \

  && git clone https://github.com/altercation/vim-colors-solarized \
  && mv vim-colors-solarized/colors/solarized.vim ~/.nvim/colors \
  && rm -rf vim-colors-solarized \

  && git clone https://github.com/gmarik/vundle .nvim/bundle/Vundle.vim \
  && echo "Installing NeoVim Plugins. This will take a couple minutes.." \
  && nvim +PluginInstall +qall >/dev/null 2>&1


# Temporary location
ADD ssh/sshd_config /etc/ssh/sshd_config
RUN /usr/bin/ssh-keygen -A


# ## Add configs
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
# ### ag
ADD ag /root/.dotfiles/ag
# ### git
ADD git /root/.dotfiles/git
# ### tmux
ADD tmux /root/.dotfiles/tmux
# ## Link configs
# ### fish
RUN mkdir -p .config/fish \
  && ln -s ~/.dotfiles/fish/config.fish .config/fish/config.fish \
  && ln -s ~/.dotfiles/fish/greetings .config/fish/greetings \
  && ln -s ~/.dotfiles/fish/functions .config/fish/functions \
# ### ag
  && ln -s ~/.dotfiles/ag/agignore ~/.agignore \
# ### git
  && ln -s ~/.dotfiles/git/gitconfig ~/.gitconfig \
  && ln -s ~/.dotfiles/git/gitignore_global ~/.gitignore_global \
# ### tmux
  && ln -s .dotfiles/tmux/tmux.conf .tmux.conf


ADD utils/startup.sh  /root/.dotfiles/utils/startup.sh
ADD utils/dotfiles.fish /usr/local/bin/dotfiles


# Expose ports that we want to work with
EXPOSE 22 \
  3000 3003 3030 3033 3333 \
  5000 5005 5050 5055 5555 \
  8000 8008 8080 8088 8888 \
  60001 60002 60003

# ## Run process
#CMD ["/usr/local/bin/tmux"]
#CMD ["/usr/sbin/sshd", "-D"]
CMD ["/root/.dotfiles/utils/startup.sh"]
