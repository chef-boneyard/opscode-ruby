#
# Cookbook Name:: opscode-ruby
# Library:: helper
#
# Copyright (C) 2013 Opscode, Inc
#
# All rights reserved - Do Not Redistribute
#

module OpscodeRuby
  module Helper
    #
    # Helper method that can prepares safe windows paths.
    #

    def windows_safe_path_join(*args)
      ::File.join(args).gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR)
    end

    def windows_safe_path_expand(arg)
      ::File.expand_path(arg).gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR)
    end

  end
end

Chef::Recipe.send(:include, OpscodeRuby::Helper)
