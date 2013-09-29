#! ./node_modules/coffee-script/bin/coffee

# 
# # Install Dotfiles
# 
# This is a simple installer which executes a bunch of shell commands in a
# row. There is no error catching or recovery, so it is expected to
# fail entirely if an error is ecountered.
# 
# For further information, see the README.
# 
path = require 'path'
sh = require 'execSync'


# The directory we will move all files to. This script is "desctructive"
# since it's not intended for mass adoption, but nevertheless we
# still prefer to not simply delete any files in the way.
cwd = process.cwd()
trash_dir = path.join '/tmp', 'dotfilestrash', +(new Date())+''
sh.run "mkdir -p #{trash_dir}"


# Install some sudo programs.
# Note that we use sudo here, instead of on the whole command, so that created
# files and directories are owned by user, not root.
sh.run 'sudo apt-get install fish python-pip tmux'
sh.run 'sudo pip install powerline'


# Setup our Bin directory
sh.run "mv ~/.bin #{trash_dir}/.bin"
sh.run 'mkdir ~/.bin'


# Setup Tmux
sh.run "mv ~/.tmux.conf #{trash_dir}/.tmux.conf"
sh.run "ln -s #{cwd}/config/tmux/tmux.conf ~/.tmux.conf"


# Setup Fish
sh.run "mv ~/.config/fish/config.fish #{trash_dir}/config.fish"
sh.run "mv ~/.config/fish/ascii_greeting  #{trash_dir}/ascii_greeting"
sh.run "mkdir -p ~/.config/fish"
sh.run "ln -s #{cwd}/config/fish/config.fish ~/.config/fish/config.fish"
sh.run "ln -s #{cwd}/config/fish/ascii_greeting ~/.config/fish/ascii_greeting"


# Setup "N"
sh.run "mv ~/.n #{trash_dir}/.n"
sh.run 'mkdir -p ~/.n/bin' # Bin ensures Fish can Path It
sh.run 'rm -rf /tmp/n'
sh.run 'git clone https://github.com/visionmedia/n.git /tmp/n'
sh.run 'cp /tmp/n/bin/n ~/.n/_n'
sh.run 'ln -s ~/.n/_n ~/.bin/n'


# Setup Bash (to execute fish)
# 
# Note that we use this method, as it is currently the best method for Koding
sh.run "mv ~/.bashrc #{trash_dir}/.bashrc"
sh.run "mv ~/.bash_profile #{trash_dir}/.bash_profile"
sh.run "ln -s #{cwd}/config/bash/bashrc ~/.bashrc"
sh.run "ln -s #{cwd}/config/bash/bash_profile ~/.bash_profile"




# Setup Vim.
sh.run "mv ~/.vim #{trash_dir}/.vim"
sh.run "mv ~/.vimrc #{trash_dir}/.vimrc"
sh.run "mkdir -p ~/.vim/bundle"
sh.run "mkdir -p ~/.vim/tmp/bkp"
sh.run "mkdir -p ~/.vim/tmp/swp"
sh.run "ln -s #{cwd}/config/vim/colors ~/.vim/colors"
sh.run "ln -s #{cwd}/config/vim/vimrc ~/.vimrc"
sh.run "git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle"
sh.run "vim +BundleInstall +qall"


# Vim Plugins
# 
# Download our vim plugin manager, and then initiate it to do the
# rest of the magic.


