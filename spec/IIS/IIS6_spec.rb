require File.join(File.dirname(__FILE__), '../', 'support', 'spec_helper')
require 'lib/configured_as/mvc_deployment'
require 'lib/IIS/IIS6'

describe IIS6, "executing against adsutil" do
  context "Adding additional bindings" do
    it "should get the website id based on the deployment name"
  
    it "should be able to add additional headers via adsutil" do
      pending "Need to hook up CLR mocking"
      
      mvc = MvcDeployment.new
      mvc.site_name = 'test'
      
      IIS6.any_instance.expects(:`).with("cscript external\\adsutil.vbs set w3svc/5/ServerBindings \":80:test.host.header\"").once
      iis = IIS6.new
      iis.set_extra_header ':80:test.host.header', mvc
    end
    
    it "should supports multiple additional headers being defined"
    
    it "should get a list of the existing binding and append to list when setting server bindings" 
  end
end