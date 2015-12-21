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
ENV GOPATH /docker-shared/go
ENV GOBIN /docker-shared/go/bin
ENV GOROOT /usr/local/go
ENV PATH $PATH:$GOBIN:/usr/local/go/bin
ENV GO15VENDOREXPERIMENT 1
ENV TERM screen-256color
ENV DOCKER_LOG file
ENV TZ "America/Los_Angeles"

# ## Set locale
#
# This is in place mainly for Powerline fonts to work
# correctly.
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8


# ## Installation
#
# Note that by running each step independantly we are not being storage
# efficient, since each step uses storage and cannot be cleaned after it
# is run.
#
# However, doing it this way is more developer friendly. Each step is
# cached, meaning modifications don't require previous steps to be run
# again.
ADD core/install/dependencies.sh /root/.dotfiles/core/install/dependencies.sh
RUN bash /root/.dotfiles/core/install/dependencies.sh

ADD core/install/docker.sh /root/.dotfiles/core/install/docker.sh
RUN bash /root/.dotfiles/core/install/docker.sh

ADD core/install/keychain.sh /root/.dotfiles/core/install/keychain.sh
RUN bash /root/.dotfiles/core/install/keychain.sh

ADD core/install/mosh.sh /root/.dotfiles/core/install/mosh.sh
RUN bash /root/.dotfiles/core/install/mosh.sh

ADD core/install/ag.sh /root/.dotfiles/core/install/ag.sh
RUN bash /root/.dotfiles/core/install/ag.sh

ADD core/install/pip.sh /root/.dotfiles/core/install/pip.sh
RUN bash /root/.dotfiles/core/install/pip.sh

ADD core/install/tmux.sh /root/.dotfiles/core/install/tmux.sh
RUN bash /root/.dotfiles/core/install/tmux.sh

ADD core/install/fish.sh /root/.dotfiles/core/install/fish.sh
RUN bash /root/.dotfiles/core/install/fish.sh

ADD core/install/golang.sh /root/.dotfiles/core/install/golang.sh
RUN bash /root/.dotfiles/core/install/golang.sh

ADD core/install/golang-tools.sh /root/.dotfiles/core/install/golang-tools.sh
RUN bash /root/.dotfiles/core/install/golang-tools.sh

ADD core/install/node.sh /root/.dotfiles/core/install/node.sh
RUN bash /root/.dotfiles/core/install/node.sh

ADD core/install/libsass.sh /root/.dotfiles/core/install/libsass.sh
RUN bash /root/.dotfiles/core/install/libsass.sh

ADD core/install/nvim.sh /root/.dotfiles/core/install/nvim.sh
RUN bash /root/.dotfiles/core/install/nvim.sh

ADD core/install/camlistore.sh /root/.dotfiles/core/install/camlistore.sh
RUN bash /root/.dotfiles/core/install/camlistore.sh

ADD core/install/clean.sh /root/.dotfiles/core/install/clean.sh
RUN bash /root/.dotfiles/core/install/clean.sh


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


# ## Add and Link nvim, Install Plugins
#
# We're adding nvim here rather than with the other configs due to the
# plugin installations.
ADD nvim /root/.dotfiles/nvim
ADD core/configure/nvim.sh /root/.dotfiles/core/configure/nvim.sh
RUN bash /root/.dotfiles/core/configure/nvim.sh


ADD utils/link-home.fish /root/.dotfiles/utils/link-home.fish
ADD utils/dotfiles.fish   /usr/local/bin/dotfiles
ADD utils/startup.sh      /root/.dotfiles/utils/startup.sh


# Expose ports that we want to work with
EXPOSE 22 \
  3000 3003 3030 3033 3333 \
  5000 5005 5050 5055 5555 \
  8000 8008 8080 8088 8888 \
  88 8443


# ## Run process
#CMD ["/root/.dotfiles/utils/startup.sh"]
CMD ["sleep", "infinity"]
