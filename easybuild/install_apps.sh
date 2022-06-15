#!/bin/bash -e

arch=generic
os=not_defined

vm_sku=$(curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq -r '.compute'.'vmSize')
if [[ $vm_sku == "Standard_HC44rs" ]]; then
        arch=hc
elif [[ $vm_sku == "Standard_HB60rs" ]]; then
        arch=hb
fi

if [[ -f /etc/redhat-release ]]; then
	redhat_version=$(cat /etc/redhat-release)
	if [[ $redhat_version == "CentOS Linux release 7.9.2009 (Core)" ]]; then
		os=centos7
	fi
fi

export EASYBUILD_PREFIX=/apps/easybuild/${os}/${arch}
echo using prefix ${EASYBUILD_PREFIX}
export EASYBUILD_PACKAGEPATH=/easybuildrepo/${os}/${arch}
export EASYBUILD_REPOSITORYPATH=~/.local/easybuild/easyconfigs
export EASYBUILD_SOURCEPATH=/easybuildrepo/sources

sudo chmod 777 /apps
mkdir -p ${EASYBUILD_PREFIX}
mkdir -p ${EASYBUILD_PACKAGEPATH}
mkdir -p /easybuildrepo/repo /easybuildrepo/init

eb ${EASYBUILD_REPOSITORYPATH}/f/FPM/FPM-1.3.3-Ruby-2.1.6.eb --robot
module use ${EASYBUILD_PREFIX}/modules/all
ml load FPM/1.3.3-Ruby-2.1.6

# foss-2020a toolchain
eb ${EASYBUILD_REPOSITORYPATH}/f/foss/foss-2020a.eb --robot --allow-loaded-modules=Ruby,FPM --sourcepath=/easybuildrepo/sources
foss-2020a_packages=$(eb ${EASYBUILD_REPOSITORYPATH}/f/foss/foss-2020a.eb --robot --dry-run | grep module | awk '{print $3}'})
for package in $foss-2020a_packages; do
  eb --package ${package} --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM
done

# osu benchmarks
eb ${EASYBUILD_REPOSITORYPATH}/o/OSU-Micro-Benchmarks/OSU-Micro-Benchmarks-5.6.3-gompi-2020a.eb --robot --allow-loaded-modules=Ruby,FPM --sourcepath=/easybuildrepo/sources
eb --package ${EASYBUILD_REPOSITORYPATH}/o/OSU-Micro-Benchmarks/OSU-Micro-Benchmarks-5.6.3-gompi-2020a.eb --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM

# openfoam
eb ${EASYBUILD_REPOSITORYPATH}/o/OpenFOAM/OpenFOAM-v2012-foss-2020a.eb --robot --allow-loaded-modules=Ruby,FPM --sourcepath=/easybuildrepo/sources
openfoam_packages=$(eb ${EASYBUILD_REPOSITORYPATH}/o/OpenFOAM/OpenFOAM-v2012-foss-2020a.eb --robot --dry-run | grep module | awk '{print $3}'})
for package in $openfoam_packages; do
  eb --package ${package} --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM
done


createrepo ${EASYBUILD_PACKAGEPATH}

repo/make-rpm.sh
cp repo/*.rpm /easybuildrepo/repo
