#!/bin/bash -e

arch=generic
os=not_defined

vm_sku=$(curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq -r '.compute'.'vmSize')
if [[ $vm_sku == "Standard_HC44rs" ]]; then
        arch=hc
elif [[ $vm_sku == "Standard_HB60rs" ]]; then
        arch=hb
elif [[ $vm_sku == "Standard_HB120rs_v2" ]]; then
        arch=hbv2
else
    echo "sku not found"
    exit
fi

if [[ -f /etc/redhat-release ]]; then
	redhat_version=$(cat /etc/redhat-release)
	if [[ $redhat_version == "CentOS Linux release 7.9.2009 (Core)" ]]; then
		os=centos7
	else 
		echo "redhat version not matching"
		exit
	fi
else
	echo "looks like this is not redhat"
	exit
fi


if [[ ! -f /apps/easybuild/${os}/${arch}/modules/all/foss/2020a.lua ]]; then
	echo "toolchain not found: please install first"
	exit
fi

export EASYBUILD_PREFIX=/apps/easybuild/${os}/${arch}
echo using prefix ${EASYBUILD_PREFIX}
#export EASYBUILD_PACKAGEPATH=/easybuildrepo/${os}/${arch}
export EASYBUILD_PACKAGEPATH=/apps/repo/${os}/${arch}
export EASYBUILD_REPOSITORYPATH=~/.local/easybuild/easyconfigs
export EASYBUILD_SOURCEPATH=/easybuildrepo/sources

sudo chmod 777 /apps
mkdir -p ${EASYBUILD_PREFIX}
mkdir -p ${EASYBUILD_PACKAGEPATH}
mkdir -p /easybuildrepo/repo /easybuildrepo/init

module use ${EASYBUILD_PREFIX}/modules/all
ml load FPM/1.3.3-Ruby-2.1.6

#build apps
eb ${EASYBUILD_REPOSITORYPATH}/g/GROMACS/GROMACS-2020.1-foss-2020a-Python-3.8.2.eb --robot --allow-loaded-modules=Ruby,FPM --sourcepath=/easybuildrepo/sources --force


# build packages
# gromacs
gromacs_packages=$(eb ${EASYBUILD_REPOSITORYPATH}/g/GROMACS/GROMACS-2020.1-foss-2020a-Python-3.8.2.eb --robot --dry-run | grep module | awk '{print $3}')
for package in $gromacs_packages; do
  if [[ ${package} == "/home/hpcadmin/.local/easybuild/easyconfigs/Tcl/Tcl-8.6.10-GCCcore-9.3.0.eb" ]]; then
    eb --package ${package} --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM --try-amend=start_dir=/apps/easybuild/${os}/${arch}/build/Tcl/8.6.10/GCCcore-9.3.0
  elif [[ ${package} == "/home/hpcadmin/.local/easybuild/easyconfigs/g/GROMACS/GROMACS-2020.1-foss-2020a-Python-3.8.2.eb" ]]; then
    eb --package ${package} --robot --rebuild --allow-loaded-modules=Ruby,FPM --force
  else
    eb --package ${package} --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM
  fi
done

cp -r ${EASYBUILD_PACKAGEPATH}/*.rpm /easybuildrepo/${os}/${arch}
createrepo /easybuildrepo/${os}/${arch}/

