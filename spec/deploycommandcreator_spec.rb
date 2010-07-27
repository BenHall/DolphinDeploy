require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'DeployCommandCreator'

describe "DeployCommandCreator"  do
  def config()
    File.stubs(:read).returns("environment do 
    configured_as :mvc
  env :systest do
    host \"Test\"
    to \"abc\", \"xxx\"
  end
end")
    require 'deploymentconfig'
    
    return Deployment.load()
  end
  
  it "Should create deployment config object based on configuration" do 
    creator = DeployCommandCreator.new()
    mvc = creator.convert_from_config(config, :systest)
    mvc.should_not be_nil
    mvc.class.should == MvcDeployment
  end
  
  it "Should set environment variable" do 
    creator = DeployCommandCreator.new()
    mvc = creator.convert_from_config(config, :systest)
    mvc.environment.should == :systest
  end  
end