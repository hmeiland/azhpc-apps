#!/bin/bash -e

mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
rpmbuild -ba repo/azurehpc-application-repository.spec
cp ~/rpmbuild/RPMS/noarch/azurehpc-application-repository-*-1.el7.noarch.rpm repo/
