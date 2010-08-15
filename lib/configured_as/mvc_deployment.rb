class MvcDeployment
  attr_accessor :environment
  attr_accessor :host  
  attr_accessor :to
  attr_accessor :port
  attr_accessor :ipaddress
  attr_accessor :description
  attr_accessor :site_name
  attr_accessor :deploy_zip_path
  attr_accessor :before
  attr_accessor :after
  
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
  
  def set_ipaddress(address)
    self.ipaddress = address
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
      location.ipaddress = locations[i + 2]

      self.to << location
      i = i + 3
    end      
  end
    
  def set_before(block)
    self.before = block
  end
  
  def set_after(block)
    self.after = block
  end
  
  def extra_header(server, header) #Header will contain array of all the headers being added
    iis = IIS.server
    iis.set_extra_header(server, header, self)
  end
  
  def virtual_directory(server, vDirInfo) #Directories will contain array of all the virtual directories being added    
    iis = IIS.server
    
    i = 0
    while i < vDirInfo.length
      name = vDirInfo[i]
      path = vDirInfo[i + 1]

      iis.create_virtual_directory(name, path, self)
      i = i + 2
    end      
  end  
  
  def cmd(server, command)
    `#{command}`
  end
  
  def iis(server, command)
    iis = IIS.server
    
    i = 0
    while i < command.length
      type = command[i]
      cmd = command[i + 1]

      iis.execute_admin(type, cmd, self)
      i = i + 2
    end      

  end
  
  def get_deploy_to_location(server)
    self.to.select{|t| t.server == server}
  end
  
  def get_location(server)
    servers = get_deploy_to_location(server)
    servers[0].path
  end
    
  def deploy(server)  
    execute_before_methods(server)
        
    location = get_location(server)
    
    fm = FileManager.new
    latest_version_location = fm.get_latest_version(location, self.site_name)
    
    fm.extract(latest_version_location, self.deploy_zip_path, self.environment)
    
    iis = IIS.new
    iis.deploy(server, latest_version_location, self)
    
    execute_after_methods(server)    
  end
   
  def execute_before_methods(server)
    unless self.before.nil?
      self.before.each do |k, v|
        call_method(k, server, v)
      end
    end
  end
  
  def execute_after_methods(server)
    unless self.after.nil?
      self.after.each do |k, v|
        call_method(k, server, v)
      end
    end
  end
  
  def call_method(method_name, server, param)  
    if self.respond_to?(method_name)
      if self.method(method_name).arity == 2
        self.send(method_name, server, param) 
      else
        self.send(method_name, param) 
      end
    end
  end
  
end

class DeployTo
  attr_accessor :server
  attr_accessor :path  
  attr_accessor :ipaddress
end