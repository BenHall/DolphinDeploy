require File.join(File.dirname(__FILE__), '../', 'support', 'spec_helper')
require 'lib/configured_as/mvc_deployment'
require 'lib/IIS/IIS6'

describe IIS6, "executing against adsutil" do
  it "should be able to add additional headers via adsutil" do
    mvc = MvcDeployment.new
    mvc.site_name = 'test'
    mvc.port = 80
    
    IIS6.any_instance.expects(:`).with("cscript external\\adsutil.vbs set w3svc/5/ServerBindings \":80:test.host.header\"").once
    iis = IIS6.new
    iis.set_extra_header 'test.host.header', mvc
  end
end