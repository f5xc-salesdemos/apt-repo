#!/bin/bash
set -euo pipefail

VERSION="$1"   # e.g. 1.3.13-f5xc.1
ARCH="$2"      # amd64 or arm64
TARBALL="$3"   # path to xcsh-linux-*.tar.gz

PKG_DIR="$(mktemp -d)"

# Extract binary
mkdir -p "$PKG_DIR/usr/bin"
tar xzf "$TARBALL" -C "$PKG_DIR/usr/bin/"
chmod 755 "$PKG_DIR/usr/bin/xcsh"

# Compute installed size in KB
BINARY_SIZE_KB=$(du -sk "$PKG_DIR/usr/bin/xcsh" | cut -f1)

# Write control file
mkdir -p "$PKG_DIR/DEBIAN"
cat > "$PKG_DIR/DEBIAN/control" <<EOF
Package: xcsh
Version: ${VERSION}
Architecture: ${ARCH}
Maintainer: F5 XC Sales Demos <noreply@github.com>
Installed-Size: ${BINARY_SIZE_KB}
Section: utils
Priority: optional
Homepage: https://github.com/f5xc-salesdemos/xcsh
Description: AI coding agent for the terminal
 xcsh is an AI-powered coding agent built for the terminal.
 Multi-model AI support, TUI, LSP integration, and plugin system.
EOF

# Build .deb
mkdir -p output
dpkg-deb --build "$PKG_DIR" "output/xcsh_${VERSION}_${ARCH}.deb"

echo "Built: output/xcsh_${VERSION}_${ARCH}.deb"
