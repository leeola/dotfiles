#
# # NeoVim
#

set -e

# Install the neovim python bundle, needed for multiple things but
# mainly YouCompleteMe
echo "[configure/nvim.sh] ================== Installing Python extensions.."
# First we have to install python devel & friends.
#
# Note that gcc & gcc-c++ are also required, but those are installed
# as system wide dependencies.
yum install -y python-devel automake kernel-devel cmake
pip install neovim

echo "[configure/nvim.sh] ================== Configuring vim"
ln -s /usr/local/bin/nvim /usr/local/bin/vim
mkdir -p ~/.nvim/tmp/bkp ~/.nvim/tmp/swp ~/.nvim/bundle
ln -s ~/.dotfiles/nvim/colors .nvim/colors
ln -s ~/.dotfiles/nvim/nvimrc .nvimrc
ln -s ~/.dotfiles/nvim/snippets .nvim/snippets


echo "[configure/nvim.sh] ================== Installing bundles"
# For some reason i'm installing this manually. Why?
git clone https://github.com/altercation/vim-colors-solarized
mv vim-colors-solarized/colors/solarized.vim ~/.nvim/colors
rm -rf vim-colors-solarized

git clone https://github.com/gmarik/vundle .nvim/bundle/Vundle.vim
echo "Installing Vundle Plugins. This will take a couple minutes.."
nvim +PluginInstall +qall >/dev/null 2>&1


# For reference, see:
# https://github.com/Valloric/YouCompleteMe#ubuntu-linux-x64-installation
echo "[configure/nvim.sh] ================== Installing YouCompleteMe"
pushd /root/.vim/bundle/YouCompleteMe
./install.py --gocode-completer
popd


# Now clean up our files, so that they won't be stored in Docker's diffs.
#yum remove -y python-devel automake kernel-devel cmake
