class MvcDeployment
  attr_accessor :environment
  attr_accessor :host  
  attr_accessor :to
  
  def populate(config, environment_being_deployed)
    # Should be dynamic. Iterate over all the keys and call the method - for example to([]) - passing in the value set. 
    # The method then goes self.to.server etc...
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