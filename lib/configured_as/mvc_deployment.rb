class MvcDeployment
  attr_accessor :environment
  attr_accessor :host  
  attr_accessor :to
  attr_accessor :port
  attr_accessor :description
  attr_accessor :site_name
  attr_accessor :deploy_zip_path
  
  def initialize()
    set_defaults
  end

  def set_defaults()
    self.port = 80
    self.description = "MvcDeployment"
  end
  
  def set_name(name)
    self.site_name = name
  end    
  
  def set_deploy(path)
    self.deploy_zip_path = path    
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
  
  def get_location(server)
    servers = self.to.select{|t| t.server == server}
    servers[0].path
  end
    
  def deploy(server)  
    location = get_location(server)
    
    fm = FileManager.new
    latest_version_location = fm.get_latest_version(location, self.site_name)
    
    fm.extract(latest_version_location, self.deploy_zip_path, self.environment)
    
    iis = IIS.new
    iis.deploy(server, latest_version_location, self)
    #  Execute post deployment steps
    #     Configure ISAPI etc
  end
    
end

class DeployTo
  attr_accessor :server
  attr_accessor :path  
end