# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later

EAPI=6
# eutils for einstalldocs
inherit epatch epunt-cxx eutils libtool ltprune multilib multilib-minimal

DESCRIPTION="The MAD id3tag library"
HOMEPAGE="http://www.underbit.com/products/mad/"
SRC_URI="mirror://sourceforge/mad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="debug static-libs"

RDEPEND=">=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r6
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	dev-util/gperf
	sys-devel/ipatch"

src_prepare() {
	epunt_cxx #74489
	ipatch push . "${FILESDIR}/${PV}"/
	# gperf 3.1 and newer generate code with a size_t length parameter,
	# older versions are incompatible and take an unsigned int.
	has_version '<dev-util/gperf-3.1' && ipatch pop . "${FILESDIR}/${PV}/${P}-fix-signature.patch"

	elibtoolize #sane .so versionning on fbsd and .so -> .so.version symlink
	eapply_user
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		$(use_enable debug debugging)
}

multilib_src_install() {
	default

	# This file must be updated with every version update
	insinto /usr/$(get_libdir)/pkgconfig
	doins "${FILESDIR}"/id3tag.pc
	sed -i \
		-e "s:prefix=.*:prefix=${EPREFIX}/usr:" \
		-e "s:libdir=\${exec_prefix}/lib:libdir=${EPREFIX}/usr/$(get_libdir):" \
		-e "s:0.15.0b:${PV}:" \
		"${ED}"/usr/$(get_libdir)/pkgconfig/id3tag.pc || die
}

multilib_src_install_all() {
	prune_libtool_files --all
	einstalldocs
}
