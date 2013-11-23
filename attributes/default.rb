#
# Cookbook Name:: opscode-ruby
# Attributes:: default
#
# Copyright 2013, Opscode
#
# All rights reserved - Do Not Redistribute
#

default['opscode-ruby']['versions']  = [ "1.9.3-p448" ]
default['opscode-ruby']['base_gems'] = %w{ bundler mixlib-shellout }
default['opscode-ruby']['global']    = "1.9.3-p448"

default['opscode-ruby']['windows']['ruby_root']        = "#{ENV['SYSTEMDRIVE']}\\ruby"
default['opscode-ruby']['windows']['ruby_checksum']    = 'e317c1225ccf9fdeba951186f2a546aa'
default['opscode-ruby']['windows']['dev_kit_enabled']  = true
default['opscode-ruby']['windows']['dev_kit_url']      = 'http://github.com/downloads/oneclick/rubyinstaller/DevKit-tdm-32-4.5.2-20110712-1620-sfx.exe'
default['opscode-ruby']['windows']['dev_kit_checksum'] = '6230d9e552e69823b83d6f81a5dadc06958d7a17e10c3f8e525fcc61b300b2ef'
