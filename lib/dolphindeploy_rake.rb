$: << 'lib'
require 'dolphindeploy'

# rake dolphin:deploy [env, server]
# rake deploy['local', 'localhost']

namespace :dolphin do
  desc "Dolphin Deployment"
  task :deploy, :env, :server  do |t, args|
    deployment = Deployment.load()    
    creator = DeployCommandCreator.new()
    
    env = args.env.to_sym
    server = args.server
    
    mvc = creator.convert_from_config(deployment, env)
    mvc.deploy server
    
  end
  
  desc "Clean up output directory"
  task :cleanup, :env, :server  do |t, args|
    deployment = Deployment.load()    
    creator = DeployCommandCreator.new()
    
    env = args.env.to_sym
    server = args.server
    
    mvc = creator.convert_from_config(deployment, env)
    directory_to_clean = mvc.get_location(server)
    
    dir = DirectoryCleanup.new
    dir.remove_last(directory_to_clean, 10)
  end
end
 