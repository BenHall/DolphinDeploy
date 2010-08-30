$: << 'external'
load_assembly 'Microsoft.Web.Administration'
include Microsoft::Web::Administration
    
class IIS7
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
    site =  get_website(server, deployment)
    
    return site.length > 0
  end
  
  def apppool_exists?(server, deployment)
    app = get_app_pool(server, deployment)
    
    return app.length > 0
  end
  
  def set_extra_header(server, header, deployment)#NOT DONE
    puts "set_extra_header" + header
    site = get_website(server, deployment)
    
    add_binding(site[0], ip_address, deployment.port, deployment.host)
    
    #    iis.commit_changes
  end
  
  def create_virtual_directory(name, path, deployment)#NOT DONE
    puts "create_virtual_directory" + name
    iis = ServerManager.new  
    sites = iis.sites.select {|s| s.name == deployment.site_name }
    site = sites[0]
    app = site.applications[0]
    
    vdir = app.VirtualDirectories.select {|v| v.Path == "/" + name}
    unless vdir.empty?
      vdir = app.VirtualDirectories.CreateElement();
      vdir.Path = "/" + name;
      vdir.PhysicalPath = path;
      app.VirtualDirectories.Add(vdir);
      site.Applications.Add(app);
      iis.commit_changes
    end
  end
  
  def execute_admin(type, cmd, deployment)
    site = get_website('localhost', deployment)
    cmd = "cscript /nologo external\\adsutil.vbs #{type.to_s} w3svc/#{site.name}/#{cmd}"      
    `#{cmd}`
  end
    
  private
  
  def create_app_pool(server, name)
    iis = ServerManager.new
    iis.application_pools.Add(get_app_pool_name(name));
    iis.commit_changes
  end
  
  def update_website_path(server, location, deployment)   #NOT DONE
    puts "update_website_path"
    iis = ServerManager.new  
    sites = iis.sites.select {|s| s.name == deployment.site_name }
    site = sites[0]
    app = site.applications[0]
    
    vdir = app.VirtualDirectories.select {|v| v.Path == "/"}
    vdir[0].PhysicalPath = convert_path_to_iis_format(location)
    iis.commit_changes
  end
  
  def get_website(server, deployment) 
    iis = ServerManager.new  
    iis.sites.select {|s| s.name == deployment.site_name }
  end
  
  def get_app_pool(server, deployment)
    iis = ServerManager.new      
    app = iis.application_pools.select {|a| a.name == get_app_pool_name(deployment.site_name) }
  end
  
  def create_website(server, location, deployment)
    name = deployment.site_name.to_clr_string
    location = convert_path_to_iis_format(location)
    puts location
    iis = ServerManager.new

    site = iis.sites.CreateElement();
    site.id = get_highest_id(iis)
    site.SetAttributeValue("name", name);
    
    app = site.Applications.CreateElement();
    app.Path = "/".to_clr_string
    app.ApplicationPoolName = get_app_pool_name(deployment.site_name)
    
    vdir = app.VirtualDirectories.CreateElement()
    vdir.Path = "/"
    vdir.PhysicalPath = location
    app.VirtualDirectories.Add(vdir)
    
    site.Applications.Add(app);    
        
    ip_address = deployment.get_deploy_to_location(server)[0].ipaddress
    add_binding(site, ip_address, deployment.port, deployment.host)
    
    iis.sites.Add(site);
    
    iis.commit_changes
  end
  
  def get_highest_id(iis)
    highestId = 0
    iis.sites.each do |s|
      highestId = s.Id  if(s.Id > highestId)        
    end
    highestId + 1
  end
  
  def add_binding(site, ip_address, port, host)
    binding = site.Bindings.CreateElement();
    binding.SetAttributeValue("protocol", "http".to_clr_string);
    binding.SetAttributeValue("bindingInformation", "#{ip_address}:#{port}:#{host}".to_clr_string);
    site.Bindings.Add(binding);
  end
  
  def get_app_pool_name(name)
    "#{name}_AppPool"
  end
  
  def convert_path_to_iis_format(path)
    path.gsub('/','\\').to_clr_string
  end
  
end
