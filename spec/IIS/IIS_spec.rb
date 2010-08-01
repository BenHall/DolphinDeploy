require File.join(File.dirname(__FILE__), '../', 'support', 'spec_helper')
require 'lib/IIS/IIS'
require 'lib/IIS/IIS6'
require 'lib/IIS/IISVersion'

describe IIS do
  it "should executing IIS6 deployment if server is v6" do
    IISVersion.stubs(:current_version).returns("6.0.0.0")
    IIS6.any_instance.stubs(:deploy).returns(false)
    iis = IIS.new
    mvc = MvcDeployment.new
    mvc.site_name = 'test'
    pending "Not sure how to test this"
    iis.deploy("", "", mvc)
  end
end