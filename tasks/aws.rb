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
require 'rubygems'
require 'aws-sdk'

AWS.config({
  :access_key_id     => AWS_ACCESS_KEY_ID, 
  :secret_access_key => AWS_SECRET_ACCESS_KEY
})

def app_name 
  "app-#{NAME}"
end

def build_version
  "build-#{VERSION}"
end

def create_ami ami
  ec2      = AWS::EC2.new
  region   = ec2.regions[REGION]
  instance = region.instances.create({:image_id => ami, :key_name => AWS_KEY_PAIR})
  puts "waiting for instance to be ready"
  while instance.status == :pending
    sleep(5)
  end
  instance.add_tag(app_name)
  instance.add_tag(build_version)
end

def terminate_ami 
  ec2       = AWS::EC2.new
  region    = ec2.regions[REGION]
  instances = region.instances.tagged(app_name, build_version)
  instances.each do |instance|
    instance.terminate()
  end
end

def list_amis
  ec2    = AWS::EC2.new
  region = ec2.regions[REGION]
  images = region.images.with_owner("self")
  images.each do |item|
    puts item.name
  end
end

def tag_ami ami, tags
  puts "tagging ami, #{ami} => #{tags}"
  ec2    = AWS::EC2.new
  region = ec2.regions[REGION]
  image  = region.images[ami]
  tags.each_pair do |key, value|
    image.tag key.to_s, :value => value.to_s
  end
end

