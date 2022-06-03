Name:           azurehpc-application-repository
Version:        20220603
Release:        1%{?dist}
Summary:        Repository configuration for AzureHPC applications

Group:          system
License:        Microsoft Open Source
URL:            https://github.com/hmeiland/azure-apps
Source0:        azurehpc-repo.tar
BuildArch:      noarch

#BuildRequires:
#Requires:

%description


%prep
echo "BUILDROOT = $RPM_BUILD_ROOT"
mkdir -p $RPM_BUILD_ROOT/etc/yum.repos.d
cp $RPM_BUILD_ROOT/../../SOURCES/azure-hpc.repo $RPM_BUILD_ROOT/etc/yum.repos.d/azurehpc-application.repo
exit

%files
%attr(0644, root, root) /etc/yum.repos.d/azurehpc-application.repo


%changelog
* Fri Jun 3 2022 Hugo Meiland <hugo.meiland@microsoft.com>
  - create spec file
  - add repo for HC and HB
