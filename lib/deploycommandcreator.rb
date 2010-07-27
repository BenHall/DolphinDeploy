require 'mvc_deployment'

class DeployCommandCreator
  def convert_from_config(config, environment_being_deployed)
    cls_name = config.environment.configured_as
    mvc = Kernel.const_get(cls_name.to_s.capitalize + "Deployment").new
    mvc.populate(config, environment_being_deployed)
    return mvc
  end
end