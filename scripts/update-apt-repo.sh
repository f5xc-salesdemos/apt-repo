#!/bin/bash
set -euo pipefail

REPO_ROOT="$1"  # gh-pages directory

cd "$REPO_ROOT"

# Generate Packages files for each architecture
for arch in amd64 arm64; do
  dir="dists/stable/main/binary-${arch}"
  mkdir -p "$dir"
  dpkg-scanpackages --arch "$arch" pool/ /dev/null > "$dir/Packages"
  gzip -9c "$dir/Packages" > "$dir/Packages.gz"
done

# Generate Release file
apt-ftparchive \
  -o APT::FTPArchive::Release::Origin="f5xc-salesdemos" \
  -o APT::FTPArchive::Release::Label="xcsh" \
  -o APT::FTPArchive::Release::Suite="stable" \
  -o APT::FTPArchive::Release::Codename="stable" \
  -o APT::FTPArchive::Release::Architectures="amd64 arm64" \
  -o APT::FTPArchive::Release::Components="main" \
  release dists/stable/ > dists/stable/Release

# Sign: detached signature
gpg --batch --yes --pinentry-mode loopback \
  -abs -o dists/stable/Release.gpg dists/stable/Release

# Sign: inline signature
gpg --batch --yes --pinentry-mode loopback \
  --clearsign -o dists/stable/InRelease dists/stable/Release

echo "APT repository metadata updated and signed."
