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