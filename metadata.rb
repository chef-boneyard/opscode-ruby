name             "opscode-ruby"
maintainer       "Christopher Maier"
maintainer_email "cm@opscode.com"
license          "All rights reserved"
description      "Installs/Configures Ruby for Opscode's infrastructure"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

# This is a community cookbook:
# http://community.opscode.com/cookbooks/rbenv
# https://github.com/RiotGames/rbenv-cookbook
depends "rbenv", "~> 1.6.5"

# This is required to install ruby on windows
depends "7-zip", "~> 1.0.0"
