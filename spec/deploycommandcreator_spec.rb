require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'DeployCommandCreator'

describe "DeployCommandCreator"  do
  def config()
    File.stubs(:read).returns("environment do 
    configured_as :mvc
  env :systest do
    host \"Test\"
    to \"server\", \"path\"
    to \"server2\", \"path2\"
  end
end")
    require 'deploymentconfig'
    
    return Deployment.load()
  end
  
  before do
    creator = DeployCommandCreator.new()
    @mvc = creator.convert_from_config(config, :systest)
  end
  
  it "should create deployment config object based on configuration" do 
    @mvc.should_not be_nil
    @mvc.class.should == MvcDeployment
  end
  
  it "should set environment variable" do
    @mvc.environment.should == :systest
  end  
  
  it "should set the host variable" do 
    @mvc.host.should == "Test"
  end  
  
  it "should set the to variable" do 
    @mvc.to[0].server.should == "server"
    @mvc.to[0].path.should == "path"
  end    
  
  it "should set the to variable with both values" do 
    @mvc.to[0].server.should == "server"
    @mvc.to[0].path.should == "path"
    
    @mvc.to[1].server.should == "server2"
    @mvc.to[1].path.should == "path2"
  end    
end