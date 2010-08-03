$: << 'external'
load_assembly 'DolphinDeploy.IIS.IIS6'
include DolphinDeploy::IIS::IIS6
    
class IIS6
  def initialize()    
  end
  
  def deploy(server, location, deployment)
    create_app_pool(server, deployment.site_name) #Server is only so we can pull out correct path to deploy too
    create_website(server, location, deployment)
  end
  
  def exists?(server, deployment)
    website = WebsiteController.new
    website.server = server
    website.name = deployment.site_name
    
    return website.exists
  end
  
  private
  
  def create_app_pool(server, name)
    app_pool = AppPoolController.new
    app_pool.server = server  # Always executed on the local box
    app_pool.name = get_app_pool_name(name)
    app_pool.create
  end
  
  def create_website(server, location, deployment)
    website = WebsiteController.new
    website.name = deployment.site_name
    website.app_pool = get_app_pool_name(deployment.site_name)
    website.home_directory = location.gsub('/','\\'); 
    website.port = deployment.port
    website.server = server
        
    website.create
    website.start
  end
    
  def get_app_pool_name(name)
    "#{name}_AppPool"
  end
end