#!/bin/bash


export EASYBUILD_PREFIX=/apps/easybuild/el7/avx_512
export EASYBUILD_REPOSITORYPATH=~/.local/easybuild/easyconfigs

mkdir -p /mnt/resource${EASYBUILD_PREFIX}
sudo mkdir -p /apps/easybuild/el7
sudo chmod 777 /apps/easybuild/el7
ln -s /mnt/resource${EASYBUILD_PREFIX} ${EASYBUILD_PREFIX}

eb ${EASYBUILD_REPOSITORYPATH}/f/FPM/FPM-1.3.3-Ruby-2.1.6.eb --robot
module use ${EASYBUILD_PREFIX}/modules/all
ml load FPM/1.3.3-Ruby-2.1.6

eb ${EASYBUILD_REPOSITORYPATH}/m/M4/M4-1.4.19.eb
eb --package ${EASYBUILD_REPOSITORYPATH}/m/M4/M4-1.4.19.eb --skip --rebuild
