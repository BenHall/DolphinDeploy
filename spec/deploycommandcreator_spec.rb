require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'DeployCommandCreator'

describe "DeployCommandCreator"  do
  def config()
    File.stubs(:read).returns("environment do 
    configured_as :mvc
  env :systest do
    host \"Test\"
    to \"server\", \"path\"
  end
end")
    require 'deploymentconfig'
    
    return Deployment.load()
  end
  
  before do
    creator = DeployCommandCreator.new()
    @mvc = creator.convert_from_config(config, :systest)
  end
  
  it "Should create deployment config object based on configuration" do 
    @mvc.should_not be_nil
    @mvc.class.should == MvcDeployment
  end
  
  it "Should set environment variable" do
    @mvc.environment.should == :systest
  end  
  
  it "Should set the host variable" do 
    @mvc.host.should == "Test"
  end  
  
  it "Should set the to variable" do 
    @mvc.to.server.should == "server"
    @mvc.to.path.should == "path"
  end    
end