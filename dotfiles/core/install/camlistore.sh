#
# ## Install Camlistore Tools
#
# Not the actual camlistore (as we have no need for that), but the tools
# to interact with it.
#

set -e
echo "[camlistore.sh] ================== Installing"


DESTINATION=/usr/local/bin


# First, make the camlistore binaries
mkdir -p /tmp
git clone https://github.com/camlistore/camlistore /tmp/camlistore
cd /tmp/camlistore
go run make.go


# Now, pick the bin files we care about
mv bin/camtool $DESTINATION
mv bin/camget $DESTINATION
mv bin/camput $DESTINATION
mv bin/cammount $DESTINATION


# Then cleanup the repo.
cd /tmp
rm -rf /tmp/camlistore
