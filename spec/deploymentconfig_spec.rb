require File.join(File.dirname(__FILE__), 'support', 'spec_helper')

describe "Deployment configuration" do 
  describe "Loading" do
    let(:base_env) {"environment do 
       tester true
     end"}
    
    before do 
      File.stubs(:exists?).returns(true)
      File.stubs(:read).returns(base_env)
    end
    
    it "should execute dsl after being required which modifies properties on the object" do  
      require 'deploymentconfig'
      
      @deployment = Deployment.load()    
      @deployment.environment.tester.should be_true
    end
  end
  
  describe "Multiple properties" do
    let(:two_props) {
      "environment do 
         env :systest do
           host \"www.test.systest\"
         end
         env :uat do
           host \"www.test.uat\"
         end
      end"}
      
    let(:env_with_to_location) {
      "environment do 
         env :systest do
           to \"abc\", \"xxx\"
         end
       end"}
      
    let(:env_with_two_to_locations) {
      "environment do 
         env :systest do
           to \"abc\", \"xxx\"
           to \"xyz\", \"123\"
         end
       end"}
      
    before do 
      File.stubs(:exists?).returns(true)            
    end
    
    it "should return correct host for multiple named environments" do    
      File.stubs(:read).returns(two_props)
      require 'deploymentconfig'
      
      @deployment = Deployment.load()    
      @deployment.environment.systest.host.should == "www.test.systest"
      @deployment.environment.uat.host.should == "www.test.uat"
    end
    
    it "should return array of dsl variables containing both parameters" do
      File.stubs(:read).returns(env_with_to_location)
      require 'deploymentconfig'
      
      @deployment = Deployment.load()    
      @deployment.environment.systest.to.should == ['abc', 'xxx']
    end
    
    it "should return array concated together when calling same dsl method multiple times" do
      File.stubs(:read).returns(env_with_two_to_locations)
      require 'deploymentconfig'
      
      @deployment = Deployment.load()    
      @deployment.environment.systest.to.should == ['abc', 'xxx', 'xyz', '123']
    end  
  end
  
  describe "Configuration with top level properties and sub details" do
    let(:desc) {
      "environment do 
         desc \"Deployment 123\"
         setting :test
         env :systest do
           host \"www.test.systest\"
         end
         env :uat do
           host \"www.test.uat\"
         end
       end"}
    
    before do 
      File.stubs(:exists?).returns(true)            
    end    
    
    it "should return correct host for multiple named environments" do
      File.stubs(:read).returns(desc)
      require 'deploymentconfig'
      
      @deployment = Deployment.load()    
      @deployment.environment.desc.should == "Deployment 123"
      @deployment.environment.setting.should == :test
    end
  end
  
  describe "Before block" do
    let(:before){
      "environment do 
         desc \"Deployment 123\"
         setting :test
         env :systest do
           host \"www.test.systest\"
           before do
             value \"xyz\"
           end
         end
       end"}
    
    before(:each) do 
      File.stubs(:exists?).returns(true)  
      File.stubs(:read).returns(before)
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
    let(:single_host_header){
      "environment do 
        desc \"Deployment 123\"
        setting :test
        env :systest do
          host \"www.test.systest\"
          after do
            extra_header 'extra.host.header'
          end
        end
      end"}
    
    let(:extra_additional_header){
      "environment do 
        desc \"Deployment 123\"
        setting :test
        env :systest do
          host \"www.test.systest\"
            after do
              extra_header 'extra.host.header'
              extra_header 'extra2.host.header'
            end
        end
       end"}

    let(:dynamic_header){
      "environment do 
         desc \"Deployment 123\"
         setting :test
         env :systest do
           host \"www.test.systest\"
           after do
              ['extra', 'extra2'].each {|h| extra_header h + '.host.header'}
           end
         end
       end"}
      
    before(:each) do 
      File.stubs(:exists?).returns(true)
    end    
    
    it "should support a single additional host header" do    
      File.stubs(:read).returns(single_host_header)
      require 'deploymentconfig'
      
      @deployment = Deployment.load()    
      @deployment.environment[:systest].after.extra_header.should == 'extra.host.header'
    end
    
    it "should support multiple additional host header" do     
      File.stubs(:read).returns(extra_additional_header)
      require 'deploymentconfig'
      
      @deployment = Deployment.load()    
      @deployment.environment[:systest].after.extra_header.should == ['extra.host.header', 'extra2.host.header']
    end  
    
    it "should support dynamically creating additional host header" do     
      File.stubs(:read).returns(dynamic_header)
      require 'deploymentconfig'
      
      @deployment = Deployment.load()    
      @deployment.environment[:systest].after.extra_header.should == ['extra.host.header', 'extra2.host.header']
    end  
  end
end