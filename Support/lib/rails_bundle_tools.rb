# Copyright:
#   (c) 2006 syncPEOPLE, LLC.
#   Visit us at http://syncpeople.com/
# Author: Duane Johnson (duane.johnson@gmail.com)
# Description:
#   Collection of Rails / TextMate classes for Ruby.

bundle_lib = ENV['TM_BUNDLE_SUPPORT'] + '/lib'
$LOAD_PATH.unshift(bundle_lib) if ENV['TM_BUNDLE_SUPPORT'] and !$LOAD_PATH.include?(bundle_lib)

require ENV['TM_SUPPORT_PATH'] + '/lib/exit_codes'
require ENV['TM_SUPPORT_PATH'] + '/lib/textmate'
require ENV['TM_SUPPORT_PATH'] + '/lib/ui'

require File.join(File.dirname(__FILE__), %w[rails text_mate])
require File.join(File.dirname(__FILE__), %w[rails rails_path])
require File.join(File.dirname(__FILE__), %w[rails unobtrusive_logger])
require File.join(File.dirname(__FILE__), %w[rails misc])
require File.join(File.dirname(__FILE__), %w[rails inflector])

def ruby(command)
  `/usr/bin/env ruby #{command}`
end

def rails(command)
  `rails #{command}`
end
