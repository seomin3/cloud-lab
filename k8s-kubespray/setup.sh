#!/bin/bash

# add user for ansible
id ansible > /dev/null
if [ "$?" != '0' ]; then
  groupadd -g 1500 ansible
  useradd -s '/bin/bash' -m -u 1500 -g 1500 ansible
  sh -c "echo 'ansible ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/ansible"
  echo 'ansible:pass!!'| chpasswd
fi

# install python2
apt-get install -q -y python

case "$1" in
  master)
    # init master with ansible
    export LC_ALL=en_US.UTF-8
    ANSIBLE_CFG='/home/ubuntu/ansible.cfg'
    if [ ! -f $ANSIBLE_CFG ]; then
      apt-get install -q -y python-pip python-dev python-netaddr
      apt-get install -q -y build-essential libssl-dev libffi-dev sshpass
      pip install --upgrade ansible jinja2 pip
      curl -s -o $ANSIBLE_CFG https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg
      perl -pi -e 's/^#host_key_checking/host_key_checking/' $ANSIBLE_CFG
      chown ubuntu. $ANSIBLE_CFG
    fi
    ;;
  node)
    perl -pi -e 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="swapaccount=1"/' /etc/default/grub
    update-grub2
    curl -s -o /home/ubuntu/check-config.sh https://raw.githubusercontent.com/moby/moby/master/contrib/check-config.sh
    init 6
esac
