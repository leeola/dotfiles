#
# # Make Dotfiles
#
# Basically just shortcuts for Docker.
#

build:
	docker build -t docker-dev .

run:
	docker run --tty --interactive --volume=/docker-shared:/docker-shared \
		--publish=3000:3000 \
		--publish=3003:3003 \
		--publish=5000:5000 \
		--publish=8000:8000 \
		--publish=8080:8080 \
		--publish=8888:8888 \
		--name="docker-dev" --detach \
		docker-dev

attach:
	docker attach docker-dev

start:
	docker start docker-dev


interact:
	docker run --tty --interactive --volume=/docker-shared:/docker-shared \
		--publish=3000:3000 \
		--publish=3003:3003 \
		--publish=5000:5000 \
		--publish=8000:8000 \
		--publish=8080:8080 \
		--publish=8888:8888 \
		--rm \
		docker-dev tmux
