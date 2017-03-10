# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

BENTOO_SOURCE_REVISION=""
inherit bentoo-kernel savedconfig

DESCRIPTION="Bentoo Linux kernel modules"
KEYWORDS="amd64 arm64"
RDEPEND="!<sys-kernel/bentoo-kernel-4.6.3-r1"

src_prepare() {
	restore_config build/.config
	if [[ ! -f build/.config ]]; then
		local archconfig="$(find_archconfig)"
		local commonconfig="$(find_commonconfig)"
		elog "Building using config ${archconfig} and ${commonconfig}"
		cat "${archconfig}" "${commonconfig}" >> build/.config || die
	fi

	# Check that an old pre-ebuild-split config didn't leak in.
	grep -q "^CONFIG_INITRAMFS_SOURCE=" build/.config && \
		die "CONFIG_INITRAMFS_SOURCE must be removed from kernel config"
}

src_compile() {
	# Generate module signing key
	setup_keys

	# Build both vmlinux and modules (moddep checks symbols in vmlinux)
	kmake vmlinux modules
}

src_install() {
	# Install modules to /, assuming USE=symlink-usr
	# Install firmware to a temporary (bogus) location.
	# The linux-firmware package will be used instead.
	# Stripping must be done here, not portage, to preserve sigs.
	kmake INSTALL_MOD_PATH="${D}" \
		  INSTALL_MOD_STRIP="--strip-unneeded" \
		  INSTALL_FW_PATH="${T}/fw" \
		  modules_install

	# Clean up the build tree
	shred_keys
	kmake clean
	find "build/" -type d -empty -delete || die
	rm "build/.config.old" || die

	# Install /lib/modules/${KV_FULL}/{build,source}
	install_build_source

	# Not strictly required but this is where we used to install the config.
	dodir "/boot"
	local build="lib/modules/${KV_FULL}/build"
	dosym "../${build}/.config" "/boot/config-${KV_FULL}"
	dosym "../${build}/.config" "/boot/config"
}
