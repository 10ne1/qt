# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

DESCRIPTION="Lightweight IDE for C++ development centering around Qt"
HOMEPAGE="http://trolltech.com/developer/qt-creator"

EGIT_REPO_URI="git://labs.trolltech.com/qt-creator/"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=x11-libs/qt-assistant-4.4.9999
	>=x11-libs/qt-core-4.4.9999
	>=x11-libs/qt-dbus-4.4.9999
	>=x11-libs/qt-gui-4.4.9999
	>=x11-libs/qt-qt3support-4.4.9999
	>=x11-libs/qt-script-4.4.9999
	>=x11-libs/qt-sql-4.4.9999
	>=x11-libs/qt-svg-4.4.9999
	>=x11-libs/qt-test-4.4.9999
	>=x11-libs/qt-webkit-4.4.9999"

RDEPEND="${DEPEND}
	|| ( media-sound/phonon >=x11-libs/qt-phonon-4.4.9999 ) "

src_unpack() {
	git_src_unpack
	#adding paths
	echo 'bin.path = "'${D}'/usr/bin"' >> "${S}"/qtcreator.pro
	echo 'libs.path = "'${D}'/usr/lib"' >> "${S}"/qtcreator.pro
	echo 'docs.path = "'${D}'/usr/share/docs/qt-creator"' >> "${S}"/qtcreator.pro
}

src_compile() {
	qmake -r || die "qmake failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dobin bin/qtcreator || die "dobin failed"
	# installing libraries as the Makefile doesnt
	dolib lib/* || die "dolib failed"
	einfo "Re-building symlinks"
	cd "${D}"/usr/lib
	rm -v lib/{libAggregation.so{,.1,.1.0},libCPlusPlus.so{,.1,.1.0},libExtensionSystem.so{,.1,.1.0}}
	rm -v lib/{libQtConcurrent.so{,.1,.1.0},libUtils.so{,.1,.1.0}}
	for lib in Aggregation CPlusPlus ExtensionSystem \
			QtConcurrent Utils ; do
		dosym lib${lib}.so.1.0.0 lib${lib}.so || die "dosym failed"
		dosym lib${lib}.so.1.0.0 lib${lib}.so.1 || die "dosym failed"
		dosym lib${lib}.so.1.0.0 lib${lib}.so.1.0 || die "dosym failed"
	done
}
