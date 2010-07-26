require File.join(File.dirname(__FILE__), 'support', 'spec_helper')

describe "Loading Dolphin Deploy" do
  it "should raise exception when RUBY_ENGINE is not IronRuby" do  
    Object.send(:remove_const, :RUBY_ENGINE)
    lambda {require 'dolphindeploy'}.should raise_exception
  end
  
  it "should load successfully when running as IronRuby" do
    RUBY_ENGINE = 'ironruby'
    require 'dolphindeploy'
  end
end