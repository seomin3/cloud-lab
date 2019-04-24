#!/bin/bash

[ ! $(which git) ] && sudo yum -y -d 1 install git
[ ! -d devstack ] && git clone https://git.openstack.org/openstack-dev/devstack
chown -R vagrant. devstack
exit 0
