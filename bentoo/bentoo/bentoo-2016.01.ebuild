# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI="6"
DESCRIPTION="Bentoo meta ebuild to install all apps"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
KEYWORDS="amd64 arm x86"
SLOT="0"
LICENSE="GPL-3"
IUSE="enlightenment gnome kde mate +mobile +pelican xfce"

DEPEND=""

RDEPEND=""

PDEPEND="
	bentoo/bentoo-browser
	bentoo/bentoo-editors
	bentoo/bentoo-firmware
	enlightenment? ( bentoo/bentoo-enlightenment )
	gnome? ( bentoo/bentoo-gnome )
	kde? ( bentoo/bentoo-kde )
	mate? ( bentoo/bentoo-mate )
	mobile? ( bentoo/bentoo-mobile )
	pelican? ( bentoo/bentoo-pelican )
	xfce? ( bentoo/bentoo-xfce )
	bentoo/bentoo-system
"

