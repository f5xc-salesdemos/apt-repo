#!/bin/bash
set -euo pipefail

PACKAGE="$1"   # xcsh or oh-my-xcsh
VERSION="$2"   # e.g. 1.3.13-f5xc.1
ARCH="$3"      # amd64 or arm64
TARBALL="$4"   # path to .tar.gz

PKG_DIR="$(mktemp -d)"

# Extract binary
mkdir -p "$PKG_DIR/usr/bin"
tar xzf "$TARBALL" -C "$PKG_DIR/usr/bin/"

# Handle oh-my-xcsh tarball structure (bin/oh-my-xcsh inside tar)
if [ -d "$PKG_DIR/usr/bin/bin" ]; then
  mv "$PKG_DIR/usr/bin/bin/"* "$PKG_DIR/usr/bin/"
  rmdir "$PKG_DIR/usr/bin/bin"
  # Remove package.json if extracted from npm-style tarball
  rm -f "$PKG_DIR/usr/bin/package.json"
fi

chmod 755 "$PKG_DIR/usr/bin/$PACKAGE"

# Compute installed size in KB
BINARY_SIZE_KB=$(du -sk "$PKG_DIR/usr/bin/$PACKAGE" | cut -f1)

# Write control file
mkdir -p "$PKG_DIR/DEBIAN"

if [ "$PACKAGE" = "xcsh" ]; then
  cat > "$PKG_DIR/DEBIAN/control" <<EOF
Package: xcsh
Version: ${VERSION}
Architecture: ${ARCH}
Maintainer: F5 XC Sales Demos <noreply@github.com>
Installed-Size: ${BINARY_SIZE_KB}
Depends: oh-my-xcsh
Section: utils
Priority: optional
Homepage: https://github.com/f5xc-salesdemos/xcsh
Description: AI coding agent for the terminal
 xcsh is an AI-powered coding agent built for the terminal.
 Multi-model AI support, TUI, LSP integration, and plugin system.
EOF

elif [ "$PACKAGE" = "oh-my-xcsh" ]; then
  cat > "$PKG_DIR/DEBIAN/control" <<EOF
Package: oh-my-xcsh
Version: ${VERSION}
Architecture: ${ARCH}
Maintainer: F5 XC Sales Demos <noreply@github.com>
Installed-Size: ${BINARY_SIZE_KB}
Section: utils
Priority: optional
Homepage: https://github.com/f5xc-salesdemos/oh-my-xcsh
Description: Batteries-included xcsh plugin with multi-model orchestration
 oh-my-xcsh is an xcsh plugin providing multi-model agent orchestration,
 parallel background agents, and LSP/AST tools.
EOF
fi

# Build .deb
mkdir -p output
dpkg-deb --build "$PKG_DIR" "output/${PACKAGE}_${VERSION}_${ARCH}.deb"

echo "Built: output/${PACKAGE}_${VERSION}_${ARCH}.deb"
