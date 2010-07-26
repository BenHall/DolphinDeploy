@root_dir = File.expand_path(File.join(File.dirname(__FILE__), "../../"))

$: << File.join(@root_dir, "lib")
$: << File.join(@root_dir, "spec")
$: << File.join(@root_dir, "spec/support")

require 'rubygems'
require 'spec'
require 'digest'
