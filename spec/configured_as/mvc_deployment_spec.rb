require File.join(File.dirname(__FILE__), '../', 'support', 'spec_helper')
$: << 'lib/configured_as'
require 'mvc_deployment'

describe MvcDeployment do 
  describe "defaults"  do
    before do
      @mvc = MvcDeployment.new
    end
    
    it "should have a default description" do
      @mvc.description.should == "MvcDeployment"
    end
    
    it "should have a default port number" do
      @mvc.port.should == 80
    end  
  end
  
  describe "deployment interaction" do
    before do
      @mvc = MvcDeployment.new
    end
    
    it "should call out to IIS6 when deploying to v6"  do
      pending "Not sure how to test this"
      @mvc.deploy()
    end
    
    it "should get the location from config based on the environment being deployed" do
      @mvc.set_to ['server', 'C:/some_location']
      path = @mvc.get_location('server')
      path.should == 'C:/some_location'
    end
  end
  
  describe "when executing" do
    before(:each) do
      FileManager.any_instance.expects(:get_latest_version).returns('')
      FileManager.any_instance.expects(:extract).returns('')
      IIS.any_instance.expects(:deploy).returns('')
      
      @mvc = MvcDeployment.new
      @mvc.set_to ['server', 'test']
      @mvc.set_before({:set_host => 'ABC'})
      @mvc.set_after({:set_port => 99})
    end
    
    it "should call all the methods specified in the before block" do        
      @mvc.deploy('server')
      @mvc.host.should == 'ABC'      
    end
    
    it "should call all the methods specified in the before block" do    
      @mvc.deploy('server')
      @mvc.port.should == 99      
    end
  end
  
  describe "custom extensions" do    
    def create_custom_method()
      MvcDeployment.module_eval do
        attr_accessor :custom_prop
        
        def custom(val)
          self.custom_prop = val
        end
      end
    end
    
    before(:each) do    
      FileManager.any_instance.expects(:get_latest_version).returns('')
      FileManager.any_instance.expects(:extract).returns('')
      IIS.any_instance.expects(:deploy).returns('')
      
      create_custom_method()      
      
      @mvc = MvcDeployment.new
      @mvc.set_to ['server', 'test']
      @mvc.set_before({:custom => 'Random Value'})
    end
    
    it "should call custom methods after deployment"  do
      @mvc.deploy('server')
      @mvc.custom_prop.should == 'Random Value'
    end
  end
  
  describe "executing custom additional host headers"   do
    before(:each) do    
      FileManager.any_instance.expects(:get_latest_version).returns('')
      FileManager.any_instance.expects(:extract).returns('')
      IIS6.any_instance.expects(:deploy).returns('')    
      IIS6.any_instance.expects(:set_extra_header).returns('')    
    end
    
    it "should call add_header on IIS instance" do
      pending "Again... not mocking?"
      mvc = MvcDeployment.new  
      IIS.any_instance.expects(:set_extra_header).returns(nil).once
      
      mvc.set_to ['server', 'test']
      mvc.set_after({:extra_header => 'abc.header'})
      
      mvc.deploy('server')
    end
  end
end