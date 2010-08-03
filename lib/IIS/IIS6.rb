$: << 'external'
load_assembly 'DolphinDeploy.IIS.IIS6'
load_assembly 'System.DirectoryServices'
include DolphinDeploy::IIS::IIS6
include System::DirectoryServices
    
class IIS6
  def initialize()    
  end
  
  def deploy(server, location, deployment)
    unless apppool_exists?(server, deployment)
      create_app_pool(server, deployment.site_name) #Server is only so we can pull out correct path to deploy too
    end
    
    if(website_exists?(server, deployment))
      update_website_path(server, location, deployment)
    else
      create_website(server, location, deployment)
    end
  end
  
  def website_exists?(server, deployment)
    website = WebsiteController.new
    website.server = server
    website.name = deployment.site_name
    
    return website.exists
  end
  
  def apppool_exists?(server, deployment)
    app_pool = AppPoolController.new
    app_pool.server = server
    app_pool.name = get_app_pool_name(deployment.site_name)
    
    return app_pool.exists
  end
  
  private
  
  def create_app_pool(server, name)
    app_pool = AppPoolController.new
    app_pool.server = server  # Always executed on the local box
    app_pool.name = get_app_pool_name(name)
    app_pool.create
  end
  
  def update_website_path(server, location, deployment)  
    website = WebsiteController.new
    website.name = deployment.site_name
    website.server = server
    site = website.get_website()
    
    path = "IIS://localhost/w3svc/#{site.name}/ROOT"
    root_site = DirectoryEntry.new(path.to_clr_string)
    root_site.Properties['Path'][0] = location.to_clr_string
    root_site.commit_changes()
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