require File.join(File.dirname(__FILE__), '../', 'support', 'spec_helper')
require 'lib/IIS/IIS'
require 'lib/IIS/IIS6'
require 'lib/IIS/IISVersion'

describe IIS do
  it "should executing IIS6 deployment if server is v6" do
    IISVersion.stubs(:current_version).returns("6.0.0.0")
    IIS6.any_instance.expects(:deploy)
    iis = IIS.new
    iis.deploy("", "", "")
  end
end