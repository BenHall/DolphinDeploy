require 'mvc_deployment'

class DeployCommandCreator
  def convert_from_config(config, environment_being_deployed)
    deploy_config = create_object(config)
    
    populate_object_from_config(deploy_config, config, environment_being_deployed)
    
    return deploy_config
  end
  
  private 
  def create_object(config)
    cls_name = config.environment.configured_as
    Kernel.const_get(cls_name.to_s.capitalize + "Deployment").new    
  end
  
  def populate_object_from_config(obj, config, environment_being_deployed)
  
    obj.set_environment(environment_being_deployed)
    
    env = config.environment[environment_being_deployed]
    env.keys.each do |k|
      call_method(obj, k, env[k])
    end
    
  end
  
  def call_method(obj, name, param)
    method_name = "set_" + name.to_s
    obj.send(method_name.to_sym, param)
  end
end