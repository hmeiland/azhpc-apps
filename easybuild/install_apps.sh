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

eb ${EASYBUILD_REPOSITORYPATH}/f/FPM/FPM-1.3.3-Ruby-2.1.6.eb --robot
module use ${EASYBUILD_PREFIX}/modules/all
ml load FPM/1.3.3-Ruby-2.1.6

eb ${EASYBUILD_REPOSITORYPATH}/f/foss/foss-2020a.eb --robot --allow-loaded-modules=Ruby,FPM --sourcepath=/easybuildrepo/sources
eb --package ${EASYBUILD_REPOSITORYPATH}/m/M4/M4-1.4.19.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM 
eb --package ${EASYBUILD_REPOSITORYPATH}/b/Bison/Bison-3.8.2.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/f/flex/flex-2.6.4.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/z/zlib/zlib-1.2.11.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/b/binutils/binutils-2.34.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/g/GCCcore/GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/z/zlib/zlib-1.2.11-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/h/help2man/help2man-1.47.12-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/m/M4/M4-1.4.18-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/b/Bison/Bison-3.5.3-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/f/flex/flex-2.6.4-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/b/binutils/binutils-2.34-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/p/pkg-config/pkg-config-0.29.2-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/l/libfabric/libfabric-1.11.0-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/g/GCC/GCC-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/o/OpenBLAS/OpenBLAS-0.3.9-GCC-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/l/libevent/libevent-2.1.11-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/l/libtool/libtool-2.4.6-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/n/ncurses/ncurses-6.1.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/g/gettext/gettext-0.20.1.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/x/XZ/XZ-5.2.5-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/l/libxml2/libxml2-2.9.10-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/e/expat/expat-2.2.9-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/n/ncurses/ncurses-6.2-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/p/Perl/Perl-5.30.2-GCCcore-9.3.0-minimal.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/m/makeinfo/makeinfo-6.7-GCCcore-9.3.0-minimal.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/g/groff/groff-1.22.4-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/l/libreadline/libreadline-8.0-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/d/DB/DB-18.1.32-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/p/Perl/Perl-5.30.2-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/a/Autoconf/Autoconf-2.69-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/a/Automake/Automake-1.16.1-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/a/Autotools/Autotools-20180311-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/x/xorg-macros/xorg-macros-1.19.2-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/n/numactl/numactl-2.0.13-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/u/UCX/UCX-1.8.0-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/l/libpciaccess/libpciaccess-0.16-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/h/hwloc/hwloc-2.2.0-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/p/PMIx/PMIx-3.1.5-GCCcore-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/o/OpenMPI/OpenMPI-4.0.3-GCC-9.3.0.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/g/gompi/gompi-2020a.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/f/FFTW/FFTW-3.3.8-gompi-2020a.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/s/ScaLAPACK/ScaLAPACK-2.1.0-gompi-2020a.eb --skip --rebuild --allow-loaded-modules=Ruby,FPM
eb --package ${EASYBUILD_REPOSITORYPATH}/f/foss/foss-2020a.eb --robot --skip --rebuild --allow-loaded-modules=Ruby,FPM


createrepo ${EASYBUILD_PACKAGEPATH}
