class MvcDeployment
  attr_accessor :environment
  attr_accessor :host  
  attr_accessor :to
  attr_accessor :port
  attr_accessor :description
  
  def initialize()
    set_defaults
  end

  def set_defaults()
    self.port = 80
    self.description = "MvcDeployment"
  end
  
  def set_description(desc)
    self.description = desc
  end    

  def set_host(header)
    self.host = header
  end

  def set_port(num)
    self.port = num
  end

  def set_environment(env)
    self.environment = env
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
  
  def upload(server)
    
  end
  
  def deploy(server, environment)  
    #iis = IIS.new
    #iis.create()
    #  Execute post deployment steps
    #     Configure ISAPI etc
  end
  
  def swap_configs(env)
    FileUtils.cp 'web.config', 'web.original.config'
    FileUtils.mv "web.#{env.to_s}.config", 'web.config'
  end
end

class DeployTo
  attr_accessor :server
  attr_accessor :path  
end