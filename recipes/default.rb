#
# Cookbook Name:: opscode-ruby
# Recipe:: default
#
# Copyright (C) 2013 Opscode, Inc
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
when "windows"
  include_recipe "opscode-ruby::ruby_windows"
else
  include_recipe "rbenv::default"
  include_recipe "rbenv::ruby_build"

  node['opscode-ruby']['versions'].each do |v|
    rbenv_ruby v do
      global v == node['opscode-ruby']['global']
    end

    node['opscode-ruby']['base_gems'].each do |gem|
      rbenv_gem gem do
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
end
