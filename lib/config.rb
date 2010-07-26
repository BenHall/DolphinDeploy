require 'caesars'

class Environment < Caesars
end

class DeploymentConfig  < Caesars::Config
  dsl Environment::DSL
end

class Deployment
  def self.load
    conf = File.join(File.dirname(__FILE__), '..\deploy.conf')
    @deployment = DeploymentConfig.new(conf)
  end
end