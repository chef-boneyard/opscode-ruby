#
# Cookbook Name:: opscode-ruby
# Recipe:: ruby_windows
#
# Copyright (C) 2013 Opscode, Inc
#
# All rights reserved - Do Not Redistribute
#

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
installation_directory = ::File.join(node['opscode-ruby']['windows']['ruby_root'], ruby_version).gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR)
file_cache_path = ::File.expand_path(Chef::Config[:file_cache_path]).gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR)
unzip_dir_name = "#{file_cache_path}\\" << File.basename(ruby_file_name, ".7z")

remote_file "#{file_cache_path}/#{ruby_file_name}" do
  source ruby_download_info['ruby_url']
  checksum ruby_download_info['ruby_checksum']
  not_if { File.exists?("#{file_cache_path}/#{ruby_file_name}") }
end

windows_batch "unzip_ruby" do
  code <<-EOH
"#{node['7-zip']['home']}\\7z.exe\" x #{file_cache_path}\\#{ruby_file_name} -o#{file_cache_path} -r -y
xcopy #{unzip_dir_name} \"#{installation_directory}\" /I /e /y
EOH
  creates "#{installation_directory}/bin/ruby.exe"
  action :run
end

windows_path "#{installation_directory}\\bin" do
  action :add
end


node['opscode-ruby']['base_gems'].each do |gem|
  gem_package gem do
    gem_binary "#{installation_directory}\\bin\\gem"
  end
end

if node['opscode-ruby']['windows']['dev_kit_enabled']
  # Install devkit for native compilation during gem installation
  devkit_file_name = ::File.basename(windows_ruby_devkit_urls['ruby_dev_kit_url'])

  template "#{installation_directory}/config.yml" do
    source "config.yml.erb"
  end

  remote_file "#{file_cache_path}/#{devkit_file_name}" do
    source windows_ruby_devkit_urls['ruby_dev_kit_url']
    checksum windows_ruby_devkit_urls['ruby_dev_kit_checksum']
  end

  windows_batch 'install_devkit_and_enhance_ruby' do
    code <<-EOH
    #{file_cache_path}\\#{devkit_file_name} -y -o\"#{installation_directory}\"
    cd \"#{installation_directory}\" & \"#{installation_directory}\\bin\\ruby.exe\" \"#{installation_directory}\\dk.rb\" install
    EOH
    action :run
    not_if { ::File.exists?("#{installation_directory}\\dk.rb") }
  end
end
