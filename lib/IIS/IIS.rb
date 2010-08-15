require 'IISVersion'

class IIS
  def self.server
    if(IISVersion.current_version =~ /^6/)
      require 'IIS6'
      version = IIS6.new
    else
      # Temp
      require 'IIS6'
      version = IIS6.new
    end
    
    return version
  end
  ### Will be executed on the local box, might be able to refactor 'server' out.
  def deploy(server, location, deployment)
    IIS.server.deploy(server, location, deployment)
  end
  
  def set_extra_header(header, deployment)
    IIS.server.set_extra_header header,deployment
  end
end