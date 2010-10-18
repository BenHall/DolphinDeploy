require 'caesars'

class Environment < Caesars
end

class DeploymentConfig  < Caesars::Config
  dsl Environment::DSL
end

class Deployment
  def self.load
    conf = "deploy.conf"
    @deployment = DeploymentConfig.new(conf)
  end
end