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


# Install some sudo programs. Note that we do this first, that way
# sudo is the first thing, if any, to fail.
#sh.run 'sudo apt-get install fish'


# Setup our Bin directory
sh.run "mv ~/.bin #{trash_dir}/.bin"
sh.run 'mkdir ~/.bin'


# Setup Fish
sh.run "mv ~/.config/fish/config.fish #{trash_dir}/config.fish"
sh.run "ln -s #{cwd}/configs/fish/config.fish ~/.config/fish/config.fish"


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
sh.run "mv ~/.bash_profile #{trash_dir}/.bash_profile"
sh.run "ln -s #{cwd}/configs/bash/.bash_profile ~/.bash_profile"




# Setup Vim.
sh.run "mv ~/.vim #{trash_dir}/.vim"
sh.run "mv ~/.vimrc #{trash_dir}/.vimrc"
sh.run "ln -s #{cwd}/configs/vim ~/.vim"
sh.run "ln -s #{cwd}/configs/vim/vimrc ~/.vimrc"


# Vim Plugins
# 
# Download our vim plugin manager, and then initiate it to do the
# rest of the magic.


