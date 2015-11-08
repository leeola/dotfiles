#
# ## Install Go Tools
#

set -e
echo "[golang-tools.sh] ================== Installing"

# ### godeps
#
# TODO: Deprecate, once it's no longer needed for work.
go get github.com/tools/godep
mv $GOBIN/godep /usr/local/bin/godep

# ### govendor
go get github.com/kardianos/govendor
mv $GOBIN/govendor /usr/local/bin/govendor

# ### gpm-link
#
# TODO: Deprecate
git clone https://github.com/elcuervo/gpm-link.git /tmp/gpm-link
pushd /tmp/gpm-link
make install
popd
rm -rf /tmp/gpm-link

# ### goimports
go get golang.org/x/tools/cmd/goimports
mv $GOBIN/goimports /usr/local/bin/goimports

# ### gocode
go get github.com/nsf/gocode
mv $GOBIN/gocode /usr/local/bin/gocode

# ### godef
go get code.google.com/p/rog-go/exp/cmd/godef
mv $GOBIN/godef /usr/local/bin/godef

# ### go oracle
go get golang.org/x/tools/cmd/oracle
mv $GOBIN/oracle /usr/local/bin/oracle

# ### gorename
go get golang.org/x/tools/cmd/gorename
mv $GOBIN/gorename /usr/local/bin/gorename

# ### golint
go get -u github.com/golang/lint/golint
mv $GOBIN/golint /usr/local/bin/golint

