#
# ## Install Go Tools
#

set -e
echo "[golang-tools.sh] ================== Installing"

# ### godeps
go get github.com/tools/godep

# ### gpm-link
git clone https://github.com/elcuervo/gpm-link.git /tmp/gpm-link
cd /tmp/gpm-link
make install

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
