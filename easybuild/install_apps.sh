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
#export EASYBUILD_PACKAGEPATH=/easybuildrepo/${os}/${arch}
export EASYBUILD_PACKAGEPATH=/apps/repo/${os}/${arch}
export EASYBUILD_REPOSITORYPATH=~/.local/easybuild/easyconfigs
export EASYBUILD_SOURCEPATH=/easybuildrepo/sources

sudo chmod 777 /apps
mkdir -p ${EASYBUILD_PREFIX}
mkdir -p ${EASYBUILD_PACKAGEPATH}
mkdir -p /easybuildrepo/repo /easybuildrepo/init

eb ${EASYBUILD_REPOSITORYPATH}/f/FPM/FPM-1.3.3-Ruby-2.1.6.eb --robot
module use ${EASYBUILD_PREFIX}/modules/all
ml load FPM/1.3.3-Ruby-2.1.6

#build apps
eb ${EASYBUILD_REPOSITORYPATH}/f/foss/foss-2020a.eb --robot --allow-loaded-modules=Ruby,FPM --sourcepath=/easybuildrepo/sources
eb ${EASYBUILD_REPOSITORYPATH}/o/OSU-Micro-Benchmarks/OSU-Micro-Benchmarks-5.6.3-gompi-2020a.eb --robot --allow-loaded-modules=Ruby,FPM --sourcepath=/easybuildrepo/sources
eb ${EASYBUILD_REPOSITORYPATH}/o/OpenFOAM/OpenFOAM-v2012-foss-2020a.eb --robot --allow-loaded-modules=Ruby,FPM --sourcepath=/easybuildrepo/sources --force
eb ${EASYBUILD_REPOSITORYPATH}/g/GROMACS/GROMACS-2020.1-foss-2020a-Python-3.8.2.eb --robot --allow-loaded-modules=Ruby,FPM --sourcepath=/easybuildrepo/sources --force


# build packages
# foss-2020a toolchain
foss2020a_packages=$(eb ${EASYBUILD_REPOSITORYPATH}/f/foss/foss-2020a.eb --robot --dry-run | grep module | awk '{print $3}')
for package in $foss2020a_packages; do
  echo eb --package ${package} --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM
  eb --package ${package} --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM
done

# osu benchmarks
eb --package ${EASYBUILD_REPOSITORYPATH}/o/OSU-Micro-Benchmarks/OSU-Micro-Benchmarks-5.6.3-gompi-2020a.eb --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM

# openfoam
openfoam_packages=$(eb ${EASYBUILD_REPOSITORYPATH}/o/OpenFOAM/OpenFOAM-v2012-foss-2020a.eb --robot --dry-run | grep module | awk '{print $3}')
for package in $openfoam_packages; do
  echo eb --package ${package} --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM
  if [[ ${package} == "/home/hpcadmin/.local/easybuild/easyconfigs/Tcl/Tcl-8.6.10-GCCcore-9.3.0.eb" ]]; then
    eb --package ${package} --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM --try-amend=start_dir=/apps/easybuild/${os}/${arch}/build/Tcl/8.6.10/GCCcore-9.3.0
  elif [[ ${package} == "/home/hpcadmin/.local/easybuild/easyconfigs/ICU/ICU-66.1-GCCcore-9.3.0.eb" ]]; then
    eb --package ${package} --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM --try-amend=start_dir=/apps/easybuild/${os}/${arch}/build/ICU/66.1/GCCcore-9.3.0
  elif [[ ${package} == "/home/hpcadmin/.local/easybuild/easyconfigs/x265/x265-3.3-GCCcore-9.3.0.eb" ]]; then
    #eb --package ${package} --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM --try-amend=start_dir=/apps/easybuild/${os}/${arch}/build/x265/3.3/GC2Ccore-9.3.0
    eb --package ${package} --robot --rebuild --allow-loaded-modules=Ruby,FPM --force
  elif [[ ${package} == "/home/hpcadmin/.local/easybuild/easyconfigs/o/OpenFOAM/OpenFOAM-v2012-foss-2020a.eb" ]]; then
    eb --package ${package} --robot --rebuild --allow-loaded-modules=Ruby,FPM --force
  else
    eb --package ${package} --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM
  fi
done

# gromacs
gromacs_packages=$(eb ${EASYBUILD_REPOSITORYPATH}/g/GROMACS/GROMACS-2020.1-foss-2020a-Python-3.8.2.eb --robot --dry-run | grep module | awk '{print $3}')
for package in $gromacs_packages; do
  echo eb --package ${package} --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM
  eb --package ${package} --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM
done

cp -r ${EASYBUILD_PACKAGEPATH}/*.rpm /easybuildrepo/${os}/${arch}
createrepo /easybuildrepo/${os}/${arch}/

repo/make-rpm.sh
cp repo/*.rpm /easybuildrepo/repo
