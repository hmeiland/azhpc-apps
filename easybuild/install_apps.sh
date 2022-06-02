#!/bin/bash -e

arch=generic
os=not_defined

vm_sku=$(curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq -r '.compute'.'vmSize')
if [[ $vm_sku == "Standard_HC44rs" ]]; then
        arch=avx_512
fi

if [[ -f /etc/redhat-release ]]; then
	redhat_version=$(cat /etc/redhat-release)
	if [[ $redhat_version == "CentOS Linux release 7.9.2009 (Core)" ]]; then
		os=el7
	fi
fi

export EASYBUILD_PREFIX=/apps/easybuild/${os}/${arch}
echo using prefix ${EASYBUILD_PREFIX}
export EASYBUILD_PACKAGEPATH=/easybuildrepo
export EASYBUILD_REPOSITORYPATH=~/.local/easybuild/easyconfigs
export EASYBUILD_SOURCEPATH=/easybuildrepo/sources

if [[ ! -d /apps ]]; then
  mkdir -p /mnt/resource${EASYBUILD_PREFIX}
  sudo mkdir -p /apps/easybuild/${os}
  sudo chmod 777 /apps/easybuild/${os}
  ln -s /mnt/resource${EASYBUILD_PREFIX} ${EASYBUILD_PREFIX}
fi

eb ${EASYBUILD_REPOSITORYPATH}/f/FPM/FPM-1.3.3-Ruby-2.1.6.eb --robot
module use ${EASYBUILD_PREFIX}/modules/all
ml load FPM/1.3.3-Ruby-2.1.6

eb ${EASYBUILD_REPOSITORYPATH}/f/foss/foss-2020a.eb --robot --allow-loaded-modules=Ruby,FPM --sourcepath=/easybuildrepo/sources
eb --package ${EASYBUILD_REPOSITORYPATH}/m/M4/M4-1.4.19.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM 
eb --package ${EASYBUILD_REPOSITORYPATH}/b/Bison/Bison-3.8.2.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/f/foss/foss-2020a.eb --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM


createrepo ${EASYBUILD_PACKAGEPATH}
