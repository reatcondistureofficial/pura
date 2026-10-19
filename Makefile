PREFIX ?= /usr/local
DESTDIR ?=
BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/share/man/man1
DATADIR ?= $(PREFIX)/share

.PHONY: all install uninstall test dist deb clean

all:
	@printf '%s\n' 'Pura kaynak ağacı hazır. `make test` veya `make install` çalıştırın.'

install:
	install -Dm755 src/pura "$(DESTDIR)$(BINDIR)/pura"
	install -Dm644 docs/pura.1 "$(DESTDIR)$(MANDIR)/pura.1"
	install -Dm644 completions/pura.bash "$(DESTDIR)$(DATADIR)/bash-completion/completions/pura"
	install -Dm644 completions/pura.fish "$(DESTDIR)$(DATADIR)/fish/vendor_completions.d/pura.fish"

uninstall:
	rm -f "$(DESTDIR)$(BINDIR)/pura" "$(DESTDIR)$(MANDIR)/pura.1"
	rm -f "$(DESTDIR)$(DATADIR)/bash-completion/completions/pura"
	rm -f "$(DESTDIR)$(DATADIR)/fish/vendor_completions.d/pura.fish"

test:
	./tests/test_pura.sh

dist:
	mkdir -p dist
	version=$$(sed -n 's/^VERSION="\([^\"]*\)"/\1/p' src/pura); \
	find . -type f ! -path './dist' ! -path './dist/*' -print0 | \
	tar -czf "dist/pura-$$version.tar.gz" \
		--exclude-vcs --transform="s,^\./,pura-$$version/," \
		--null --files-from=-

deb:
	mkdir -p dist
	version=$$(sed -n 's/^VERSION="\([^\"]*\)"/\1/p' src/pura); \
	root="dist/deb-root"; rm -rf "$$root"; \
	install -d "$$root/DEBIAN" "$$root/usr/bin" \
		"$$root/usr/share/man/man1" \
		"$$root/usr/share/bash-completion/completions" \
		"$$root/usr/share/fish/vendor_completions.d"; \
	printf '%s\n' \
		'Package: pura' \
		"Version: $$version-1" \
		'Section: utils' \
		'Priority: optional' \
		'Architecture: all' \
		'Depends: coreutils, findutils, gawk, util-linux' \
		'Maintainer: pura contributors <maintainers@example.invalid>' \
		'Description: safe Linux disk space recovery CLI' \
		' pura cleans rebuildable caches without raw block-device destruction.' \
		> "$$root/DEBIAN/control"; \
	install -m755 src/pura "$$root/usr/bin/pura"; \
	install -m644 docs/pura.1 "$$root/usr/share/man/man1/pura.1"; \
	install -m644 completions/pura.bash "$$root/usr/share/bash-completion/completions/pura"; \
	install -m644 completions/pura.fish "$$root/usr/share/fish/vendor_completions.d/pura.fish"; \
	dpkg-deb --build --root-owner-group "$$root" "dist/pura_$${version}-1_all.deb"; \
	rm -rf "$$root"

clean:
	rm -rf dist
