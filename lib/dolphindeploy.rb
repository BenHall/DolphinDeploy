raise Exception, "Dolphin Deploy is only supported on IronRuby" unless Object.const_defined?(:RUBY_ENGINE) && RUBY_ENGINE == 'ironruby'

$: << File.join(File.dirname(__FILE__), 'configured_as')
$: << File.join(File.dirname(__FILE__), 'IIS')
$: << File.join(File.dirname(__FILE__), '../external')
require 'rubygems'  #FIX: Apprantly this is bad practice
require 'digest'
require 'mvc_deployment'
require 'deploymentconfig'
require 'deploycommandcreator'
require 'IIS'
require 'unzip'
require 'file_manager'
require 'directory_cleanup'