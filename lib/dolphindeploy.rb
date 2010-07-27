raise Exception, "Dolphin Deploy is only supported on IronRuby" unless RUBY_ENGINE == 'ironruby'

$: << 'configured_as'
require 'rubygems'
require 'digest'
require 'deploymentconfig'
