#
# Cookbook Name:: opscode-ruby
# Recipe:: default
#
# Copyright (C) 2013 Opscode, Inc
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

ruby_versions = ["1.9.3-p385"]
base_gems = %w{ bundler mixlib-shellout }

ruby_versions.each do |v|
  rbenv_ruby v do
    global true
  end

  base_gems.each do |g|
    rbenv_gem g do
      ruby_version v
    end
  end
end

# link rbenv's shims for the ruby toolchain into a known path
%w{ bundle erb gem irb rake rdoc ri ruby testrb }.each do |shim|
  user_local_path = "/usr/local/bin/#{shim}"
  link user_local_path do
    to ::File.join(node['rbenv']['root'], "shims", shim)
  end
end
