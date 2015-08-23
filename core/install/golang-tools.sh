#
# ## Install Go Tools
#

set -e
echo "[golang-tools.sh] ================== Installing"

# ### godeps
go get github.com/tools/godep
mv /go/bin/godep /usr/local/bin/godep

# ### gpm-link
git clone https://github.com/elcuervo/gpm-link.git /tmp/gpm-link
cd /tmp/gpm-link
make install
rm -rf /tmp/gpm-link

# ### goimports
go get github.com/bradfitz/goimports
mv /go/bin/goimports /usr/local/bin/goimports

# ### gocode
go get github.com/nsf/gocode
mv /go/bin/gocode /usr/local/bin/gocode

# ### godef
go get code.google.com/p/rog-go/exp/cmd/godef
mv /go/bin/godef /usr/local/bin/godef

# ### go oracle
go get golang.org/x/tools/cmd/oracle
mv /go/bin/oracle /usr/local/bin/oracle

# ### gorename
# Not sure why this is disabled?
#go get code.google.com/p/go.tools/cmd/gorename
