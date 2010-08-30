$: << 'lib'
require 'dolphindeploy_rake'

namespace :example do
  desc "Example"
  task :run do
    deployment = Deployment.load()    
    creator = DeployCommandCreator.new()
    
    env = :local
    server = 'localhost'
    
    mvc = creator.convert_from_config(deployment, env)
    mvc.deploy server
  end
end


