require File.join(File.dirname(__FILE__), 'support', 'spec_helper')

describe "Configuration loading" do
  it "should execute dsl after being required which modifies properties on the object" do
    require 'config'
    extend Environment::DSL
    environment do
      tester true
    end
        
    @environment.tester.should be_true
  end
end