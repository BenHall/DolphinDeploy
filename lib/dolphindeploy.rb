raise Exception, "Dolphin Deploy is only supported on IronRuby" unless Object.const_defined?(:RUBY_ENGINE) && RUBY_ENGINE == 'ironruby'

$: << 'configured_as'
require 'rubygems'
require 'digest'
require 'deploymentconfig'
