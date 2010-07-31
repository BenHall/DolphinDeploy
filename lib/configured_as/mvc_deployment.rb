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
    set_to env.to 
  end
  
  def set_to(locations)
    self.to = []
  
    i = 0
    while i < locations.length
      location = DeployTo.new
      location.server = locations[i]
      location.path = locations[i + 1]

      self.to << location
      i = i + 2
    end      
  end
end

class DeployTo
  attr_accessor :server
  attr_accessor :path  
end