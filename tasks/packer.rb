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

require File.expand_path(File.dirname(__FILE__) + '/env')

def generate_baseami_json
  File.open(BASEAMI, "w") do |io|
    io.puts <<EOF
{
  "builders":[{
    "type": "amazon-ebs",
    "access_key": "#{AWS_ACCESS_KEY_ID}",
    "secret_key": "#{AWS_SECRET_ACCESS_KEY}",
    "region": "#{REGION}",
    "source_ami": "#{AMI}",
    "instance_type": "#{INSTANCE_TYPE}",
    "ssh_username": "ubuntu",
    "ami_name": "baseami build-#{VERSION}"
  }],

  "provisioners": [
    {
      "type": "shell",
      "scripts": [
        "tmp/install_cloud_init.sh",
        "tmp/setup_user.sh",
        "tmp/setup_secret.sh",
        "tmp/install_tools.sh",
        "tmp/install_access_keys.sh",
        "tmp/install_mysql.sh"
      ]
    }
  ]
}
EOF
  end
end

def write_artifact ami
  # write a json file that contains our ami info
  File.open(ARTIFACT, "w") do |io|
    io.puts <<EOF
{
  "name": "baseami",
  "build": "#{VERSION}",
  "ami": "#{ami}"
}      
EOF
  end
end

def build_ami
  ami = ""
  IO.popen("packer build #{BASEAMI}") do |io|
    io.each_line do |line|
      ami = $1 if line =~ /#{REGION}:\s*(\S+)/  # find the name of the ami image
      puts line
    end
  end
  raise "Failed to build AMI!" unless ami =~ /\S/
  ami
end



