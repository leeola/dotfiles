# # Install Docker
#
# In the cases where Dotfiles are being run inside of Docker,
# this will be used to run Docker in Docker.

set -e
echo "[docker.sh] ================== Installing"

yum install -y libvirt libvirt-client python-virtinst
curl -Lo /usr/local/bin/docker https://get.docker.io/builds/Linux/x86_64/docker-1.9.0
chmod +x /usr/local/bin/docker
