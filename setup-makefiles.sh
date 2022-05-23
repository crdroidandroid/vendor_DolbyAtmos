#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

INITIAL_COPYRIGHT_YEAR=2022

DOLBYATMOS_COMMON=common
VENDOR=DolbyAtmos

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

ROOT="$MY_DIR/../.."

HELPER="${MY_DIR}/extract-utils/extract_utils.sh"
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

# Initialize the helper
setup_vendor "$DOLBYATMOS_COMMON" "$VENDOR" "$ROOT" true

# Copyright headers and guards
write_headers "xiaomi"
sed -i 's|TARGET_DEVICE|BOARD_VENDOR|g' common/Android.mk
sed -i 's|vendor/DolbyAtmos/|vendor/DolbyAtmos/common|g' $PRODUCTMK
sed -i 's|device/DolbyAtmos//setup-makefiles.sh|vendor/DolbyAtmos/setup-makefiles.sh|g' $ANDROIDBP $ANDROIDMK $BOARDMK $PRODUCTMK

write_makefiles "$MY_DIR"/proprietary-files.txt true

# Finish
write_footers