class MvcDeployment
  attr_accessor :environment
  attr_accessor :host  
  attr_accessor :to
  
  def populate(config, environment_being_deployed)
    env = config.environment[environment_being_deployed]
    self.environment = environment_being_deployed
    self.host = env.host
    self.to = DeployTo.new
    self.to.server = env.to[0]
    self.to.path = env.to[1]
  end
end

class DeployTo
  attr_accessor :server
  attr_accessor :path  
end