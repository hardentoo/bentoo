# Copyright 1999-2015 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5
KEYWORDS="amd64 arm x86"
DESCRIPTION="Bentoo irssi meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SLOT="0"
LICENSE="GPL-3"
IUSE=""

S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	net-irc/irssi
	"

src_install() {
	insinto /usr/share/pixmaps
	doins "${FILESDIR}"/*.svg || die "doins pixmaps failed"
	insinto /usr/share/applications
	doins "${FILESDIR}"/*.desktop || die "domenu *.desktop failed"
}
