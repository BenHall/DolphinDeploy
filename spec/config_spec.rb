require File.join(File.dirname(__FILE__), 'support', 'spec_helper')

describe "Configuration loading" do
  File.stubs(:exists?).returns(true)
  
  it "should execute dsl after being required which modifies properties on the object" do
    File.stubs(:read).returns("environment do 
   tester true
end")
    require 'deploymentconfig'
    
    @deployment = Deployment.load()    
    @deployment.environment.tester.should be_true
  end
end

describe "Configuration with multiple properties" do
  File.stubs(:exists?).returns(true)
  
  it "should return correct host for multiple named environments" do
    File.stubs(:read).returns("environment do 
  env :systest do
    host \"www.test.systest\"
  end

  env :uat do
    host \"www.test.uat\"
  end
end")
    require 'deploymentconfig'
    
    @deployment = Deployment.load()    
    @deployment.environment.systest.host.should == "www.test.systest"
    @deployment.environment.uat.host.should == "www.test.uat"
  end
  
  it "should return array of to variables when defining" do
    File.stubs(:read).returns("environment do 
  env :systest do
    to \"abc\", \"xxx\"
  end
end")
    require 'deploymentconfig'
    
    @deployment = Deployment.load()    
    @deployment.environment.systest.to.should == ['abc', 'xxx']
  end
  
  it "should return array concated together when calling it multiple times" do
    File.stubs(:read).returns("environment do 
  env :systest do
    to \"abc\", \"xxx\"
    to \"xyz\", \"123\"
  end
end")
    require 'deploymentconfig'
    
    @deployment = Deployment.load()    
    @deployment.environment.systest.to.should == ['abc', 'xxx', 'xyz', '123']
  end  
end

describe "Configuration with top level properties and sub details" do
  File.stubs(:exists?).returns(true)
  it "should return correct host for multiple named environments" do
    File.stubs(:read).returns("environment do 
    desc \"Deployment 123\"
    setting :test
  env :systest do
    host \"www.test.systest\"
  end

  env :uat do
    host \"www.test.uat\"
  end
end")
    require 'deploymentconfig'
    
    @deployment = Deployment.load()    
    @deployment.environment.desc.should == "Deployment 123"
    @deployment.environment.setting.should == :test
  end
end