#
# ## Install Go Tools
#

set -e
echo "[golang-tools.sh] ================== Installing"

# ### gpm
cd /tmp
git clone https://github.com/pote/gpm.git && cd gpm
git checkout v1.2.3
./configure
make install

# ### gpm-all
cd /tmp
git clone https://github.com/pote/gpm-all.git
cd gpm-all
./configure
make install

# ### gpm-link
git clone https://github.com/elcuervo/gpm-link.git /tmp/gpm-link
cd /tmp/gpm-link
make install

# ### gvp
cd /tmp
git clone https://github.com/pote/gvp.git && cd gvp
git checkout v0.1.0
./configure
make install
cd /tmp

# ### gvp-fish
git clone https://github.com/leeolayvar/gvp-fish && cd gvp-fish
cp bin/gvp-fish /usr/local/bin

# ### goimports
go get github.com/bradfitz/goimports

# ### gocode
go get github.com/nsf/gocode

# ### godef
go get code.google.com/p/rog-go/exp/cmd/godef

# ### go oracle
go get golang.org/x/tools/oracle

# ### gorename
#go get code.google.com/p/go.tools/cmd/gorename
