#!/usr/bin/env ./node_modules/coffee-script/bin/coffee

# 
# # Link Dotfiles
# 
# This is a simple installer which executes a bunch of shell commands in a
# row. There is no error catching or recovery, so it is expected to
# fail entirely if an error is ecountered.
# 
# For further information, see the README.
# 
os    = require 'os'
path  = require 'path'
sh    = require 'execSync'


if os.platform() is 'darwin'
  system  = 'mac'
else if os.platform() is 'linux' and os.hostname()[-5...] is 'kd.io'
  system  = 'koding'
else
  console.log 'Unrecognized system'
  process.exit 1



# The directory we will move all files to. This script is "desctructive"
# since it's not intended for mass adoption, but nevertheless we
# still prefer to not simply delete any files in the way.
cwd = process.cwd()
trash_dir = path.join '~', '.tmp', 'dotfilestrash', +(new Date())+''
sh.run "mkdir -p #{trash_dir}"


# Lees Hacks
#
# Create a directory to store random hacks, usually related to system
# abstraction.
sh.run "mv ~/.lees_hacks #{trash_dir}/.lees_hacks"
sh.run 'mkdir -p ~/.lees_hacks'


# Location Bridges
#
# The bridges are system specific links to allow for config files to
# link to a specific location and be pointed to the proper destination.
sh.run 'mkdir ~/.lees_hacks/bridges'
# using a do for a simple scope closure
do ->
  switch system
    when 'koding'
      powerlineLoc = 'dist'
    when 'mac'
      powerlineLoc = 'site'

  sh.run "ln -s /usr/local/lib/python2.7/#{powerlineLoc}-packages/powerline "+
    '~/.lees_hacks/bridges/powerline'



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
sh.run "ln -s #{cwd}/config/fish/functions ~/.config/fish/functions"


# Setup "N"
sh.run "mv ~/.n #{trash_dir}/.n"
sh.run 'mkdir -p ~/.n/bin' # Bin ensures Fish can Path It
sh.run 'rm -rf ~/.tmp/n'
sh.run 'git clone https://github.com/visionmedia/n.git ~/.tmp/n'
sh.run 'cp ~/.tmp/n/bin/n ~/.n/_n'
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
sh.run "git clone https://github.com/gmarik/vundle ~/.vim/bundle/Vundle.vim"
sh.run "vim +PluginInstall +qall"


# Setup Git
sh.run "mv ~/.gitconfig #{trash_dir}/.gitconfig"
sh.run "ln -s #{cwd}/config/git/gitconfig ~/.gitconfig"


# Setup SSH
sh.run "mv ~/.ssh/config #{trash_dir}/.sshconfig"
sh.run 'mkdir ~/.ssh'
sh.run "ln -s #{cwd}/config/ssh/config ~/.ssh/config"
