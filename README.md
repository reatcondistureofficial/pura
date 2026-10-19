# pura

`pura`, Linux'ta yeniden oluşturulabilir cache'leri, paket yöneticisi cache'lerini, systemd journal kayıtlarını, geçici dosya bakımını ve kullanıcı çöp kutusunu güvenli varsayılanlarla temizleyen, POSIX `sh` ile yazılmış bir terminal aracıdır. Bash, Fish, Zsh ve diğer shell'lerden çağrılabilir.

## Kurulum

Kaynak ağacından:

```sh
make test
sudo make install
```

Arch/CachyOS'ta AUR kullanmadan yerel paket:

```sh
(cd packaging/arch && makepkg -f)
sudo pacman -U ./packaging/arch/pura-0.1.0-1-any.pkg.tar.zst
```

Debian/Ubuntu için:

```sh
make deb
sudo apt install ./dist/pura_0.1.0-1_all.deb
```

Debhelper kuruluysa Debian kaynak paketi de `dpkg-buildpackage -us -uc -b` ile üretilebilir.

## Komutlar

```sh
pura scan                         # / için salt okunur kullanım özeti
pura scan /home                   # bir dizini salt okunur tara
pura clean all --dry-run          # hiçbir şeyi değiştirmeden planı göster
sudo pura clean packages          # kurulu paketleri silmeden paket cache'ini temizle
pura clean caches                 # bilinen kullanıcı cache'lerini temizle
pura clean trash                  # kullanıcı çöp kutusunu boşalt
sudo pura clean logs              # journal'ı 14 gün ile sınırla
sudo pura clean temp              # systemd-tmpfiles bakımını çalıştır
pura clean all --aggressive       # daha geniş kullanıcı cache'i + kullanılmayan Flatpak
pura doctor                       # dağıtımı ve yardımcı araçları göster
pura explain                      # güvenlik sınırlarını göster
```

## Aygıt yolu

İstenen kısa biçim desteklenir:

```sh
pura clean /dev/sda
```

Eşdeğer açık biçim `pura clean disk /dev/sda` şeklindedir. Bu komut disk silici değildir: aygıtın bağlı filesystem'lerini bulur; bağlı değilse reddeder; bölüm tablosuna, filesystem'e veya ham aygıta yazmaz; yalnızca seçilen filesystem ile aynı aygıt üzerinde olduğu doğrulanan kullanıcı cache/çöp yollarını temizlemeyi dener; ve etkileşimli olarak `CLEAN /dev/sda` onayı ister. Mount durumu onay sırasında değişirse komut durur.

Ham aygıtı “yer açmak” için silmek veri kaybına neden olur; bu yüzden `dd`, `wipefs`, `mkfs`, `fdisk`, `sfdisk` veya `parted` çalıştırılmaz. Önce `pura scan disk /dev/sda` ve `pura clean all --dry-run` kullanın. `--aggressive`, cache içeriğini genişletir ve kullanılmayan Flatpak runtime'larını kaldırabilir; kuru çalıştırma planını mutlaka inceleyin.

## Paketleme

- `packaging/arch/PKGBUILD`: Arch Linux ve CachyOS için `any` paketi.
- `debian/`: Debian/Ubuntu metadata; `make deb` doğrudan `.deb` üretir.
- `packaging/rpm/pura.spec`: Fedora/openSUSE gibi RPM tabanlı sistemler için spec.
- `.github/workflows/packages.yml`: CI testleri ve Debian/tarball artefaktı.

Paket tarifleri resmi dağıtım depolarına otomatik gönderim yapmaz. CachyOS'ta yerel `makepkg` yolu AUR olmadan kullanılabilir; diğer dağıtımlarda repo bakımcılarına gönderim ayrıca yapılmalıdır.

## Lisans

MIT. Bkz. [`LICENSE`](LICENSE).
