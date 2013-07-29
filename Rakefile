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

require File.expand_path(File.dirname(__FILE__) + '/tasks/packer')
require File.expand_path(File.dirname(__FILE__) + '/tasks/aws')
require File.expand_path(File.dirname(__FILE__) + '/tasks/scripts')

desc "the default"
task :default do 
  puts "argle bargle"
end

desc "delete temporary files"
task :clean do 
  File.delete(BASEAMI) if File.exist?(BASEAMI)
  File.delete(ARTIFACT) if File.exist?(ARTIFACT)
  system "rm -rf packer_cache"
  system "rm -rf tmp"
end

desc "write install_access_key.sh and setup_user.sh scripts"
task :render_scripts do
  system "mkdir -p tmp"
  File.open("tmp/install_access_keys.sh", "w") do |io| 
    io.puts access_key_script
  end
  File.open("tmp/setup_user.sh", "w") do |io| 
    io.puts setup_user_script
  end
  File.open("tmp/setup_apt.sh", "w") do |io| 
    io.puts setup_apt_script
  end
  File.open("tmp/install_mysql.sh", "w") do |io| 
    io.puts install_mysql_script
  end
  system "chmod +x tmp/*.sh"
end

namespace :vagrant do
  desc "e.g. vagrant up"
  task :up => :render_scripts do 
    system "vagrant up"
  end

  desc "e.g. vagrant destroy"
  task :destroy do 
    system "vagrant destroy"
  end
end

namespace :ami do
  desc "list ami images"
  task :list do
    list_amis
  end 

  desc "create ami"
  task :create do
    config = YAML.load_file(ARTIFACT)
    create_ami config["ami"]
  end

  desc "terminate ami"
  task :terminate do
    config = YAML.load_file(ARTIFACT)
    terminate_ami
  end
end

namespace :packer do 
  desc "e.g. packer build"
  task :build => :generate do 
    ami = build_ami
    tag_ami ami, {:build => VERSION, :name => :baseami, :created => Time.new.strftime("%Y-%m-%d %H:%M")}
    write_artifact ami
  end

  desc "e.g. packer validate"
  task :validate => :generate do 
    system "packer validate #{BASEAMI}"
  end
  
  desc "generate the #{BASEAMI} file"
  task :generate => "render_scripts" do 
    generate_baseami_json
  end
end
