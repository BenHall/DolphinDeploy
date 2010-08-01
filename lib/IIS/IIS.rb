require 'IISVersion'

class IIS
  ### Will be executed on the local box, might be able to refactor 'server' out.
  def deploy(server, location, deployment)
    if(IISVersion.current_version =~ /6/)
      require 'IIS6'
      iis = IIS6.new
    else
      require 'IIS7'
      iis = IIS7.new
    end
    
    iis.deploy(server, location, deployment)
  end
end