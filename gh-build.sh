#!/usr/bin/env bash

# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2026 <Nitrux Latinoamericana S.C. <hello@nxos.org>>

set -euo pipefail

### Get the upstream asset checksums

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
work_dir=$(mktemp -d)
trap 'rm -rf -- "$work_dir"' EXIT
revision=1c22a9475baa8834fd597ca6fdeee0dafe483ff1

git init -q "$work_dir/source"
cd "$work_dir/source"
git fetch --depth=1 https://github.com/RazeLighter777/pinpam.git "$revision"
git checkout -q --detach "$revision"
cp -r "$repo_root/debian" .
dpkg-buildpackage -b -us -uc
cp "$work_dir"/pinpam-module_*.deb "$repo_root/"
