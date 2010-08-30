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
  
  def set_extra_header(server, header, deployment)
    iis = ServerManager.new  
    sites = iis.sites.select {|s| s.name == deployment.site_name }
    
    header.each do |h|
      ip = deployment.get_deploy_to_location(server)[0].ipaddress
      
      header_broken_down = h.split(":")
      port = header_broken_down[0]
      host = header_broken_down[1]
      add_binding(sites[0], ip, port, host)
    end
    
    iis.commit_changes
  end
  
  def create_virtual_directory(name, path, deployment)  
    iis = ServerManager.new  
    sites = iis.sites.select {|s| s.name == deployment.site_name }
    site = sites[0]
    app = site.applications[0]
    
    root = app.virtual_directories.select {|v| v.path == "/" }
    vdir_requested_to_create = app.virtual_directories.select {|v| v.path == "/" + name}
  
    if vdir_requested_to_create.empty?
      vdir = app.virtual_directories.create_element()
      vdir.path = "/" + name
      vdir.physical_path = File.join(root[0].physical_path, path)
      app.virtual_directories.add(vdir)
      iis.commit_changes
    end
  end
  
  def execute_admin(type, cmd, deployment)
    iis = ServerManager.new  
    sites = iis.sites.select {|s| s.name == deployment.site_name }
    site = sites[0]    
    cmd = "cscript /nologo external\\adsutil.vbs #{type.to_s} w3svc/#{site.name}/#{cmd}"      
    `#{cmd}`
  end
    
  private
  
  def create_app_pool(server, name)
    iis = ServerManager.new
    iis.application_pools.Add(get_app_pool_name(name));
    iis.commit_changes
  end
  
  def update_website_path(server, location, deployment)    
    iis = ServerManager.new  
    sites = iis.sites.select {|s| s.name == deployment.site_name }
    site = sites[0]
    app = site.applications[0]
    
    vdir = app.virtual_directories.select {|v| v.Path == "/"}
    vdir[0].physical_path = convert_path_to_iis_format(location)
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
    iis = ServerManager.new

    site = iis.sites.CreateElement();
    site.id = get_highest_id(iis)
    site.SetAttributeValue("name", name);
    
    app = site.Applications.CreateElement();
    app.path = "/".to_clr_string
    app.ApplicationPoolName = get_app_pool_name(deployment.site_name)
    
    vdir = app.virtual_directories.CreateElement()
    vdir.path = "/"
    vdir.physical_path = location
    app.virtual_directories.add(vdir)
    
    site.applications.add(app);    
        
    ip_address = deployment.get_deploy_to_location(server)[0].ipaddress
    add_binding(site, ip_address, deployment.port, deployment.host)
    
    iis.sites.add(site);
    
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
    binding = site.bindings.create_element();
    binding.SetAttributeValue("protocol", "http".to_clr_string);
    binding.SetAttributeValue("bindingInformation", "#{ip_address}:#{port}:#{host}".to_clr_string);
    site.bindings.add(binding);
  end
  
  def get_app_pool_name(name)
    "#{name}_AppPool"
  end
  
  def convert_path_to_iis_format(path)
    path.gsub('/','\\').to_clr_string
  end
  
end
