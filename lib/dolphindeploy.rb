raise Exception, "Dolphin Deploy is only supported on IronRuby" unless Object.const_defined?(:RUBY_ENGINE) && RUBY_ENGINE == 'ironruby'

$: << 'lib\configured_as'
$: << 'lib\IIS'
require 'rubygems'  #FIX: Apprantly this is bad practice
require 'digest'
require 'deploymentconfig'
require 'deploycommandcreator'
require 'IIS'
require 'unzip'
require 'file_manager'
require 'directory_cleanup'