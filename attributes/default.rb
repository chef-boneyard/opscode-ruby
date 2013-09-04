#
# Cookbook Name:: opscode-ruby
# Attributes:: default
#
# Copyright 2013, Opscode
#
# All rights reserved - Do Not Redistribute
#

default['opscode-ruby']['versions']  = [ "1.9.3-p385" ]
default['opscode-ruby']['base_gems'] = [ "bundler", "mixlib-shellout" ]
default['opscode-ruby']['global']    = "1.9.3-p385"

default['opscode-ruby']['windows']['ruby_root']       = "#{ENV['SYSTEMDRIVE']}\\ruby"
default['opscode-ruby']['windows']['dev_kit_enabled'] = true
