#
# # Make Dotfiles
#
# **Warning**: This is a work in progress, attempting to replace the
# install.coffee file, which depends on god damn Nodejs.

# ## Link
#
# Wire up the various dotfiles.
link:
	# Bash
	rm -f ~/.bashrc
	rm -f ~/.bash_profile
	ln -s $(CURDIR)/config/bash/bashrc 				~/.bashrc
	ln -s $(CURDIR)/config/bash/bash_profile 	~/.bash_profile
	# Fish
	rm -f ~/.config/fish/config.fish
	rm -f ~/.config/fish/ascii_greeting
	mkdir -p ~/.config/fish
	ln -s $(CURDIR)/config/fish/config.fish 		~/.config/fish/config.fish
	ln -s $(CURDIR)/config/fish/ascii_greeting 	~/.config/fish/ascii_greeting
	# Tmux
	rm -f ~/.tmux.conf
	ln -s $(CURDIR)/config/tmux/tmux.conf 			~/.tmux.conf
	# Vim
	rm -rf ~/.vim
	rm -f ~/.vimrc
	mkdir -p ~/.vim/bundle
	mkdir -p ~/.vim/tmp/bkp
	mkdir -p ~/.vim/tmp/swp
	ln -s $(CURDIR)/config/vim/colors 					~/.vim/colors
	ln -s $(CURDIR)/config/vim/vimrc 						~/.vimrc
	git clone https://github.com/gmarik/vundle 	~/.vim/bundle/vundle
	# Git
	rm -f ~/.gitconfig
	ln -s $(CURDIR)/config/git/gitconfig 				~/.gitconfig
	# SSH
	rm -f ~/.ssh/config
	mkdir -p ~/.ssh
	ln -s $(CURDIR)/config/ssh/config 					~/.ssh/config
