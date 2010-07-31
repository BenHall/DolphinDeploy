require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'mvc_deployment'

describe MvcDeployment, "defaults"  do
  it "should have a default description" do
    @mvc.description.should == "MvcDeployment"
  end
  
  it "should have a default port number" do
    @mvc.port.should == 80
  end"
  
  
end

describe MvcDeployment, "deployment"  do
  it "should call out to "  
end