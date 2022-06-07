#!/bin/bash -e

mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
git checkout azurehpc-application.repo
#tar -cf azurehpc-application-repo.tar azurehpc-application.repo
#cp azurehpc-application-repo.tar ~/rpmbuild/SOURCES
rpmbuild -ba azurehpc-application-repository.spec
cp ~/rpmbuild/RPMS/noarch/azurehpc-application-repository-*-1.el7.noarch.rpm .
