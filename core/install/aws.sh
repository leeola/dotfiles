#
# # AWS CLI
#

set -e
echo "[libsass.sh] ================== Installing"

pip install awscli
ln -s /docker-shared/.aws ~/.aws
