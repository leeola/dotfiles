#
# # Make Dotfiles
#
# Basically just shortcuts for Docker.
#

build:
	docker build -t docker-dev .

run:
	docker run --name="docker-dev" --detach --tty --interactive --volume=/docker-shared:/docker-shared docker-dev

attach:
	docker attach docker-dev

start:
	docker start docker-dev

interact:
	docker run --tty --interactive --rm --volume=/docker-shared:/docker-shared docker-dev tmux
