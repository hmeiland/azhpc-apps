# azhpc-apps

This repository holds optimized binaries for Azure vm's. The rpm's will install to /apps, make sure this (shared) directory has enough space. 
The modules are build for Lmod, make sure this is installed in your images.


To install the repo's:

```
sudo yum install https://azhpcrepo.blob.core.windows.net/easybuild/repo/azurehpc-application-repository-20220603-1.el7.noarch.rpm
```

and to install applications/toolchains:

```
sudo yum install --enablerepo=azurehpc-centos7-hc foss-2020a
```
```
sudo yum install --enablerepo=azurehpc-centos7-hb foss-2020a
```
```
sudo yum install --enablerepo=azurehpc-centos7-hbv2 foss-2020a
```

