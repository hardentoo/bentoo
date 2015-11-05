# Copyright 1999-2015 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5

inherit mozilla-addon

MOZ_FILEID="60265"
DESCRIPTION="Adds the ability to create and edit entries in the password manager."
HOMEPAGE="https://addons.mozilla.org/en-GB/firefox/addon/saved-password-editor/"
SRC_URI="https://addons.mozilla.org/firefox/downloads/latest/${MOZ_FILEID} -> ${P}.xpi"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="amd64 x86"
KEYWORDS="~amd64 ~x86"
IUSE="+symlink_all_targets target_firefox target_thunderbird target_seamonkey target_firefox-bin target_thunderbird-bin target_seamonkey-bin"

# symlink all possible target paths if this is set
if use symlink_all_targets; then
	MZA_TARGETS="firefox thunderbird seamonkey firefox-bin thunderbird-bin seamonkey-bin"
else
	use target_firefox && MZA_TARGETS+=" firefox"
	use target_firefox-bin && MZA_TARGETS+=" firefox-bin"
	use target_thunderbird && MZA_TARGETS+=" thunderbird"
	use target_thunderbird-bin && MZA_TARGETS+=" thunderbird-bin"
	use target_seamonkey && MZA_TARGETS+=" seamonkey"
	use target_seamonkey-bin && MZA_TARGETS+=" seamonkey-bin"
fi

RDEPEND="
	!symlink_all_targets? (
		target_firefox? ( www-client/firefox )
		target_firefox-bin? ( www-client/firefox-bin )
		target_seamonkey? ( www-client/seamonkey )
		target_seamonkey-bin? ( www-client/seamonkey-bin )
		target_thunderbird? ( mail-client/thunderbird )
		target_thunderbird-bin? ( mail-client/thunderbird-bin )
	)"
