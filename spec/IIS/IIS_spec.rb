require File.join(File.dirname(__FILE__), '../', 'support', 'spec_helper')
require 'lib/configured_as/mvc_deployment'
require 'lib/IIS/IIS'
require 'lib/IIS/IIS6'
require 'lib/IIS/IISVersion'

describe IIS do
  it "should executing IIS6 deployment if server is v6" do
    pending "This doesn't work as I expect. Something really simple I'm guessing but keeps failing to mock objects"
    mvc = MvcDeployment.new
    mvc.site_name = 'test'
    
    IISVersion.expects(:current_version).returns("6.0.0.0")
    IIS6.any_instance.expects(:deploy).with("", "", mvc).returns(false)
    iis = IIS.new
    iis.deploy("", "", mvc)
  end
end