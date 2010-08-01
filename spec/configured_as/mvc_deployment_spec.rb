require File.join(File.dirname(__FILE__), '../', 'support', 'spec_helper')
$: << 'lib/configured_as'
require 'mvc_deployment'

describe MvcDeployment, "defaults"  do
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

describe MvcDeployment, "deployment"  do
  before do
    @mvc = MvcDeployment.new
  end
  
  it "should call out to IIS6"  do
    pending "Not sure how to test this"
    @mvc.deploy()
  end
  
  it "should get the location based on the environment" do
    @mvc.set_to ['server', 'C:/some_location']
    path = @mvc.get_location('server')
    path.should == 'C:/some_location'
  end
end


describe MvcDeployment, "swapping configuration" do
  before do
    @mvc = MvcDeployment.new
    @mvc.environment = :systest
  end
  
  it "should make a web.original.config before replacing file" do   
    FileUtils.stubs(:mv).with('web.systest.config', 'web.config')
    FileUtils.expects(:cp).with('web.config', 'web.original.config').once
    @mvc.swap_configs()
  end
  
  it "should swap config for environment to web.config" do  
    FileUtils.stubs(:cp).with('web.config', 'web.original.config')
    FileUtils.expects(:mv).with('web.systest.config', 'web.config').once
    @mvc.swap_configs()
  end
end