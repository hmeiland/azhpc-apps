#!/bin/bash -e

rpmbuild
tar -cf azurehpc-application-repo.tar azurehpc-application.repo
cp azurehpc-application-repo.tar ~/rpmbuild/SOURCES
rpmbuild -ba azurehpc-application-repository.spec
