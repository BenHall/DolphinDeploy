require 'mvc_deployment'

class DeployCommandCreator
  def convert_from_config(config)
    cls_name = config.environment.configured_as
    Kernel.const_get(cls_name.to_s.capitalize + "Deployment").new
  end
end