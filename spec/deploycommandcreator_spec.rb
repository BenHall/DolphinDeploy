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

describe "DeployCommandCreator", "overriding default" do
  def config()
    File.stubs(:read).returns("environment do 
    configured_as :mvc
    desc \"Testing\"
  env :systest do
    host \"Test\"
  end
end")
    require 'deploymentconfig'
    
    return Deployment.load()
  end
  
  before do
    creator = DeployCommandCreator.new()
    @mvc = creator.convert_from_config(config, :systest)
  end
  
  it "should have a description of Testing" do 
    @mvc.description.should == "Testing"
  end
end

describe "DeployCommandCreator with Before and After blocks"  do
  def config()
    File.stubs(:read).returns("environment do 
    configured_as :mvc
  env :systest do
    host \"Test\"
    to \"server\", \"path\"
    to \"server2\", \"path2\"
    
    before do
      set_value 'xyz'
      set_host 'ABC' #Redefines the value before executing... 
    end
    
    after do
      set_exec_something 'abc'
      set_port 99 #Redefines the value after executing... 
    end
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
  
  it "should have a before keys collection containing the method names" do
    @mvc.before.keys.should include :set_value
  end
  
  it "should have a list of before blocks to execute" do
    @mvc.before[:set_value].should == 'xyz'
  end
    
  it "should have an after keys collection containing the method names" do
    @mvc.after.keys.should include :set_exec_something
  end
  
  it "should support multiple calls being specified" do
    @mvc.before.keys.length.should == 2
  end
end

describe "DeployCommandCreator", "supports multiple arguments for method" do
  def config()
    File.stubs(:read).returns("environment do 
    configured_as :mvc
    desc \"Testing\"
  env :systest do
    host \"Test\"
  end
end")
    require 'deploymentconfig'
    
    return Deployment.load()
  end
  
  before do
    creator = DeployCommandCreator.new()
    @mvc = creator.convert_from_config(config, :systest)
  end
  
  it "should have a description of Testing" do 
    @mvc.description.should == "Testing"
  end
end
