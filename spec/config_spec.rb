require File.join(File.dirname(__FILE__), 'support', 'spec_helper')

describe "Configuration loading" do
  it "should execute dsl after being required which modifies properties on the object" do
    File.stubs(:exists?).returns(true)
    File.stubs(:read).returns("environment do 
   tester true
end")
    require 'config'
    
    @deployment = Deployment.load()    
    @deployment.environment.tester.should be_true
  end
end

describe "Configuration with multiple properties" do
  it "should return correct host for multiple named environments" do
    File.stubs(:exists?).returns(true)
    File.stubs(:read).returns("environment do 
  env :systest do
    host \"www.test.systest\"
  end

  env :uat do
    host \"www.test.uat\"
  end
end")
    require 'config'
    
    @deployment = Deployment.load()    
    @deployment.environment.systest.host.should == "www.test.systest"
    @deployment.environment.uat.host.should == "www.test.uat"
  end
end