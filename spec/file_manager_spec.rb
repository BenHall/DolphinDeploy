require File.join(File.dirname(__FILE__), 'support', 'spec_helper')
require 'file_manager'

describe FileManager, "swapping configuration" do
  before do
    @mvc = FileManager.new
  end
  
  it "should make a web.original.config before replacing file" do   
    FileUtils.stubs(:mv).with('test/web.systest.config', 'test/web.config')
    FileUtils.expects(:cp).with('test/web.config', 'test/web.original.config').once
    @mvc.swap_configs('test', :systest)    
  end
  
  it "should swap config for environment to web.config" do  
    FileUtils.stubs(:cp).with('test/web.config', 'test/web.original.config')
    FileUtils.expects(:mv).with('test/web.systest.config', 'test/web.config').once
    @mvc.swap_configs('test', :systest)
  end
end