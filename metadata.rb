name             "opscode-ruby"
maintainer       "Christopher Maier"
maintainer_email "cm@opscode.com"
license          "All rights reserved"
description      "Installs/Configures Ruby for Opscode's infrastructure"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

# This is a community cookbook:
# http://community.opscode.com/cookbooks/rbenv
# https://github.com/RiotGames/rbenv-cookbook
depends "rbenv", "~> 1.4.1"
