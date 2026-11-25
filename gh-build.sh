#!/usr/bin/env bash

# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2026 <Nitrux Latinoamericana S.C. <hello@nxos.org>>

set -euo pipefail

apt-get update
apt-get install -y --no-install-recommends build-essential devscripts equivs fakeroot git

### Get the upstream asset checksums

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
work_dir=$(mktemp -d)
trap 'rm -rf -- "$work_dir"' EXIT
revision=1c22a9475baa8834fd597ca6fdeee0dafe483ff1

git init -q "$work_dir/source"
cd "$work_dir/source"
git fetch --depth=1 https://github.com/RazeLighter777/pinpam.git "$revision"
git checkout -q --detach "$revision"

### Create packaging directory
cp -r "$repo_root/debian" .

### Install Dependencies
mk-build-deps --install --remove --tool 'apt-get -y --no-install-recommends' debian/control

### Build Deb
dpkg-buildpackage -b -us -uc

### Get the package
cp "$work_dir"/pinpam-module_*.deb "$repo_root/"
