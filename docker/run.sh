#!/bin/bash

# docker
curl -sSL https://get.docker.com/ | sh
systemctl start docker
usermod -G docker ubuntu

# docker-machine
curl -Q -L https://github.com/docker/machine/releases/download/v0.12.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
  chmod +x /tmp/docker-machine &&
  sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

# docker-compose
curl -Q -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# source
git clone https://github.com/russmckendrick/mastering-docker.git

# kernel
# ref: https://docs.docker.com/engine/installation/linux/linux-postinstall/#your-kernel-does-not-support-cgroup-swap-limit-capabilities
perl -pi -e 's/^GRUB_CMDLINE_LINUX="(.*)"/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/' /etc/default/grub

# check docker version
echo "=== docker ==="
docker version
echo
echo "=== docker-compose ==="
docker-compose version
echo
echo "=== docker-compose ==="
docker-machine version
