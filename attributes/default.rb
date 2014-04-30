#
# Cookbook Name:: opscode-ruby
# Attributes:: default
#
# Copyright 2013, Opscode
#
# All rights reserved - Do Not Redistribute
#

default['opscode-ruby']['versions']  = %w{ 1.9.3-p484 }
default['opscode-ruby']['base_gems'] = %w{ bundler mixlib-shellout }
default['opscode-ruby']['global']    = '1.9.3-p484'

default['opscode-ruby']['windows']['ruby_root']        = "#{ENV['SYSTEMDRIVE']}\\ruby"
default['opscode-ruby']['windows']['ruby_checksum']    = '2dd1bfc4d48a5690480eea94a2b53450a39ef8f46f7d65f9e806485b0b2efdf5'
default['opscode-ruby']['windows']['dev_kit_enabled']  = true
default['opscode-ruby']['windows']['dev_kit_url']      = 'http://github.com/downloads/oneclick/rubyinstaller/DevKit-tdm-32-4.5.2-20111229-1559-sfx.exe'
default['opscode-ruby']['windows']['dev_kit_checksum'] = '6c3af5487dafda56808baf76edd262b2020b1b25ab86aabf972629f4a6a54491'

# OPS-99: We should set a UID for the rbenv user so we don't end up
# with conflicts, since the rbenv recipe doesn't create it as a
# "system" user, so it grabs the latest available UID.
default['opscode-ruby']['rbenv_uid'] = '216'
