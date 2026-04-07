# xcsh APT Repository

Debian/Ubuntu package repository for [xcsh](https://github.com/f5xc-salesdemos/xcsh), an AI coding agent for the terminal.

## Install

```bash
# Add the GPG signing key
curl -fsSL https://f5xc-salesdemos.github.io/apt-repo/gpg.key \
  | sudo gpg --dearmor -o /usr/share/keyrings/xcsh-archive-keyring.gpg

# Add the repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/xcsh-archive-keyring.gpg] https://f5xc-salesdemos.github.io/apt-repo stable main" \
  | sudo tee /etc/apt/sources.list.d/xcsh.list > /dev/null

# Install
sudo apt update
sudo apt install xcsh
```

## Upgrade

```bash
sudo apt update
sudo apt upgrade xcsh
```

## Uninstall

```bash
sudo apt remove xcsh
sudo rm /etc/apt/sources.list.d/xcsh.list
sudo rm /usr/share/keyrings/xcsh-archive-keyring.gpg
```

## Supported Architectures

- `amd64` (x86_64)
- `arm64` (aarch64)

## How It Works

This repository is hosted on GitHub Pages and updated automatically when a new xcsh release is published. The workflow downloads Linux binaries from the [xcsh releases](https://github.com/f5xc-salesdemos/xcsh/releases), packages them as `.deb` files, and regenerates the APT repository metadata.

Only the latest version is kept in the repository. For older versions, download directly from [GitHub Releases](https://github.com/f5xc-salesdemos/xcsh/releases).
