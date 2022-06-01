#!/bin/bash


export EASYBUILD_PREFIX=/apps/easybuild/el7/avx_512

mkdir -p /mnt/resource${EASYBUILD_PREFIX}
sudo mkdir /apps
sudo chmod 777 /apps
ln -s /mnt/resource${EASYBUILD_PREFIX} ${EASYBUILD_PREFIX}

eb m/M4/M4-1.4.19.eb
