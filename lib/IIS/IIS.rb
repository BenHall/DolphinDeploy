require 'IISVersion'

class IIS
  def iis
    if(IISVersion.current_version =~ /^6/)
      require 'IIS6'
      version = IIS6.new
    else
      # Temp
      require 'IIS6'
      version = IIS6.new
    end
    
    puts version
    return version
  end
  ### Will be executed on the local box, might be able to refactor 'server' out.
  def deploy(server, location, deployment)
    iis.deploy(server, location, deployment)
  end
  
  def set_extra_header(header, deployment)
    iis.set_extra_header header,deployment
  end
end