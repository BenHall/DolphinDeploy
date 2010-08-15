$: << 'external'
load_assembly 'DolphinDeploy.IIS.IIS6'
load_assembly 'System.DirectoryServices'
include DolphinDeploy::IIS::IIS6
include System::DirectoryServices
    
class IIS6  
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
  
  def set_extra_header(header, deployment)
    site = get_website('localhost', deployment)
    
    header.each do |h|
      existing_headers = get_existing_headers(site)
      header_arg = ""
      
      existing_headers.each {|e| header_arg << "\"#{e}\" "}
      
      cmd = "cscript /nologo external\\adsutil.vbs set w3svc/#{site.name}/ServerBindings \"#{h}\" #{header_arg}"      
      `#{cmd}`
    end
  end
  
  def create_virtual_directory(name, path, deployment)
    site = get_website('localhost', deployment)
    cmd = "cscript /nologo external\\adsutil.vbs CREATE w3svc/#{site.name}/root/#{name} \"IIsWebVirtualDir\""    
    `#{cmd}`
    
    cmd = "cscript /nologo external\\adsutil.vbs  SET w3svc/#{site.name}/root/#{name}/path #{path}"    
    `#{cmd}`
  end
    
  private
  
  def get_existing_headers(site)
#ServerBindings                  : (LIST)  (3 Items)
#  ":80:local.testlocal2.test"
#  ":80:test"
#  ":80:test2"
    cmd = "cscript /nologo external\\adsutil.vbs get w3svc/#{site.name}/ServerBindings"
    result = `#{cmd}`
    headers = result.to_a[1..-1].join
    
    headers = clean_output(headers)
    
    return headers
  end
  
  def clean_output(output)
    result = []
    
    output.each do |o|
      result << o.strip.gsub("\n", "")
    end
    
    return result
  end
  
  def create_app_pool(server, name)
    app_pool = AppPoolController.new
    app_pool.server = server  # Always executed on the local box
    app_pool.name = get_app_pool_name(name)
    app_pool.create
  end
  
  def update_website_path(server, location, deployment)  
    site = get_website(server, deployment)    
    
    path = "IIS://localhost/w3svc/#{site.name}/ROOT"
    root_site = DirectoryEntry.new(path.to_clr_string)
    root_site.Properties['Path'][0] = location.gsub('/','\\').to_clr_string
    root_site.commit_changes()
  end
  
  def get_website(server, deployment)
    website = WebsiteController.new
    website.name = deployment.site_name
    website.server = server
    website.get_website()
  end
  
  def create_website(server, location, deployment)
    website = WebsiteController.new
    website.name = deployment.site_name
    website.app_pool = get_app_pool_name(deployment.site_name)
    website.home_directory = location.gsub('/','\\'); 
    website.port = deployment.port
    website.IpAddress = deployment.ipaddress
    website.host_header = deployment.host
    website.server = server
        
    website.create
    website.start
  end
    
  def get_app_pool_name(name)
    "#{name}_AppPool"
  end
end