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


describe "Before and After blocks" do
  File.stubs(:exists?).returns(true)
  
  before(:each) do
    File.stubs(:read).returns("environment do 
      desc \"Deployment 123\"
      setting :test
      env :systest do
          host \"www.test.systest\"
          before do
            value \"xyz\"
          end
        end
      end")
    require 'deploymentconfig'
  end
  
  it "should return set of keys defined in the before block" do    
    @deployment = Deployment.load()    
    @deployment.environment[:systest].before[:value].should == 'xyz'
  end
  
  it "should support accessing values as properties" do
    @deployment = Deployment.load()    
    @deployment.environment[:systest].before.value.should == 'xyz'    
  end
end


describe "Host Headers" do
  File.stubs(:exists?).returns(true)
    
  it "should support a single additional host header" do    
    File.stubs(:read).returns("environment do 
      desc \"Deployment 123\"
      setting :test
      env :systest do
          host \"www.test.systest\"
          after do
            extra_header 'extra.host.header'
          end
        end
      end")
    require 'deploymentconfig'
    
    @deployment = Deployment.load()    
    @deployment.environment[:systest].after.extra_header.should == 'extra.host.header'
  end
  
  it "should support multiple additional host header" do     
    File.stubs(:read).returns("environment do 
      desc \"Deployment 123\"
      setting :test
      env :systest do
          host \"www.test.systest\"
          after do
            extra_header 'extra.host.header'
            extra_header 'extra2.host.header'
          end
        end
      end")
    require 'deploymentconfig'
    
    @deployment = Deployment.load()    
    @deployment.environment[:systest].after.extra_header.should == ['extra.host.header', 'extra2.host.header']
  end  
  
  it "should support dynamically creating additional host header" do     
    File.stubs(:read).returns("environment do 
      desc \"Deployment 123\"
      setting :test
      env :systest do
          host \"www.test.systest\"
          after do
            ['extra', 'extra2'].each {|h| extra_header h + '.host.header'}
          end
        end
      end")
    require 'deploymentconfig'
    
    @deployment = Deployment.load()    
    @deployment.environment[:systest].after.extra_header.should == ['extra.host.header', 'extra2.host.header']
  end  
end