raise Exception, "Dolphin Deploy is only supported on IronRuby" unless RUBY_ENGINE == 'ironruby'

require 'rubygems'
require 'digest'
require 'config'