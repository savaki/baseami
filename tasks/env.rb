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

AWS_ACCESS_KEY_ID      = ENV["AWS_ACCESS_KEY_ID"]
AWS_SECRET_ACCESS_KEY  = ENV["AWS_SECRET_ACCESS_KEY"]

# the initial user to create that services will run under
AMI_USER               = ENV["AMI_USER"]

# the bucket that contains our deb repository for use with apt-s3
S3_BUCKET              = ENV["S3_BUCKET"]
S3_REGION              = ENV["S3_REGION"]

# the name of the artifact that can be passed from stage to stage
ARTIFACT               = "artifact.json"

# the name of the app for use by ec2 tags
NAME                   = "baseami"

# the name of the file that will contain our basemi information
BASEAMI                = "#{NAME}.json"

# the name of the aws keypair to associate with the test instance
AWS_KEY_PAIR           = "us-west-2"

# which region should the instance be stood up in
region                 = ENV["AMI_REGION"]
region                 = "us-west-2" unless region =~ /\S/
REGION                 = region

# the base ami to use as a starting point
ami                    = ENV["AMI_ID"]
ami                    = "ami-70f96e40" unless ami =~ /\S/
AMI                    = ami

# what instance type to use by default
INSTANCE_TYPE          = "m1.medium"


# the build number for the app
version               = ENV["GO_PIPELINE_COUNTER"]
version               = "SNAPSHOT-#{Time.now.to_i}" unless version =~ /\S/
VERSION               = version


raise "AWS_ACCESS_KEY_ID not set!"     unless AWS_ACCESS_KEY_ID     =~ /\S/
raise "AWS_SECRET_ACCESS_KEY not set!" unless AWS_SECRET_ACCESS_KEY =~ /\S/

raise "AMI_USER not set!"              unless AMI_USER              =~ /\S/
raise "S3_BUCKET not set!"             unless S3_BUCKET             =~ /\S/

