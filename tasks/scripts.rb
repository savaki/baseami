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
require 'erb'

def config
  accessKeyId     = ENV["AMI_ACCESS_KEY_ID"]
  secretAccessKey = ENV["AMI_SECRET_ACCESS_KEY"]
  amiUser         = ENV["AMI_USER"]
  databases       = ENV["AMI_DATABASES"]

  raise "AMI_ACCESS_KEY_ID not set!"     unless accessKeyId     =~ /\S/
  raise "AMI_SECRET_ACCESS_KEY not set!" unless secretAccessKey =~ /\S/
  raise "AMI_USER not set!"              unless amiUser         =~ /\S/
  raise "AMI_DATABASES not set!"         unless databases       =~ /\S/

  {
    :AWS_ACCESS_KEY_ID     => accessKeyId,
    :AWS_SECRET_ACCESS_KEY => secretAccessKey,
    :AMI_USER              => amiUser,
    :AMI_DATABASES         => databases,
    :S3_BUCKET             => S3_BUCKET,
    :S3_REGION             => S3_REGION,
    :SECRET                => SECRET
  }
end


def render_scripts target
  system "mkdir -p #{target}"
  Dir.entries("scripts").each do |file|
    if file =~ /(.*).erb$/
      script = $1

      File.open("#{target}/#{script}", "w") do |io|
        erb = ERB.new(File.open("scripts/#{file}").read)
        io.puts erb.result(binding)
      end

    elsif file =~ /\.sh/
      system "cp scripts/#{file} #{target}"
    end
  end
end
