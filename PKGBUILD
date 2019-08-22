# This file is part of BlackArch Linux ( http://blackarch.org ).
# See COPYING for license details.

pkgname='blackarch-menus-extended'
pkgver='0.2'
pkgrel=1
groups=('blackarch')
pkgdesc="BlackArch specific XDG-compliant menu"
arch=('any')
url="http://www.blackarch.org/"
license=('GPL')
depends=('xdg-utils')
conflicts=('blackarch-menus')
source=("git+https://github.com/xeyqe/blackarch-menus-extended.git")
md5sums=('SKIP')

prepare() {
	cd "${srcdir}"	
}

package() {
	install -m755 -d "${pkgdir}/etc/xdg/menus/applications-merged"
	install -m755 -d "${pkgdir}/usr/share/applications"
	install -m755 -d "${pkgdir}/usr/share/desktop-directories"
	install -m755 -d "${pkgdir}/usr/local/bin"
	install -dm 755 "$pkgdir/usr/share/icons/hicolor/32x32/apps"



	install -m644 directories/X-BlackArch.menu "${pkgdir}/etc/xdg/menus/applications-merged/"
	install -m644 directories/*.directory "${pkgdir}/usr/share/desktop-directories/"
	install -m644 desktop_files/*.desktop "${pkgdir}/usr/share/applications/"
	install -m755 blackarch-menu-scripts/appHelper.sh "${pkgdir}/usr/local/bin"
	install -m 644 directories/*.png "$pkgdir/usr/share/icons/hicolor/32x32/apps/"
}
