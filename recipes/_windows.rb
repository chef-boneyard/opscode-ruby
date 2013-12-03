#
# Cookbook Name:: opscode-ruby
# Recipe:: _windows
#
# Copyright (C) 2013 Opscode, Inc
#
# All rights reserved - Do Not Redistribute
#

include_recipe '7-zip'

# Currently we are only supporting installing a single ruby version on windows
unless node['opscode-ruby']['versions'].kind_of?(Array) && node['opscode-ruby']['versions'].size == 1
  fail 'opscode-ruby cookbook currently only supports installing a single version of ruby on windows.'
end

# Determine download urls
ruby_version = node['opscode-ruby']['versions'].first
ruby_file_name = "ruby-#{ruby_version}-i386-mingw32.7z"
ruby_download_url = "http://dl.bintray.com/oneclick/rubyinstaller/#{ruby_file_name}?direct"

# Determine the directories which we will unpack ruby
file_cache_path = windows_safe_path_expand(Chef::Config[:file_cache_path])
unzip_dir_name = windows_safe_path_join(file_cache_path, File.basename(ruby_file_name, '.7z'))
ruby_package_path = windows_safe_path_join(file_cache_path, ruby_file_name)
zip_bin = windows_safe_path_join(node['7-zip']['home'], '7z.exe')

remote_file ruby_package_path do
  source ruby_download_url
  checksum node['opscode-ruby']['windows']['ruby_checksum']
  not_if { File.exists?(ruby_package_path) }
end

install_dir = windows_safe_path_join(node['opscode-ruby']['windows']['ruby_root'], ruby_version)
ruby_bindir = windows_safe_path_join(install_dir, 'bin')
ruby_bin = windows_safe_path_join(ruby_bindir, 'ruby.exe')

windows_batch 'unzip_ruby' do
  code <<-EOH
"#{zip_bin}\" x #{ruby_package_path} -o#{file_cache_path} -r -y
xcopy #{unzip_dir_name} \"#{install_dir}\" /I /e /y
EOH
  creates ruby_bin
  action :run
end

# Ensure Ruby's bin directory is in PATH
windows_path ruby_bindir do
  action :add
end

# Install some 'base' gems
node['opscode-ruby']['base_gems'].each do |gem|
  gem_package gem do
    gem_binary windows_safe_path_join(ruby_bindir, 'gem')
  end
end

# Optionally install Ruby DevKit for native compilation during gem installation
if node['opscode-ruby']['windows']['dev_kit_enabled']

  devkit_file_name = ::File.basename(node['opscode-ruby']['windows']['dev_kit_url'])

  template windows_safe_path_join(install_dir, 'config.yml') do
    source 'config.yml.erb'
    helper(:ruby_dir) { install_dir }
  end

  remote_file windows_safe_path_join(file_cache_path, devkit_file_name) do
    source node['opscode-ruby']['windows']['dev_kit_url']
    checksum node['opscode-ruby']['windows']['dev_kit_checksum']
  end

  devkit_path = windows_safe_path_join(file_cache_path, devkit_file_name)
  dk_rb_path = windows_safe_path_join(install_dir, 'dk.rb')

  windows_batch 'install_devkit_and_enhance_ruby' do
    code <<-EOH
    #{devkit_path} -y -o\"#{install_dir}\"
    cd \"#{install_dir}\" & \"#{ruby_bin}\" \"#{dk_rb_path}\" install
    EOH
    action :run
    not_if { ::File.exists?(dk_rb_path) }
  end
end

# Ensure a certificate authority is available and configured
# https://gist.github.com/fnichol/867550

cert_dir = windows_safe_path_join(install_dir, 'ssl', 'certs')
cacert_file = windows_safe_path_join(cert_dir, 'cacert.pem')

directory cert_dir do
  recursive true
  action :create
end

remote_file cacert_file do
  source 'http://curl.haxx.se/ca/cacert.pem'
  checksum 'f5f79efd63440f2048ead91090eaca3102d13ea17a548f72f738778a534c646d'
  action :create
end

ENV['SSL_CERT_FILE'] = cacert_file

env 'SSL_CERT_FILE' do
  value cacert_file
end
