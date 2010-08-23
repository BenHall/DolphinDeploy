require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'file_manager'

describe FileManager, "swapping configuration" do
  let(:location) {"test"}
  
  before do
    @mvc = FileManager.new
  end
  
  it "should copy the web.config to web.original.config before replacing" do       
    FileUtils.stubs(:mv).with("#{location}/web.systest.config", "#{location}/web.config")
    FileUtils.expects(:cp).with("#{location}/web.config", "#{location}/web.original.config").once
    @mvc.swap_configs(location, :systest)    
  end
  
  it "should rename web.config for environment to web.config" do  
    FileUtils.stubs(:cp).with("#{location}/web.config", "#{location}/web.original.config")
    FileUtils.expects(:mv).with("#{location}/web.systest.config", "#{location}/web.config").once
    @mvc.swap_configs(location, :systest)
  end
end