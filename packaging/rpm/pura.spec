Name:           pura
Version:        0.1.0
Release:        1%{?dist}
Summary:        Safe Linux disk space recovery CLI
License:        MIT
URL:            https://github.com/reatcondistureofficial/pura
BuildArch:      noarch
Requires:       coreutils
Requires:       findutils
Requires:       gawk
Requires:       util-linux
Suggests:        fish
Source0:        %{name}-%{version}.tar.gz

%description
pura safely cleans rebuildable user caches, package-manager caches, old systemd
journal entries, managed temporary files, and the current user's trash. It
refuses raw block-device destruction.

%prep
%autosetup

%build
:

%install
rm -rf %{buildroot}
install -Dpm0755 src/pura %{buildroot}%{_bindir}/pura
install -Dpm0644 docs/pura.1 %{buildroot}%{_mandir}/man1/pura.1
install -Dpm0644 completions/pura.bash %{buildroot}%{_datadir}/bash-completion/completions/pura
install -Dpm0644 completions/pura.fish %{buildroot}%{_datadir}/fish/vendor_completions.d/pura.fish

%files
%license LICENSE
%doc README.md
%{_bindir}/pura
%{_mandir}/man1/pura.1*
%{_datadir}/bash-completion/completions/pura
%{_datadir}/fish/vendor_completions.d/pura.fish

%changelog
* Mon Oct 19 2026 pura contributors <maintainers@example.invalid> - 0.1.0-1
- Initial package.
