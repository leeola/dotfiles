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
ENV TZ "America/Los_Angeles"

# ## Set locale
#
# This is in place mainly for Powerline fonts to work
# correctly.
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8


# ## Core Installation
#
# Add the core installation, and run it
ADD core /root/.dotfiles/core
RUN   cd /root/.dotfiles/core \
  &&  bash /root/.dotfiles/core/install/core.sh

## ## Setup the shared folders and links
##
## We're creating the folders with `-p` so that if they don't
## exist, our link still works.
##
## In the future we should probably throw a warning to the user
## if the docker-shared dir doesn't exist.
#RUN mkdir -p /docker-shared/projects \
#    /docker-shared/.ssh \
#    ~/.config/fish \
#  && ln -s /docker-shared/._/fish/fish_history ~/.config/fish/fish_history \
#  && ln -s /docker-shared/projects ~/projects \
#  && ln -s /docker-shared/.ssh     ~/.ssh \



#ADD . /root/.dotfiles


# ## Add and Link nvim, Install Plugins
#
# We're adding nvim here rather than with the other configs due to the
# plugin installations.
ADD nvim /root/.dotfiles/nvim
RUN echo "===================Configuring Nvim=======================" \
  && ln -s /usr/local/bin/nvim /usr/local/bin/vim \
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
  60001 60002 60003 \
  88 8443

# ## Run process
#CMD ["/usr/local/bin/tmux"]
#CMD ["/usr/sbin/sshd", "-D"]
CMD ["/root/.dotfiles/utils/startup.sh"]
