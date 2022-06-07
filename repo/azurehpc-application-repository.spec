Name:           azurehpc-application-repository
Version:        20220603
Release:        1%{?dist}
Summary:        Repository configuration for AzureHPC applications

Group:          system
License:        Microsoft Open Source
URL:            https://github.com/hmeiland/azure-apps
BuildArch:      noarch

%description
Azure HPC applications repositories file, to enable RPM installations

%build
cat > azurehpc-application.repo <<EOF
[azurehpc-centos7-hc]
name=Azure HPC applications - CentOS7 - HC
baseurl=https://azhpcrepo.blob.core.windows.net/easybuild/centos7/hc
enabled=0
gpgcheck=0

[azurehpc-centos7-hb]
name=Azure HPC applications - CentOS7 - HB
baseurl=https://azhpcrepo.blob.core.windows.net/easybuild/centos7/hb
enabled=0
gpgcheck=0
EOF

%install
mkdir -p %{buildroot}/etc/yum.repos.d
install -m 644 azurehpc-application.repo %{buildroot}/etc/yum.repos.d/azurehpc-application.repo

%files
%attr(0644, root, root) /etc/yum.repos.d/azurehpc-application.repo


%changelog
* Fri Jun 3 2022 Hugo Meiland <hugo.meiland@microsoft.com>
  - create spec file
  - add repo for HC and HB
