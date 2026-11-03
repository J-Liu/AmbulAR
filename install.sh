#!/bin/bash
# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright 2026 Jia Liu

# Build target first
./build.sh

xcrun devicectl device install app --device iPhone ~/Library/Developer/Xcode/DerivedData/AmbulAR-hiahkafvabapgbavbwrffatsahxe/Build/Products/Debug-iphoneos/AmbulAR.app
