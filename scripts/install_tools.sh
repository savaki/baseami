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
sudo apt-get update
sudo apt-get --only-upgrade install -y libapt-pkg4.12
for pkg in hosts_1.0_amd64.deb apt-transport-s3_1.1.1ubuntu2_amd64.deb
do
	url="http://d3a9nbnkw85yq1.cloudfront.net/ubuntu/precise/${pkg}"

	echo "downloading ${pkg}, ${url}"
	wget --quiet "${url}"
	
	echo "installing package, ${pkg} => dpkg -i ${pkg}"
	sudo dpkg -i ${pkg}
	
	# remove the file after we're done
	echo "cleaning up package"
	rm -f ${pkg}
done

sudo apt-get install -y s3cmd

