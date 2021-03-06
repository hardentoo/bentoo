# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later

EAPI="6"

# ATTENTION This package is Python3 only!
# 2.5h <-- Increment this wasted time counter if your are dare to make it Python2 compatible!
PYTHON_COMPAT=( python3_{3,4,5} )
DISTUTILS_SINGLE_IMPL="yes"

inherit distutils-r1

DESCRIPTION="Pluggable Output Processor"
HOMEPAGE="https://github.com/zaufi/pluggable-output-processor"
if [[ ${PV} == 9999* ]] ; then
		inherit git-r3
		EGIT_REPO_URI="https://github.com/zaufi/pluggable-output-processor.git"
		KEYWORDS=""
else
		SRC_URI="https://github.com/zaufi/${PN}/archive/version-${PV}.tar.gz -> ${P}.tar.gz"
		KEYWORDS="~amd64 ~x86"
		S="${WORKDIR}/${PN}-version-${PV}"
fi

LICENSE="GPL-3"
SLOT="0"
RDEPEND="
    ${PYTHON_DEPS}
    >=sys-apps/portage-2.2.12[python3(+)]
    dev-python/termcolor[${PYTHON_USEDEP}]
    app-admin/eselect
"
DEPEND="${RDEPEND}"
IUSE=""

DOCS=( 'README.md' 'LICENSE' )

python_install() {
    distutils-r1_python_install

    # NOTE Stupid Python's distutils do copy for symlinked files,
    # so lets recreate symlinks again after install...
    local pp_dir=$(python_get_sitedir)/outproc/pp
    local i
    for i in cc c++ g++; do
        rm ${D}/${pp_dir}/${i}.py
        dosym ${pp_dir}/gcc.py ${pp_dir}/${i}.py
    done

    # Install eselect module
    insinto ${EPREFIX}/usr/share/eselect/modules
    sed -i "s,python,${PYTHON},g" ${D}/contrib/outproc.eselect
    doins contrib/outproc.eselect

    # Make a dir required for eselect
    keepdir ${EPREFIX}/usr/$(get_libdir)/outproc/bin
}

pkg_postinst() {
    elog "To enable some command post-processing module on a per-user basis run:"
    elog "  eselect outproc enable --user <module>"
    elog
    elog "To enable it system-wide run:"
    elog "  eselect outproc enable <module>"
    elog
    elog "To get list of available modules:"
    elog "  eselect outproc list"
    ewarn "Make sure ${EPREFIX}/usr/$(get_libdir)/outproc/bin is a very first directory in your PATH"
}

pkg_prerm() {
    local modules=$(ls ${EPREFIX}/usr/$(get_libdir)/outproc/bin)
    if [[ -n "$modules" ]]; then
        elog "Note there are some modules still configured:"
        elog $(eselect outproc show)
    fi
}
