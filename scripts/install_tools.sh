#!/bin/bash

#   Copyright 2013 Matt Ho
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

set -u
set -e

#---------------------------------------------------------------------------
# install the s3 utility for uploading / downloading content to s3
#---------------------------------------------------------------------------
cat <<EOF | sudo tee -a /etc/apt/sources.list
deb http://archive.mattho.com/ precise universe
EOF

sudo apt-get update
sudo apt-get --only-upgrade install -y libapt-pkg4.12
for pkg in s3cp hosts apt-transport-s3 secret-tool
do
	sudo apt-get install -y --force-yes ${pkg}
done

sudo apt-get install -y nmap

