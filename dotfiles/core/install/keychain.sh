#
# # Keychain
#
# TODO: REMOVE RPM DEPENDENCY

set -e
echo "[keychain.sh] ================== Installing"

rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el5.rf.x86_64.rpm
yum install -y keychain
