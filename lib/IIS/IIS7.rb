class IIS7
  
  def deploy(server, location, deployment)
  end
  
  def exists?(server, deployment)
  end
  
  private
  
  def create_app_pool(server, name)
  end
  
  def create_website(server, location, deployment)
  end
    
  def get_app_pool_name(name)
    "#{name}_AppPool"
  end
end