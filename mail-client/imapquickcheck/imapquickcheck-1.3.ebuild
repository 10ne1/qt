# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

LANGS="fr"

inherit eutils qt4-edge

MY_PN=ImapQuickCheck

DESCRIPTION="Lightweight systray IMAP mail checker"
HOMEPAGE="http://qt-apps.org/content/show.php/ImapQuickCheck?content=110821"
SRC_URI="http://qt-apps.org/CONTENT/content-files/110821-${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4
	x11-libs/qt-sql:4"
RDEPEND="${DEPEND}
	dev-python/pysqlite:2"

src_prepare() {
	epatch "${FILESDIR}"/${P}-desktopfile.patch

	sed -i -e '/\.ts/d' ${MY_PN}.pro || die "sed failed"

	local ts
	for lingua in $LINGUAS; do
		if has $lingua $LANGS; then
			ts="${ts} ts/${PN}_${lingua}.ts"
		fi
	done

	if [[ -n ${ts} ]]; then
		echo "TRANSLATIONS = ${ts}" >> ${MY_PN}.pro || die "echo failed"
		lrelease ${MY_PN}.pro || die "Generating translations failed"
	fi
}

src_install() {
	dobin ${PN}
	dodoc README.txt
	domenu ${PN}.desktop

	local lingua
	for lingua in $LINGUAS; do
		if has $lingua $LANGS; then
			insinto "/usr/share/${PN}/translations"
			doins "ts/${PN}_${lingua}.ts" || "Installing translations failed"
		fi
	done
}