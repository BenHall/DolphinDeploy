require 'mvc_deployment'

class DeployCommandCreator
  def convert_from_config(config, env)
    cls_name = config.environment.configured_as
    mvc = Kernel.const_get(cls_name.to_s.capitalize + "Deployment").new
    mvc.environment = env
    
    return mvc
  end
end