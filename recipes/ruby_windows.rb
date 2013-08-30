#
# Cookbook Name:: opscode-ruby
# Recipe:: ruby_windows
#
# Copyright (C) 2013 Opscode, Inc
#
# All rights reserved - Do Not Redistribute
#

#
# Helper method that can prepares safe windows paths.
#

def windows_safe_path_join(*args)
  ::File.join(args).gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR)
end

def windows_safe_path_expand(arg)
  ::File.expand_path(arg).gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR)
end

# Where to get ruby for windows based on it's version
windows_ruby_urls = {
  "1.9.3-p448" => {
    "ruby_url" => "http://dl.bintray.com/oneclick/rubyinstaller/ruby-1.9.3-p448-i386-mingw32.7z?direct",
    "ruby_checksum" => "e317c1225ccf9fdeba951186f2a546aa",
    "ruby_file_name" => "ruby-1.9.3-p448-i386-mingw32.7z"
  }
}

# Where to get ruby devkit for windows
windows_ruby_devkit_urls = {
  "ruby_dev_kit_url" => "http://github.com/downloads/oneclick/rubyinstaller/DevKit-tdm-32-4.5.2-20110712-1620-sfx.exe",
  "ruby_dev_kit_checksum" => "6230d9e552e69823b83d6f81a5dadc06958d7a17e10c3f8e525fcc61b300b2ef"
}

# Currently we are only supporting installing a single ruby version on windows
if node['opscode-ruby']['versions'].length != 1
  raise "opscode-ruby cookbook currently only supports installing a single version of ruby on windows."
end

# Determine download urls
ruby_version = node['opscode-ruby']['versions'][0]
ruby_download_info = windows_ruby_urls[ruby_version]

if ruby_download_info.nil?
  raise "Can not find windows download information for ruby version '#{ruby_version}'"
end

# Determine the directories which we will unpack ruby
ruby_file_name = ruby_download_info["ruby_file_name"]
installation_directory = windows_safe_path_join(node['opscode-ruby']['windows']['ruby_root'], ruby_version)
file_cache_path = windows_safe_path_expand(Chef::Config[:file_cache_path])
unzip_dir_name = windows_safe_path_join(file_cache_path, File.basename(ruby_file_name, ".7z"))
ruby_package_path = windows_safe_path_join(file_cache_path, ruby_file_name)
zip_bin = windows_safe_path_join(node['7-zip']['home'], "7z.exe")

remote_file ruby_package_path do
  source ruby_download_info['ruby_url']
  checksum ruby_download_info['ruby_checksum']
  not_if { File.exists?(ruby_package_path) }
end

windows_batch "unzip_ruby" do
  code <<-EOH
"#{zip_bin}\" x #{ruby_package_path} -o#{file_cache_path} -r -y
xcopy #{unzip_dir_name} \"#{installation_directory}\" /I /e /y
EOH
  creates "#{installation_directory}/bin/ruby.exe"
  action :run
end

windows_path "#{windows_safe_path_join(installation_directory, "bin")}" do
  action :add
end

gem_bin_path = windows_safe_path_join(installation_directory,"bin","gem")

node['opscode-ruby']['base_gems'].each do |gem|
  gem_package gem do
    gem_binary gem_bin_path
  end
end

if node['opscode-ruby']['windows']['dev_kit_enabled']
  # Install devkit for native compilation during gem installation
  devkit_file_name = ::File.basename(windows_ruby_devkit_urls['ruby_dev_kit_url'])

  template "#{installation_directory}/config.yml" do
    source "config.yml.erb"
    helper(:ruby_dir) { installation_directory }
  end

  remote_file "#{file_cache_path}/#{devkit_file_name}" do
    source windows_ruby_devkit_urls['ruby_dev_kit_url']
    checksum windows_ruby_devkit_urls['ruby_dev_kit_checksum']
  end

  devkit_path = windows_safe_path_join(file_cache_path, devkit_file_name)
  ruby_bin_path = windows_safe_path_join(installation_directory,"bin","ruby.exe")
  dk_rb_path = windows_safe_path_join(installation_directory,"dk.rb")
  
  windows_batch 'install_devkit_and_enhance_ruby' do
    code <<-EOH
    #{devkit_path} -y -o\"#{installation_directory}\"
    cd \"#{installation_directory}\" & \"#{ruby_bin_path}\" \"#{dk_rb_path}\" install
    EOH
    action :run
    not_if { ::File.exists?(dk_rb_path) }
  end
end
