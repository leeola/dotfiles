# DOCKER-VERSION 1.2.0
#
# # leeola Development
#
# !EXPERIMENTAL!
#
# A humble dockerfile which install and configure my entire development
# environment.
#
FROM ubuntu:14.04
WORKDIR /root


# ## Configure users
ENV HOME /root
ENV GOPATH /go
ENV GOBIN /go/bin
ENV PATH $PATH:$GOBIN
ENV TERM screen-256color


# ## Setup the shared folders and links
RUN mkdir -p /docker-shared/projects ~/.ssh &&\
  ln -s /docker-shared/projects ~/projects
  ln -s /docker-shared/.ssh     ~/.ssh


# ## Install simple dependencies
RUN apt-get update &&\
  apt-get install -y\
    vim \
    tmux \
    git \
    mercurial \
    curl \
    golang \
    ruby rake \
    silversearcher-ag \
    python-pip


# ## Install Fish
RUN curl http://fishshell.com/files/2.1.0/linux/Ubuntu/fish_2.1.0-1~precise_amd64.deb > fish.deb &&\
  apt-get install -y bc libjs-jquery gettext-base man-db &&\
  dpkg -i fish.deb &&\
  rm fish.deb


# ## Install N, and Node
RUN curl https://raw.githubusercontent.com/visionmedia/n/master/bin/n \
  -o /usr/bin/n && \
  chmod +x /usr/bin/n && \
  n stable


# ## Github's Hub
RUN git clone https://github.com/github/hub.git &&\
  cd hub &&\
  rake install prefix=/usr/local


# ## Powerline
RUN pip install git+git://github.com/Lokaltog/powerline


# ## Add and link configs
# ### vim
ADD config/vim /root/.dotfiles/config/vim
RUN mkdir -p ~/.vim/tmp/bkp ~/.vim/tmp/swp ~/.vim/bundle &&\
  ln -s ~/.dotfiles/config/vim/colors .vim/colors &&\
  ln -s ~/.dotfiles/config/vim/vimrc .vimrc &&\
  ln -s ~/.dotfiles/config/vim/snippets .vim/snippets &&\

  git clone https://github.com/altercation/vim-colors-solarized &&\
  mv vim-colors-solarized/colors/solarized.vim ~/.vim/colors &&\
  rm -rf vim-colors-solarized &&\

  git clone https://github.com/gmarik/vundle .vim/bundle/Vundle.vim &&\
  echo "Installing Vim Plugins. This will take a couple minutes.." &&\
  vim +PluginInstall +qall >/dev/null 2>&1

# ### ssh
ADD config/ssh /root/.dotfiles/config/ssh
RUN ln -s ~/.dotfiles/config/ssh/config ~/.ssh/config

# ### fish
ADD config/fish /root/.dotfiles/config/fish
RUN mkdir -p .config/fish &&\
  ln -s ~/.dotfiles/config/fish/config.fish .config/fish/config.fish &&\
  ln -s ~/.dotfiles/config/fish/ascii_greeting .config/fish/ascii_greeting

# ### git
ADD config/git /root/.dotfiles/config/git
RUN ln -s ~/.dotfiles/config/git/gitconfig ~/.gitconfig

# ### tmux
ADD config/tmux /root/.dotfiles/config/tmux
RUN ln -s .dotfiles/config/tmux/tmux.conf .tmux.conf


# ### Run process
CMD ["/usr/bin/tmux"]
